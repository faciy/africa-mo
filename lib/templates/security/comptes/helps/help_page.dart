import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/empty_page.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityController.connectionType.value != 'none') {
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
              text: "Aide",
              size: AppDimensions.font18,
            ),
          ),
          body: EmptyPage(
            text: 'Information',
            content: 'Contenu non disponible pour le moment',
          ),
        );
      } else {
        return const NoConnexion();
      }
    });
  }
}
