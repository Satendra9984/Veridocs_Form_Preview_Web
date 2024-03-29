import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

navigatePush(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

navigatePushReplacement(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

navigatePushRemoveUntil(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false);
}

navigatePushReplacementNamed(BuildContext context, String routeName) {
  Navigator.of(context).pushReplacementNamed(routeName);
}

navigatePop(
  BuildContext context,
) {
  Navigator.pop(context);
}

Color getStatusColour(String status) {
  // debugPrint('status --> $status\n\n');
  if (status == 'pending_verification') {
    return Colors.pinkAccent;
  } else if (status == 'working') {
    return Colors.orange;
  } else if (status == 'completed') {
    return CupertinoColors.activeGreen;
  } else if (status == 'assigned') {
    return Colors.yellow;
  } else if (status == 'rejected') {
    // TODO: rejected case
    return Colors.red;
  }
  return Colors.redAccent.shade700;
}

String prettyJson(dynamic json) {
  var spaces = ' ' * 4;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}
