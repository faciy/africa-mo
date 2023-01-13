// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/templates/security/authentication/login_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());

  _deleteAccount(BuildContext context, UserController userController) async {
    var userId = userController.userModel!.id;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: AppBigText(
            text: 'Confirmation',
            size: AppDimensions.font18,
          ),
          content: GetBuilder<UserController>(builder: (usController) {
            return usController.isLoading
                ? CustomBtnLoader()
                : AppSmallText(
                    text: 'Voulez-vous confirmer la suppression?',
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
                userController.delete(userId!).then((status) {
                  if (status.isSuccess) {
                    Get.offAll(
                      () => LoginPage(
                        isHome: true,
                      ),
                    );
                    showCustomSnackBar(
                      status.message,
                      type: 'success',
                      context: context,
                    );
                  } else {
                    Get.back();
                    showCustomSnackBar(
                      status.message,
                      type: 'error',
                      context: context,
                    );
                  }
                });
              },
              child: AppBigText(
                text: 'Oui, Supprimer',
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
        return GetBuilder<UserController>(builder: (userController) {
          return Scaffold(
            appBar: AppBar(
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
                text: "Suppression de compte",
                size: AppDimensions.font18,
              ),
              leading: HomeActionWidget(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.black.withOpacity(0.6)
                    : AppColors.white,
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(AppDimensions.width20),
              child: DelayedAnimation(
                delay: 300,
                child: AppButtonWidget(
                  onTap: () {
                    _deleteAccount(context, userController);
                  },
                  size: AppDimensions.font16,
                  text: "Supprimer le compte",
                  icon: Icons.arrow_forward_ios,
                  color: AppColors.white,
                  iconColor: AppColors.white,
                  buttonColor: AppColors.danger,
                  buttonBorderColor: AppColors.danger,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppDimensions.width20,
                  vertical: AppDimensions.height30,
                ),
                child: Column(
                  children: [
                    AppSmallText(
                      text:
                          "Votre compte sera supprimé 14 jours après votre demande",
                      maxline: 250,
                      size: AppDimensions.font15,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
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
