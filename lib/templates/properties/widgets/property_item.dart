// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/services/models/properties/data_property_model.dart';
import 'package:innovimmobilier/utilities/constants/assets.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PropertyItem extends StatefulWidget {
  DataPropertyModel propertyModel;
  PropertyItem({Key? key, required this.propertyModel}) : super(key: key);

  @override
  State<PropertyItem> createState() => _PropertyItemState();
}

class _PropertyItemState extends State<PropertyItem> {
  UtilsController utilsController = Get.put(UtilsController());
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    var images = widget.propertyModel.images!;

    return Column(
      children: [
        images.isNotEmpty
            ? Container(
                height: AppDimensions.height200 - 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.white
                      : AppColors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radius10,
                  ),
                ),
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(
                        images.length,
                        (int index) {
                          var img = images[index].src;
                          return img != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? AppColors.white
                                        : AppColors.dark.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radius10,
                                    ),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          ApiUri.APP_UPLOAD + img),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? AppColors.white
                                        : AppColors.dark.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radius10,
                                    ),
                                  ),
                                  child: Image.asset(AppAssets.IMG_EMPTY),
                                );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: AppDimensions.height20,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: images.length,
                          effect: ExpandingDotsEffect(
                            activeDotColor: AppColors.primary,
                            dotColor: AppColors.white,
                            dotHeight: AppDimensions.height5,
                            dotWidth: AppDimensions.height5 + 1,
                            spacing: AppDimensions.width5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : widget.propertyModel.bien!.image != null
                ? Container(
                    height: AppDimensions.height200 - 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius10,
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          ApiUri.APP_UPLOAD + widget.propertyModel.bien!.image!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    height: AppDimensions.height200 - 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius10,
                      ),
                    ),
                    child: Image.asset(AppAssets.IMG_EMPTY),
                  ),
        SizedBox(
          height: AppDimensions.height10,
        ),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSmallText(
                      text: widget.propertyModel.bien!.libelle!,
                      size: AppDimensions.font13,
                    ),
                    SizedBox(
                      height: AppDimensions.height2,
                    ),
                    AppBigText(
                      text: utilsController.currency(
                        widget.propertyModel.bien!.prix.toString(),
                      ),
                      size: AppDimensions.font12,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: AppDimensions.font12,
                      color: AppColors.grey.withOpacity(0.8),
                    ),
                    AppSmallText(
                      text: widget.propertyModel.bien!.localisation!,
                      size: AppDimensions.font12,
                      color: AppColors.grey.withOpacity(0.8),
                      maxline: 2,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: AppDimensions.height20,
        ),
      ],
    );
  }
}
