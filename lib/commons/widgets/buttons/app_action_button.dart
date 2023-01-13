// ignore_for_file: must_be_immutable

import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';

class AppActionButton extends StatelessWidget {
  TextEditingController? controller;
  double? width;
  double? height;
  String text;
  double size;
  Color? color;
  IconData? icon;
  Color? iconColor;
  Color? buttonColor;
  bool? active;
  bool? disabled;
  bool? isImage;
  String? imageUrl;
  VoidCallback? onTap;

  AppActionButton({
    Key? key,
    required this.text,
    required this.size,
    this.controller,
    this.width = 0,
    this.height = 0,
    this.icon,
    this.color = AppColors.black,
    this.iconColor = AppColors.black,
    this.buttonColor = AppColors.white,
    this.active = false,
    this.disabled = false,
    this.isImage = false,
    this.imageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled == true ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.height10),
        width: width ?? AppDimensions.width80,
        height: height ?? AppDimensions.height80,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: disabled == true ? Colors.transparent : AppColors.grey,
                blurRadius: 1,
                offset:
                    disabled == true ? const Offset(0, 1) : const Offset(0, 1),
              )
            ],
            border: Border.all(color: AppColors.grey.withOpacity(0.5)),
            color: disabled == true
                ? AppColors.grey.withOpacity(0.3)
                : (active == false ? buttonColor : AppColors.primary),
            borderRadius: BorderRadius.circular(AppDimensions.radius10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: false,
              child: TextField(
                controller: controller,
              ),
            ),
            isImage == true
                ? Image.network(
                    imageUrl!,
                    width: AppDimensions.width20 + 5,
                    height: AppDimensions.height25,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    icon,
                    color: active == false ? iconColor : AppColors.white,
                  ),
            SizedBox(
              height: AppDimensions.width5,
            ),
            Text(
              text,
              style: TextStyle(
                color: active == false ? color : AppColors.white,
                fontSize: size,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
