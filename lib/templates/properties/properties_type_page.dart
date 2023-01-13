// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/empty_page.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/types/property_type_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/templates/properties/detail_property.dart';
import 'package:innovimmobilier/templates/properties/widgets/property_item.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class PropertiesTypePage extends StatefulWidget {
  String title;
  PropertiesTypePage({Key? key, required this.title}) : super(key: key);

  @override
  State<PropertiesTypePage> createState() => _PropertiesTypePageState();
}

class _PropertiesTypePageState extends State<PropertiesTypePage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityController.connectionType.value != 'none') {
        return GetBuilder<PropertyTypeController>(
            builder: (propertyTypeController) {
          var properties = propertyTypeController.propertiesListModel;
          var propertiesReversed = properties!.reversed.toList();
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
                text: widget.title,
                size: AppDimensions.font18,
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.only(
                  left: AppDimensions.height20,
                  right: AppDimensions.height20,
                ),
                child: propertiesReversed.isEmpty
                    ? EmptyPage(
                        text: "Infos",
                        content: "Aucun bien disponible pour le moment!",
                        isHome: false,
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: propertiesReversed.length,
                        itemBuilder: (context, int index) {
                          return propertiesReversed[index].bien!.image != null
                              ? GestureDetector(
                                  onTap: () {
                                    Get.find<PropertyController>()
                                        .find(
                                            propertiesReversed[index].bien!.id!)
                                        .then((status) {
                                      if (status.isSuccess) {
                                        Get.to(
                                          () => DetailProperty(
                                            propertyModel:
                                                Get.find<PropertyController>()
                                                    .propertySingle!
                                                    .first,
                                          ),
                                          fullscreenDialog: true,
                                        );
                                      } else {
                                        showCustomSnackBar(status.message,
                                            type: "error", context: context);
                                      }
                                    });
                                  },
                                  child: PropertyItem(
                                    propertyModel: propertiesReversed[index],
                                  ),
                                )
                              : const SizedBox();
                        }),
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
