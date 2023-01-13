import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/category_box.dart';
import 'package:innovimmobilier/commons/widgets/empty_page.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/types/property_type_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/templates/properties/detail_property.dart';
import 'package:innovimmobilier/templates/properties/properties_type_page.dart';
import 'package:innovimmobilier/templates/properties/widgets/property_item.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  UtilsController utilsController = Get.put(UtilsController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      utilsController.refreshDatas();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Get.find<PropertyController>().findAll().then((status) {
      if (status.isSuccess) {
        _refreshController.refreshCompleted();
      } else {
        showCustomSnackBar(
          "Erreur de chargement",
          type: "error",
          context: context,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: AppColors.primary,
      ),
      body: GetBuilder<PropertyController>(builder: (propertyController) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              height: AppDimensions.height150,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.width10),
                  bottomRight: Radius.circular(AppDimensions.width10),
                ),
              ),
              child: GetBuilder<PropertyTypeController>(
                  builder: (categoryController) {
                return categoryController.isLoading
                    ? CustomBtnLoader()
                    : _categoriesList(context);
              }),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: AppDimensions.width20,
                  right: AppDimensions.width20,
                  top: AppDimensions.height16 + 1,
                ),
                child: propertyController.isLoading
                    ? CustomBtnLoader()
                    : propertyController.properties!.isEmpty
                        ? EmptyPage(
                            text: "Infos",
                            content: "Aucun bien disponible pour le moment!",
                            isHome: false,
                          )
                        : SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: false,
                            header: const WaterDropMaterialHeader(),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    propertyController.properties!.length,
                                itemBuilder: (context, int index) {
                                  return propertyController
                                              .properties![index].bien!.image !=
                                          null
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.find<PropertyController>()
                                                .find(propertyController
                                                    .properties![index]
                                                    .bien!
                                                    .id!)
                                                .then((status) {
                                              if (status.isSuccess) {
                                                Get.to(
                                                  () => DetailProperty(
                                                    propertyModel: Get.find<
                                                            PropertyController>()
                                                        .propertySingle!
                                                        .first,
                                                  ),
                                                  fullscreenDialog: true,
                                                );
                                              } else {
                                                showCustomSnackBar(
                                                    status.message,
                                                    type: "error",
                                                    context: context);
                                              }
                                            });
                                          },
                                          child: PropertyItem(
                                            propertyModel: propertyController
                                                .properties![index],
                                          ),
                                        )
                                      : const SizedBox();
                                }),
                          ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _categoriesList(BuildContext context) {
    return GetBuilder<PropertyTypeController>(builder: (categoryController) {
      return ListView.builder(
        itemCount: categoryController.categoryListModel!.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          left: AppDimensions.width20,
          right: AppDimensions.width10,
        ),
        itemBuilder: (_, index) {
          var category = categoryController.categoryListModel![index];
          return Container(
            margin: EdgeInsets.only(right: AppDimensions.width30),
            child: GestureDetector(
              onTap: () async {
                await categoryController
                    .findProperties(category.id!)
                    .then((status) {
                  if (status.isSuccess) {
                    Get.to(
                      () => PropertiesTypePage(
                        title: category.libelle!,
                      ),
                      fullscreenDialog: true,
                    );
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
              child: CategoryBox(
                index: index,
                currentIndex: currentIndex,
                title: category.libelle!,
                imageUrl: "assets/images/studio.png",
              ),
            ),
          );
        },
      );
    });
  }
}
