// ignore_for_file: depend_on_referenced_packages

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/messages/message_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/communes/commune_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/types/property_type_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/taxes/taxe_controller.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/templates/security/authentication/login_page.dart';
import 'package:innovimmobilier/templates/welcomes/on_bording.dart';
import 'package:innovimmobilier/utilities/constants/assets.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  ConnectivityController connectController = Get.put(ConnectivityController());
  late Animation<double> animation;
  late AnimationController controller;
  bool isHowOnBording = false;

  @override
  void initState() {
    super.initState();
    getShowHome();
  }

  getShowHome() async {
    final prefs = await SharedPreferences.getInstance();
    isHowOnBording = prefs.getBool(AppConstants.APP_SHOW_HOME) ?? false;
    if (isHowOnBording) {
      setState(() {
        isHowOnBording = isHowOnBording;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectController.connectionType.value != 'none') {
        return Scaffold(
          appBar: AppBar(),
          body: AnimatedSplashScreen.withScreenFunction(
            splashIconSize: AppDimensions.width200,
            duration: 2000,
            splash: SvgPicture.asset(
              Theme.of(context).brightness == Brightness.light
                  ? AppAssets.LOGO_DARK_SPLASH
                  : AppAssets.LOGO_SPLASH,
            ),
            screenFunction: () async {
              // On charge toutes les données
              if (Get.find<UserController>().userLoggedIn() &&
                  Get.find<UserController>().userModel != null) {
                await Get.find<PropertyController>().findAll();
                await Get.find<PropertyTypeController>().findAll();
                await Get.find<CommuneController>().findAll();
                await Get.find<TaxeController>().findAll();
                await Get.find<MessageController>().findAllHote();
                await Get.find<MessageController>().findAllClient();
              }
              return isHowOnBording ? LoginPage() : const OnBording();
            },
            splashTransition: SplashTransition.scaleTransition,
            pageTransitionType: PageTransitionType.rightToLeft,
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? AppColors.white
                : AppColors.dark,
          ),
        );
      } else {
        return const NoConnexion();
      }
    });
  }
}
