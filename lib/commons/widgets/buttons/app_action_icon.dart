// ignore_for_file: must_be_immutable

import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';

class AppActionIcon extends StatelessWidget {
  IconData icon;
  double? iconSize;
  Color? iconColor;
  VoidCallback onPress;

  AppActionIcon({
    Key? key,
    required this.icon,
    required this.onPress,
    this.iconSize,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      icon: Icon(
        icon,
        color: iconColor ?? AppColors.primary,
        size: iconSize ?? AppDimensions.iconSize24,
      ),
    );
  }
}
