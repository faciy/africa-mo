// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_text_field.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/security/authentication/reset_password_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/models/security/authentication/reset_password/reset_password_model.dart';
import 'package:innovimmobilier/templates/security/authentication/login_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class ResetPasswordStep3Page extends StatefulWidget {
  ResetPasswordModel resetPasswordModel;
  ResetPasswordStep3Page({Key? key, required this.resetPasswordModel})
      : super(key: key);

  @override
  State<ResetPasswordStep3Page> createState() => _ResetPasswordStep3PageState();
}

class _ResetPasswordStep3PageState extends State<ResetPasswordStep3Page> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  bool _isAccept = false;

  @override
  void initState() {
    super.initState();
  }

  _goToNext(BuildContext context,
      ResetPasswordController resetPasswordController) async {
    String password = _passwordController.text.trim();
    String passwordConfirm = _passwordController.text.trim();

    if (password.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir votre nouveau mot de passe svp!",
        type: 'error',
        context: context,
      );
    } else if (passwordConfirm.isEmpty) {
      showCustomSnackBar(
        "Veuillez confirmer votre nouveau mot de passe svp!",
        type: 'error',
        context: context,
      );
    } else if (passwordConfirm != password) {
      showCustomSnackBar(
        "Confirmation du mot de passe non identique",
        type: 'error',
        context: context,
      );
    } else if (password.length < AppConstants.APP_PASSWORD_MAX_LENGTH ||
        passwordConfirm.length < AppConstants.APP_PASSWORD_MAX_LENGTH) {
      showCustomSnackBar(
        "Votre mot de passe doit comporter au moins ${AppConstants.APP_PASSWORD_MAX_LENGTH} caractères",
        type: 'error',
        context: context,
      );
    } else {
      ResetPasswordModel resetPasswordModel = ResetPasswordModel(
        email: widget.resetPasswordModel.email,
        password: password,
        password_confirmation: passwordConfirm,
      );

      resetPasswordController
          .resetPassword(resetPasswordModel, 3)
          .then((status) {
        if (status.isSuccess) {
          Get.offAll(() => LoginPage(
                isHome: true,
              ));
          showCustomSnackBar(status.message, type: "success", context: context);
        } else {
          showCustomSnackBar(status.message, type: 'error', context: context);
        }
      });
    }
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
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.width20,
                vertical: AppDimensions.height10,
              ),
              child: Column(
                children: [
                  AppBigText(
                    text: "Nouveau mot de passe",
                    size: AppDimensions.font28,
                  ),
                  SizedBox(
                    height: AppDimensions.height20,
                  ),
                  _registerForm(),
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

  Widget _registerForm() {
    return Container(
      margin: EdgeInsets.only(
        top: AppDimensions.height50,
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
                    name: 'password',
                    textEditingController: _passwordController,
                    hintText: 'Nouveau mot de passe *',
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
                    name: 'password_conform',
                    textEditingController: _passwordConfirmController,
                    hintText: 'Confirmer nouveau mot de passe *',
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
                  height: AppDimensions.height30,
                ),
                GetBuilder<ResetPasswordController>(
                    builder: (resetPasswordController) {
                  return resetPasswordController.isLoading
                      ? const CustomLoader()
                      : DelayedAnimation(
                          delay: 500,
                          child: AppButtonWidget(
                            onTap: _isAccept
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      _isAccept
                                          ? _goToNext(
                                              context, resetPasswordController)
                                          : null;
                                    }
                                  }
                                : () {},
                            text: "REINITIALISER",
                            icon: Icons.check,
                            color: _isAccept
                                ? AppColors.white
                                : AppColors.black.withOpacity(0.6),
                            iconColor: _isAccept
                                ? AppColors.white
                                : AppColors.black.withOpacity(0.6),
                            buttonColor: _isAccept
                                ? Theme.of(context).brightness ==
                                        Brightness.light
                                    ? AppColors.primary
                                    : AppColors.primaryDark
                                : AppColors.grey.withOpacity(0.3),
                            buttonBorderColor: _isAccept
                                ? Theme.of(context).brightness ==
                                        Brightness.light
                                    ? AppColors.primary
                                    : AppColors.primaryDark
                                : AppColors.grey.withOpacity(0.3),
                          ),
                        );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
