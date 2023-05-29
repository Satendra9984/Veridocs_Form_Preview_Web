import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:geolocator/geolocator.dart';

class FormGeoTagImageInputHelper extends StatelessWidget {
  final Position userPosition;
  final String userAddress;
  final Uint8List image;
  final DateTime currentDateTime;
  FormGeoTagImageInputHelper({
    Key? key,
    required this.userPosition,
    required this.userAddress,
    required this.image,
    required this.currentDateTime,
  }) : super(key: key);

  final GlobalKey _globalKey = GlobalKey();

  Future<void> _getTaggedImageScreenshot(BuildContext context) async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image bimage = await boundary.toImage();
    final ByteData? byteData =
        await bimage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    Navigator.of(context).pop(pngBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.cancel),
          ),
          IconButton(
            onPressed: () async {
              await _getTaggedImageScreenshot(context);
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _globalKey,
        child: Stack(
          children: [
            // Image widget
            Image.memory(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            // Overlay widget
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.black.withOpacity(0.75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$userAddress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Coordinates: ${userPosition.latitude}° N, ${userPosition.longitude}° W',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '${_getWeekday(currentDateTime.weekday)}, ${currentDateTime.hour}:${currentDateTime.minute}:${currentDateTime.second} ${currentDateTime.hour < 13 ? 'AM' : 'PM'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Sunday';
    }
  }
}
