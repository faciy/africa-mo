// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class CategoryItem extends StatefulWidget {
  String title;
  IconData icon;
  Color? color;
  VoidCallback? onTap;
  CategoryItem({
    Key? key,
    required this.title,
    required this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.width5),
        decoration: BoxDecoration(
          color: widget.color != null
              ? widget.color!.withOpacity(0.15)
              : AppColors.danger.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppDimensions.radius10),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: AppDimensions.font12,
              color: widget.color ?? AppColors.secondary,
            ),
            SizedBox(
              width: AppDimensions.width5,
            ),
            AppSmallText(
              text: widget.title,
              size: AppDimensions.font12,
              color: widget.color ?? AppColors.secondary,
            )
          ],
        ),
      ),
    );
  }
}
