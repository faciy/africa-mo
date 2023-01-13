// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_text_field.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/templates/initial_home_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:innovimmobilier/utilities/services/modal_loading.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _currentPpasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isAccept = false;
  bool isLoading = false;
  String countPhoneCaracter = "";

  _goToNext(BuildContext context, UserController userController) async {
    String currentPassword = _currentPpasswordController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      showCustomSnackBar(
        "Saisissez votre mot de passe actuel",
        type: 'error',
        context: context,
      );
    }
    if (password.isEmpty) {
      showCustomSnackBar(
        "Saisissez votre nouveau mot de passe",
        type: 'error',
        context: context,
      );
    }
    if (confirmPassword.isEmpty) {
      showCustomSnackBar(
        "Confirmer votre mot nouveau de passe",
        type: 'error',
        context: context,
      );
    } else if (currentPassword.length < AppConstants.APP_PASSWORD_MAX_LENGTH) {
      showCustomSnackBar(
        "Votre mot de passe doit comporter au moins ${AppConstants.APP_PASSWORD_MAX_LENGTH} caractères",
        type: 'error',
        context: context,
      );
    } else if (password.length < AppConstants.APP_PASSWORD_MAX_LENGTH) {
      showCustomSnackBar(
        "Votre mot de passe doit comporter au moins ${AppConstants.APP_PASSWORD_MAX_LENGTH} caractères",
        type: 'error',
        context: context,
      );
    } else if (confirmPassword.length < AppConstants.APP_PASSWORD_MAX_LENGTH) {
      showCustomSnackBar(
        "Votre mot de passe doit comporter au moins ${AppConstants.APP_PASSWORD_MAX_LENGTH} caractères",
        type: 'error',
        context: context,
      );
    } else if (password != confirmPassword) {
      showCustomSnackBar(
        "Mot de passe non identique!",
        type: 'error',
        context: context,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: AppBigText(
              text: 'Confirmation',
              size: AppDimensions.font18,
            ),
            content: GetBuilder<UserController>(builder: (usrController) {
              return usrController.isLoading
                  ? CustomBtnLoader()
                  : AppSmallText(
                      text:
                          'Voulez-vous confirmer la modification du mot de passe?',
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
                onPressed: () async {
                  userController
                      .editPassword(
                    confirmPassword,
                    userController.userModel!.id!,
                  )
                      .then((status) {
                    if (status.isSuccess) {
                      ModalLoading.showAlertDialog(
                        context,
                        status.message,
                        "success",
                        bntLabel: "Fermer",
                        onRedirect: () {
                          Get.off(() => const InitialHomePage());
                        },
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
                  text: 'Oui, continuer',
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
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityController.connectionType.value != 'none') {
        return GetBuilder<UserController>(builder: (userController) {
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
                text: "Connexion et Sécurité",
                size: AppDimensions.font18,
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(AppDimensions.width20),
              child: DelayedAnimation(
                delay: 900,
                child: AppButtonWidget(
                  onTap: _isAccept
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            _isAccept
                                ? _goToNext(context, userController)
                                : null;
                          }
                        }
                      : () {},
                  size: AppDimensions.font16,
                  text: "Modifier le mot de passe",
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
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppDimensions.width20,
                  vertical: AppDimensions.height30,
                ),
                child: Column(
                  children: [
                    _getForm(),
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

  Widget _getForm() {
    return Container(
      margin: EdgeInsets.only(
        right: AppDimensions.width10,
        left: AppDimensions.width10,
      ),
      child: Column(
        children: [
          FormBuilder(
            key: _formKey,
            onChanged: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isAccept = true;
                });
              } else {
                setState(() {
                  _isAccept = false;
                });
              }
            },
            child: Column(
              children: [
                DelayedAnimation(
                  delay: 400,
                  child: AppTextField(
                    label: "Mot de passe actuel",
                    name: 'current_password',
                    textEditingController: _currentPpasswordController,
                    hintText: 'Mot de passe actuel *',
                    icon: Icons.remove_red_eye_outlined,
                    is0bscureText: true,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: "",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppDimensions.height20,
                ),
                DelayedAnimation(
                  delay: 400,
                  child: AppTextField(
                    label: "Nouveau mot de passe",
                    name: 'password',
                    textEditingController: _passwordController,
                    hintText: 'Mot de passe *',
                    icon: Icons.remove_red_eye_outlined,
                    is0bscureText: true,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: "",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppDimensions.height20,
                ),
                DelayedAnimation(
                  delay: 400,
                  child: AppTextField(
                    label: "Confirmer le mot de passe",
                    name: 'confirm_password',
                    textEditingController: _confirmPasswordController,
                    hintText: 'Confirmer mot de passe *',
                    icon: Icons.remove_red_eye_outlined,
                    is0bscureText: true,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: "",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppDimensions.height40,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
