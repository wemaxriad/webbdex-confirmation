import 'package:intl/intl.dart';
import 'package:flutter/material.dart';



String formatMonthYear(String isoDate) {
  if(isoDate =='') {
    return '';
  }
  final dateTime = DateTime.parse(isoDate).toLocal();
  return DateFormat('MMM yyyy').format(dateTime);
}

String formatCountryPhoneNumber(String phone,phoneCode) {
  phone = phone.replaceAll(RegExp(r'\D'), '');

  if (phone.startsWith('0')) {
    return '$phoneCode${phone.substring(1)}';
  }

  return phone;
}

String formatToE164(String phone, String phoneCode) {
  phone = phone.trim();

  // remove spaces, dashes, brackets
  phone = phone.replaceAll(RegExp(r'[^\d+]'), '');

  // already correct
  if (phone.startsWith('+')) {
    return phone;
  }

  // remove 00 international prefix
  if (phone.startsWith('00')) {
    phone = phone.substring(2);
  }

  // remove country code if duplicated
  final cleanCode = phoneCode.replaceAll('+', '');
  if (phone.startsWith(cleanCode)) {
    return '+$phone';
  }

  // remove leading 0 (local number)
  if (phone.startsWith('0')) {
    phone = phone.substring(1);
  }

  return '$phoneCode$phone';
}
