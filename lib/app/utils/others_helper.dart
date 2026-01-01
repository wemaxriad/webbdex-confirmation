import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'responsive.dart';
import 'constant_colors.dart';


//===========================>

showLoading(Color? color) {
  return SpinKitThreeBounce(
    color: color ?? primaryColor,
    size: 16.0,
  );
}

void showToast(String msg, Color? color) {
  Fluttertoast.cancel();
  var tsProvider = '';
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

// snackbar
showSnackBar(BuildContext context, String msg, color) {
  var snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: color,
    duration: const Duration(milliseconds: 2000),
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void toastShort(String msg, Color color) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
