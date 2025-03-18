import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobileV;
  final Widget mobileH;
  final Widget tabletV;
  final Widget tabletH;

  const Responsive({
    Key? key,
    required this.mobileV,
    required this.mobileH,
    required this.tabletV,
    required this.tabletH,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 515 ||
      MediaQuery.of(context).size.height < 515;

  static bool isTablet(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;

    if (isKeyboardVisible) {
      return (MediaQuery.of(context).size.width >= 300 &&
          MediaQuery.of(context).size.height >= 300);
    }

    return (MediaQuery.of(context).size.width >= 515 &&
        MediaQuery.of(context).size.height >= 515);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!isTablet(context)) {
          if (constraints.maxWidth > constraints.maxHeight) {
            return mobileH;
          } else {
            return mobileV;
          }
        } else if (constraints.maxWidth > constraints.maxHeight) {
          if (!isKeyboardVisible) {
            return tabletH;
          } else {
            return tabletV;
          }
        } else {
          if (isKeyboardVisible) {
            return tabletV;
          } else {
            return tabletH;
          }
        }
      },
    );
  }
}
