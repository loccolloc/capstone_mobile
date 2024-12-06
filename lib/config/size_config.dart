import 'package:flutter/cupertino.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}

double getProportionateScreenHeight(double inputHeight) {
  if (SizeConfig.screenHeight == null) {
    return 100.0;
  }
  return (inputHeight / 585) * SizeConfig.screenHeight!;
}

double getProportionateScreenWidth(double inputWidth) {
  if (SizeConfig.screenWidth == null) {
    return 100.0;
  }
  return (inputWidth / 270) * SizeConfig.screenWidth!;
}
