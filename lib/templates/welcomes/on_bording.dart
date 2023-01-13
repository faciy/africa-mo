// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/templates/security/authentication/login_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBording extends StatefulWidget {
  const OnBording({Key? key}) : super(key: key);

  @override
  State<OnBording> createState() => _OnBordingState();
}

class _OnBordingState extends State<OnBording> {
  final introKey = GlobalKey<IntroductionScreenState>();
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());

  @override
  void initState() {
    super.initState();
  }

  void _onIntroEnd(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.APP_SHOW_HOME, true);
    Get.offAll(() => LoginPage());
  }

  final List<PageViewModel> _pages = [
    PageViewModel(
      titleWidget: AppBigText(
        text: "Bienvenue sur ${AppConstants.APP_NAME}",
        color: AppColors.primary,
        size: AppDimensions.font20,
      ),
      bodyWidget: AppSmallText(
        text:
            "Application développée par ${AppConstants.APP_NAME_DEV}, agence spécialisée dans la location et la vente de biens meublés à Abidjan.",
        size: AppDimensions.font15,
        textAlign: TextAlign.justify,
        maxline: 5,
      ),
      image: Center(
        child: SvgPicture.asset(
          "assets/images/welcome-1.svg",
          height: AppDimensions.width100,
        ),
      ),
    ),
    PageViewModel(
      titleWidget: AppBigText(
        text: "Comment ça marche?",
        color: AppColors.primary,
        size: AppDimensions.font20,
      ),
      bodyWidget: AppSmallText(
        text:
            "L’équipe d’${AppConstants.APP_NAME} met toute son expertise à votre disposition pour satisfaire vos besoins en matière de location de biens meublés.",
        size: AppDimensions.font15,
        textAlign: TextAlign.justify,
        maxline: 5,
      ),
      image: Center(
        child: SvgPicture.asset(
          "assets/images/welcome-2.svg",
          height: AppDimensions.width100,
        ),
      ),
    ),
    PageViewModel(
      titleWidget: AppBigText(
        text: "Comment nous contacter?",
        color: AppColors.primary,
        size: AppDimensions.font20,
      ),
      bodyWidget: AppSmallText(
        text: "Agence de Macory Zone 4,Abidjan, Côte d'Ivoire.",
        size: AppDimensions.font15,
        maxline: 5,
      ),
      image: Center(
        child: SvgPicture.asset(
          "assets/images/contact.svg",
          height: AppDimensions.width100,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityController.connectionType.value != 'none') {
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            margin: EdgeInsets.symmetric(
              horizontal: AppDimensions.width20,
            ),
            child: IntroductionScreen(
              key: introKey,
              pages: _pages,
              onDone: () => _onIntroEnd(context),
              onSkip: () => _onIntroEnd(context),
              showSkipButton: true,
              skip: Text(
                "Passer",
                style: TextStyle(
                  fontSize: AppDimensions.font18,
                ),
              ),
              next: Container(
                width: AppDimensions.width30,
                height: AppDimensions.height30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.height30,
                  ),
                ),
                child: const Icon(
                  Icons.navigate_next,
                  color: AppColors.white,
                ),
              ),
              done: Container(
                height: AppDimensions.height30,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.width5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.height30,
                  ),
                ),
                child: Center(
                  child: AppSmallText(
                    text: "Commencer",
                    color: AppColors.white,
                  ),
                ),
              ),
              dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeColor: AppColors.primary,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
        );
      } else {
        return const NoConnexion();
      }
    });
  }
}
