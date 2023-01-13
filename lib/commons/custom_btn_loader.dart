// ignore_for_file: must_be_immutable

import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomBtnLoader extends StatelessWidget {
  Color? color;
  double? width;
  double? height;
  CustomBtnLoader({
    Key? key,
    this.color,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? AppDimensions.width150,
      height: height ?? AppDimensions.height50,
      alignment: Alignment.center,
      child: Lottie.asset(
        'assets/images/loader.json',
        width: AppDimensions.width100,
        height: AppDimensions.height100,
      ),
    );
  }
}
