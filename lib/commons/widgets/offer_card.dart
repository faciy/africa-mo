// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class OfferCard extends StatefulWidget {
  int stars;
  int priceMin;
  int priceMax;
  String name;
  String description;
  bool? isActive;
  OfferCard({
    Key? key,
    required this.stars,
    required this.name,
    required this.priceMin,
    required this.priceMax,
    required this.description,
    this.isActive = false,
  }) : super(key: key);

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  UtilsController utilsController = Get.put(UtilsController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    BorderRadius radius = BorderRadius.circular(AppDimensions.radius10);
    return Container(
      width: width,
      height: AppDimensions.height150,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.cream
            : AppColors.black.withOpacity(0.5),
        border: Border.all(
          color: widget.isActive!
              ? AppColors.success.withOpacity(0.5)
              : Theme.of(context).brightness == Brightness.light
                  ? AppColors.primary.withOpacity(0.5)
                  : AppColors.primaryDark.withOpacity(0.5),
        ),
        borderRadius: radius,
      ),
      child: Stack(children: [
        if (widget.isActive!)
          Positioned(
            top: AppDimensions.height10,
            right: AppDimensions.height10,
            child: Icon(
              Icons.check,
              color: AppColors.success,
              size: AppDimensions.iconSize30,
            ),
          ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: AppDimensions.height10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppDimensions.height50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.stars,
                      itemBuilder: (context, index) {
                        return Icon(
                          Icons.star,
                          size: AppDimensions.font15,
                        );
                      }),
                ),
                SizedBox(
                  width: AppDimensions.width5,
                ),
                AppBigText(
                  text: widget.name,
                  size: AppDimensions.font15,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: AppDimensions.height50,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: AppDimensions.height10),
              child: AppBigText(
                text:
                    "${utilsController.currency(widget.priceMin.toString())} - ${utilsController.currency(widget.priceMax.toString())}",
                size: AppDimensions.font15,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: width,
            decoration: BoxDecoration(
                color: widget.isActive! ? AppColors.success : AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radius10),
                  bottomRight: Radius.circular(AppDimensions.radius10),
                )),
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.radius10),
              child: AppSmallText(
                text: widget.description,
                size: AppDimensions.font15,
                textAlign: TextAlign.center,
                color: AppColors.white,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
