import 'package:delivery_app/core/constant/string_constants.dart';
import 'package:flutter/material.dart';

class IconUtils {
  static IconData getAddressTypeIcon(String type) {
    switch (type) {
      case homeString:
        return Icons.home;
      case workString:
        return Icons.work;
      default:
        return Icons.location_on;
    }
  }
}
