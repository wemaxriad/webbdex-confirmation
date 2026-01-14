import 'package:intl/intl.dart';
import 'package:flutter/material.dart';



String formatMonthYear(String isoDate) {
  if(isoDate =='') {
    return '';
  }
  final dateTime = DateTime.parse(isoDate).toLocal();
  return DateFormat('MMM yyyy').format(dateTime);
}