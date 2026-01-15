import 'package:intl/intl.dart';
import 'package:flutter/material.dart';



String formatMonthYear(String isoDate) {
  if(isoDate =='') {
    return '';
  }
  final dateTime = DateTime.parse(isoDate).toLocal();
  return DateFormat('MMM yyyy').format(dateTime);
}

String formatCountryPhoneNumber(String phone) {
  phone = phone.replaceAll(RegExp(r'\D'), '');

  if (phone.startsWith('0')) {
    return '+880${phone.substring(1)}';
  }
  if (phone.startsWith('880')) {
    return '+$phone';
  }
  return phone;
}