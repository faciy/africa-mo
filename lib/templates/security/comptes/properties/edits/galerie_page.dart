// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/services/models/properties/property_response.dart';
import 'package:innovimmobilier/templates/security/comptes/properties/edits/edit_image_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class GaleriePage extends StatefulWidget {
  List<PropertyResponse>? propertyModel;
  GaleriePage({Key? key, required this.propertyModel}) : super(key: key);

  @override
  State<GaleriePage> createState() => _GaleriePageState();
}

class _GaleriePageState extends State<GaleriePage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  UtilsController utilsController = Get.put(UtilsController());

  _deleteImage(
    BuildContext context,
    PropertyController propertyController,
    int imageId,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: AppBigText(
            text: 'Confirmation',
            size: AppDimensions.font18,
          ),
          content: GetBuilder<PropertyController>(builder: (proController) {
            return proController.isLoading
                ? CustomBtnLoader()
                : AppSmallText(
                    text: 'Voulez-vous sûr de vouloir supprimer cette image?',
                    size: AppDimensions.font13,
                    maxline: 3,
                  );
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: AppBigText(
                text: 'Non',
                size: AppDimensions.font14,
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.primary
                    : AppColors.primaryDark,
              ),
            ),
            TextButton(
              onPressed: () {
                propertyController.deletePicture(imageId).then((status) {
                  if (status.isSuccess) {
                    showCustomSnackBar(
                      status.message,
                      type: 'success',
                      context: context,
                    );
                  } else {
                    showCustomSnackBar(
                      status.message,
                      type: 'error',
                      context: context,
                    );
                  }
                });
              },
              child: AppBigText(
                text: 'Oui, supprimer',
                size: AppDimensions.font14,
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.primary
                    : AppColors.primaryDark,
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityController.connectionType.value != 'none') {
        return GetBuilder<PropertyController>(builder: (propertyController) {
          var images = widget.propertyModel!.first.images!.toList();

          return Scaffold(
            appBar: AppBar(
              leading: HomeActionWidget(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.black.withOpacity(0.6)
                    : AppColors.white,
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).brightness == Brightness.light
                    ? AppColors.white
                    : AppColors.dark,
                statusBarIconBrightness:
                    Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light,
                statusBarBrightness:
                    Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light,
              ),
              centerTitle: true,
              title: AppSmallText(
                text: "Images du bien",
                size: AppDimensions.font18,
              ),
            ),
            body: Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.width20,
                vertical: AppDimensions.height10,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: AppDimensions.height15,
                  ),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, int index) {
                        var image = images[index];
                        return Padding(
                          padding: EdgeInsets.all(AppDimensions.width8),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Image.network(
                                  fit: BoxFit.cover,
                                  ApiUri.APP_UPLOAD + image.src.toString(),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      child: const Icon(
                                        Icons.close,
                                        color: AppColors.danger,
                                      ),
                                      onTap: () {
                                        _deleteImage(context,
                                            propertyController, image.id!);
                                      },
                                    ),
                                    GestureDetector(
                                      child: const Icon(
                                        Icons.edit,
                                        color: AppColors.success,
                                      ),
                                      onTap: () {
                                        Get.to(
                                          () => EditImagePage(
                                            imageModel: image,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      } else {
        return const NoConnexion();
      }
    });
  }
}
