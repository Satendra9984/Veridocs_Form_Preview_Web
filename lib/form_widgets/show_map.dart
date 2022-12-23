// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class ShowMapScreen extends StatefulWidget {
//   final double lat, longi;
//   const ShowMapScreen({
//     Key? key,
//     required this.lat,
//     required this.longi,
//   }) : super(key: key);
//
//   @override
//   State<ShowMapScreen> createState() => _ShowMapScreenState();
// }
//
// class _ShowMapScreenState extends State<ShowMapScreen> {
//   late Map<MarkerId, Marker> _marker = <MarkerId, Marker>{};
//   late GoogleMapController _googleMapController;
//
//   void _onMapCreated(GoogleMapController controller) {
//     _googleMapController = controller;
//
//     final marker = Marker(
//       markerId: MarkerId("1"),
//       position: LatLng(widget.lat, widget.longi),
//     );
//
//     setState(() {
//       _marker[MarkerId("1")] = marker;
//     });
//   }
//
//   late final LatLng _center;
//   @override
//   void initState() {
//     // TODO: implement initState
//     _center = LatLng((widget.lat), (widget.longi));
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: _center,
//           zoom: 11.0,
//         ),
//         markers: _marker.values.toSet(),
//       ),
//     );
//   }
// }
