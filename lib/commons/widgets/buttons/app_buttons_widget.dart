// ignore_for_file: must_be_immutable

import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';

class AppButtonWidget extends StatelessWidget {
  bool? isResponsive;
  double? width;
  String? text;
  double? size;
  Color? color;
  IconData? icon;
  Color? iconColor;
  Color? buttonColor;
  Color? buttonBorderColor;
  VoidCallback? onTap;

  AppButtonWidget({
    Key? key,
    this.width,
    this.text,
    this.icon,
    this.size,
    this.color = AppColors.primary,
    this.iconColor = AppColors.primary,
    this.buttonColor = AppColors.white,
    this.buttonBorderColor = AppColors.primary,
    this.isResponsive = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.height10),
        width: isResponsive == true ? width : double.maxFinite,
        height: AppDimensions.height40 + 5,
        decoration: BoxDecoration(
            border: Border.all(color: buttonBorderColor!),
            color: buttonColor,
            borderRadius: BorderRadius.circular(AppDimensions.radius5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: size ?? AppDimensions.font16,
              color: iconColor,
            ),
            SizedBox(
              width: AppDimensions.width10,
            ),
            text != null
                ? Text(
                    text!,
                    style: TextStyle(
                      color: color,
                      fontSize: size ?? AppDimensions.font16,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
