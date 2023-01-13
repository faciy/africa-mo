// ignore_for_file: must_be_immutable

import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';

class AppLinkWidget extends StatelessWidget {
  String? text;
  Color? color;
  double? size;
  bool? bold;
  VoidCallback? onTap;

  AppLinkWidget({
    Key? key,
    this.text,
    this.color = AppColors.primary,
    this.size = 0,
    this.bold = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.height10),
        child: Text(
          text ?? '',
          style: TextStyle(
            color: color,
            fontSize: size == 0 ? AppDimensions.font15 : size,
            fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
