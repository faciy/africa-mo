// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class ItemList extends StatelessWidget {
  String title;
  IconData? icon;
  VoidCallback? onTap;
  double? size;
  Color? color;
  bool? isTraining = true;
  ItemList({
    Key? key,
    required this.title,
    this.icon,
    this.onTap,
    this.size,
    this.color,
    this.isTraining,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: AppDimensions.height5,
          bottom: AppDimensions.height15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    size: size ?? AppDimensions.font18,
                    color: color,
                  ),
                if (icon != null)
                  SizedBox(
                    width: AppDimensions.width10,
                  ),
                AppSmallText(
                  text: title,
                  size: size ?? AppDimensions.font16,
                  color: color,
                ),
              ],
            ),
            if (isTraining != false)
              Icon(
                Icons.arrow_forward_ios,
                size: size ?? AppDimensions.font16,
                color: color,
              ),
          ],
        ),
      ),
    );
  }
}
