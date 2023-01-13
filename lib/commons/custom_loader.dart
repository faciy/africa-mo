import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.height100 / 2),
        ),
        alignment: Alignment.center,
        child: Lottie.asset(
          'assets/images/loader.json',
          width: AppDimensions.width100,
          height: AppDimensions.height100,
        ),
      ),
    );
  }
}
