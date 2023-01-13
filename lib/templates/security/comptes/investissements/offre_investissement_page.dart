import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_loader.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/commons/widgets/offer_card.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/templates/security/comptes/investissements/save_investissement_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class OffreInvestissementPage extends StatefulWidget {
  const OffreInvestissementPage({Key? key}) : super(key: key);

  @override
  State<OffreInvestissementPage> createState() =>
      _OffreInvestissementPageState();
}

class _OffreInvestissementPageState extends State<OffreInvestissementPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  UtilsController utilsController = Get.put(UtilsController());
  bool _isAccept = false;
  int? isSelectedIndex;
  String? selectValue;
  bool isLoading = false;

  _goToNext(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
    Get.to(() => const SaveInvestissementPage());
  }

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
              text: "Projet d'investissement",
              size: AppDimensions.font18,
            ),
            actions: const [HomeActionWidget()],
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(AppDimensions.width20),
            child: DelayedAnimation(
              delay: 900,
              child: AppButtonWidget(
                onTap: _isAccept
                    ? () {
                        _goToNext(context);
                      }
                    : () {},
                size: AppDimensions.font16,
                text: "Suivant",
                icon: Icons.arrow_forward_ios,
                color: _isAccept
                    ? AppColors.white
                    : AppColors.black.withOpacity(0.6),
                iconColor: _isAccept
                    ? AppColors.white
                    : AppColors.black.withOpacity(0.6),
                buttonColor: _isAccept
                    ? Theme.of(context).brightness == Brightness.light
                        ? AppColors.primary
                        : AppColors.primaryDark
                    : AppColors.grey.withOpacity(0.3),
                buttonBorderColor: _isAccept
                    ? Theme.of(context).brightness == Brightness.light
                        ? AppColors.primary
                        : AppColors.primaryDark
                    : AppColors.grey.withOpacity(0.3),
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          body: isLoading
              ? const CustomLoader()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: AppDimensions.width20,
                      vertical: AppDimensions.height10,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: AppBigText(
                            text: "Choix de l'offre",
                            size: AppDimensions.font15,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(
                          height: AppDimensions.height35,
                        ),
                        _getContent(),
                      ],
                    ),
                  ),
                ),
        );
      } else {
        return const NoConnexion();
      }
    });
  }

  Widget _getContent() {
    return Container(
      margin: EdgeInsets.only(
        right: AppDimensions.width10,
        left: AppDimensions.width10,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isSelectedIndex = 1;
                _isAccept = true;
                selectValue = "Junior";
              });
            },
            child: OfferCard(
              stars: 1,
              name: 'Junior',
              priceMin: 1000000,
              priceMax: 2000000,
              description: "Découvrir le plan d'investissement junior",
              isActive: 1 == isSelectedIndex ? true : false,
            ),
          ),
          SizedBox(
            height: AppDimensions.height20,
          ),
          InkWell(
            onTap: () {
              setState(() {
                isSelectedIndex = 2;
                _isAccept = true;
                selectValue = "Senior";
              });
            },
            child: OfferCard(
              stars: 2,
              name: 'Senior',
              priceMin: 4000000,
              priceMax: 7000000,
              description: "Découvrir le plan d'investissement senior",
              isActive: 2 == isSelectedIndex ? true : false,
            ),
          ),
          SizedBox(
            height: AppDimensions.height20,
          ),
          InkWell(
            onTap: () {
              setState(() {
                isSelectedIndex = 3;
                _isAccept = true;
                selectValue = "Premium";
              });
            },
            child: OfferCard(
              stars: 3,
              name: 'Premium',
              priceMin: 10000000,
              priceMax: 20000000,
              description: "Découvrir le plan d'investissement premium",
              isActive: 3 == isSelectedIndex ? true : false,
            ),
          ),
          SizedBox(
            height: AppDimensions.height40,
          ),
        ],
      ),
    );
  }
}
