import 'package:flutter/widgets.dart';

class AppDimensions {
  static const double smallPadding = 3.0;
  static const double itemPadding = 10.0;
  static const double bigItemPadding = 20.0;
  static const padding = const EdgeInsets.all(itemPadding);

  static final shape =
      BeveledRectangleBorder(borderRadius: BorderRadius.circular(itemPadding));
}
