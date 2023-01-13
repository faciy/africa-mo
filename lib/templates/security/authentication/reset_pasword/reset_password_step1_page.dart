// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_text_field.dart';
import 'package:innovimmobilier/services/controllers/security/authentication/reset_password_controller.dart';
import 'package:innovimmobilier/services/models/security/authentication/reset_password/reset_password_model.dart';
import 'package:innovimmobilier/templates/security/authentication/reset_pasword/reset_password_step2_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class ResetPasswordStep1Page extends StatefulWidget {
  const ResetPasswordStep1Page({Key? key}) : super(key: key);

  @override
  State<ResetPasswordStep1Page> createState() => _ResetPasswordStep1PageState();
}

class _ResetPasswordStep1PageState extends State<ResetPasswordStep1Page> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isAccept = false;

  @override
  void initState() {
    super.initState();
  }

  _goToStep2(BuildContext context,
      ResetPasswordController resetPasswordController) async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir votre email svp!",
        type: 'error',
        context: context,
      );
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar(
        "Veuillez saisir un email valide svp!",
        type: 'error',
        context: context,
      );
    } else {
      ResetPasswordModel resetPasswordModel = ResetPasswordModel(
        email: email,
      );
      setState(() {
        resetPasswordModel.email = email;
      });

      resetPasswordController
          .resetPassword(resetPasswordModel, 1)
          .then((status) {
        if (status.isSuccess) {
          Get.to(
            () => ResetPasswordStep2Page(
              resetPasswordModel: resetPasswordModel,
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
    }
  }

  @override
  Widget build(BuildContext context) {
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
            vertical: AppDimensions.height30,
          ),
          child: Column(
            children: [
              AppBigText(
                text: "Reinitialisation de mot de passe",
                size: AppDimensions.font22,
                maxlines: 2,
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
                  delay: 300,
                  child: AppTextField(
                    name: 'email',
                    textEditingController: _emailController,
                    hintText: 'Saisissez votre adresse email *',
                    icon: Icons.email,
                    validators: [
                      FormBuilderValidators.email(
                        errorText: "",
                      ),
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
                      ? CustomBtnLoader()
                      : DelayedAnimation(
                          delay: 500,
                          child: AppButtonWidget(
                            onTap: _isAccept
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      _isAccept
                                          ? _goToStep2(
                                              context, resetPasswordController)
                                          : null;
                                    }
                                  }
                                : () {},
                            text: "ENVOYER",
                            icon: Icons.send,
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
