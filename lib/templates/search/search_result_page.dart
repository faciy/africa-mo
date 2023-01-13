// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/services/controllers/properties/communes/searchs/search_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/templates/properties/detail_property.dart';
import 'package:innovimmobilier/templates/properties/widgets/property_item.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: AppDimensions.height20,
        left: AppDimensions.height20,
        right: AppDimensions.height20,
      ),
      child: GetBuilder<SearchController>(builder: (searchController) {
        var listProperties = searchController.searchPropertyListModel;
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: listProperties!.length,
          itemBuilder: (context, int index) {
            return listProperties[index].bien!.image != null
                ? GestureDetector(
                    onTap: () {
                      Get.find<PropertyController>()
                          .find(listProperties[index].bien!.id!)
                          .then((status) {
                        if (status.isSuccess) {
                          Get.to(
                            () => DetailProperty(
                              propertyModel: Get.find<PropertyController>()
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
                      propertyModel: listProperties[index],
                    ),
                  )
                : const SizedBox();
          },
        );
      }),
    );
  }
}
