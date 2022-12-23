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
// Widget _getLabel() {
//   String label = widget.widgetJson['label'];
//
//   return Row(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Text(
//         label,
//         softWrap: true,
//         style: const TextStyle(
//           fontSize: 17,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       SizedBox(width: 5),
//       if (widget.widgetJson.containsKey('required') &&
//           widget.widgetJson['required'] == true)
//         Text(
//           '*',
//           softWrap: true,
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//             color: Colors.redAccent.shade200,
//           ),
//         ),
//     ],
//   );
// }
