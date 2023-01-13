import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/custom_loader.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/empty_page.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/controllers/properties/favories/favoris_controller.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  FavorisController favorisController = Get.find<FavorisController>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadFavoris();
    });
  }

  Future<void> loadFavoris() async {
    var user = Get.find<UserController>().userModel;
    if (favorisController.favorisList!.isEmpty) {
      await favorisController.findAll(user!.email!, user.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityController.connectionType.value != 'none') {
        return GetBuilder<FavorisController>(builder: (favorisController) {
          var listProperties = favorisController.favorisList!.toList();
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
            ),
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: AppDimensions.height20,
                    right: AppDimensions.height20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppBigText(
                        text: "Favoris",
                        size: AppDimensions.font22,
                      ),
                      AppSmallText(text: "${listProperties.length} élément(s)"),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? const CustomLoader()
                      : listProperties.isNotEmpty
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(8),
                              itemCount: listProperties.length,
                              itemBuilder: (BuildContext context, int index) {
                                var property = listProperties[index];
                                return Card(
                                  child: ListTile(
                                      onTap: () {},
                                      title: Text(property.bien![0].libelle!),
                                      subtitle:
                                          Text(property.bien![0].localisation!),
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            ApiUri.APP_UPLOAD +
                                                property.bien![0].image!),
                                      ),
                                      trailing: const Icon(Icons.edit_note)),
                                );
                              },
                            )
                          : EmptyPage(
                              text: "Infos",
                              content:
                                  "La fonctionnalité des favoris sera disponible dès la prochaine MAJ.",
                              isHome: false,
                            ),
                )
              ],
            ),
          );
        });
      } else {
        return const NoConnexion();
      }
    });
  }
}
