import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../utils/constant_colors.dart';

Widget buttonPrimary(
    String title,
    VoidCallback pressed, {
      RxBool? isloading, // Reactive loading state from controller
      Color? bgColor,
      double paddingVertical = 18,
      double borderRadius = 8,
      double fontsize = 14,
      Color fontColor = Colors.white,
    }) {
  return Obx(() {
    final loading = isloading?.value ?? false;

    return InkWell(
      onTap: loading ? null : pressed,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: paddingVertical),
        decoration: BoxDecoration(
          color: bgColor ?? primaryColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: loading
            ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
            : Text(
          title.tr,  // Using GetX translation
          style: TextStyle(
            color: fontColor,
            fontSize: fontsize,
          ),
        ),
      ),
    );
  });
}