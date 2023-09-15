import 'package:flutter/material.dart';
import 'package:it_figures/constants.dart';

class ResponsiveUtils {
  static T largeSmall<T>(BuildContext context, T largeScreen, T smallScreen) {
    return MediaQuery.of(context).size.width > MEDIUM_DEVICE_WIDTH ? largeScreen : smallScreen;
  }
}
