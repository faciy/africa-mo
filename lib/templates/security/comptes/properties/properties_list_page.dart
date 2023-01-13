// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/empty_page.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/models/properties/data_property_model.dart';
import 'package:innovimmobilier/templates/security/comptes/properties/edits/edit_property_page.dart';
import 'package:innovimmobilier/utilities/constants/assets.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class PropertiesListPage extends StatefulWidget {
  String title;
  PropertiesListPage({Key? key, required this.title}) : super(key: key);

  @override
  State<PropertiesListPage> createState() => _PropertiesListPageState();
}

class _PropertiesListPageState extends State<PropertiesListPage> {
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
        return GetBuilder<PropertyController>(builder: (propertyController) {
          List<DataPropertyModel> properties =
              propertyController.userProperties!;
          var propertiesReversed = properties.reversed.toList();
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
            body: propertyController.isLoading
                ? Center(child: CustomBtnLoader())
                : propertiesReversed.isEmpty
                    ? EmptyPage(
                        text: 'Information',
                        content: 'Aucune donnée trouvée, veuillez réessayer!',
                      )
                    : Container(
                        margin: EdgeInsets.only(
                          top: AppDimensions.height20,
                          left: AppDimensions.width5,
                          right: AppDimensions.width5,
                        ),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(8),
                          itemCount: propertiesReversed.length,
                          itemBuilder: (BuildContext context, int index) {
                            var property = propertiesReversed[index];
                            return Card(
                              child: ListTile(
                                  onTap: () async {
                                    await propertyController
                                        .find(property.bien!.id!)
                                        .then((status) {
                                      if (status.isSuccess) {
                                        Get.to(
                                          () => EditPropertyPage(
                                            title: property.bien!.libelle!,
                                            propertyModel: propertyController
                                                .propertySingle!.first.bien!,
                                          ),
                                        );
                                      }
                                    });
                                  },
                                  title: Text(property.bien!.libelle!),
                                  subtitle: Text(property.bien!.localisation!),
                                  leading: property.bien!.image == null
                                      ? const CircleAvatar(
                                          backgroundImage: AssetImage(
                                            AppAssets.IMG_EMPTY,
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              ApiUri.APP_UPLOAD +
                                                  property.bien!.image!),
                                        ),
                                  trailing: const Icon(Icons.edit_note)),
                            );
                          },
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
