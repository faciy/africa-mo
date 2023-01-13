// ignore_for_file: must_be_immutable

import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  String imageUrl;
  String? description;
  String title;
  int? index;
  int? currentIndex;
  CategoryBox(
      {Key? key,
      required this.title,
      required this.imageUrl,
      this.description,
      this.index,
      this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(
              AppDimensions.width15,
            ),
            width: AppDimensions.width70,
            height: AppDimensions.height70,
            decoration: BoxDecoration(
              color:
                  index == currentIndex ? AppColors.white : AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              color:
                  index == currentIndex ? AppColors.primary : AppColors.white,
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          height: AppDimensions.height10,
        ),
        Center(
          child: AppSmallText(
            text: title,
            size: AppDimensions.font16,
            color: AppColors.white,
          ),
        )
      ],
    );
  }
}
