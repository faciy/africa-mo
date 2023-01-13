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
import 'package:innovimmobilier/commons/widgets/inputs/app_text_field.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/security/registration/register_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/models/security/registration/register_model.dart';
import 'package:innovimmobilier/templates/security/authentication/login_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:innovimmobilier/utilities/services/modal_loading.dart';

class RegisterStep3Page extends StatefulWidget {
  RegisterModel registerModel;
  RegisterStep3Page({Key? key, required this.registerModel}) : super(key: key);

  @override
  State<RegisterStep3Page> createState() => _RegisterStep3PageState();
}

class _RegisterStep3PageState extends State<RegisterStep3Page> {
  ConnectivityController checkInternet = Get.put(ConnectivityController());
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  bool isAccept = false;

  @override
  void initState() {
    super.initState();
  }

  register(BuildContext context, RegisterController registerController) async {
    String password = passwordController.text.trim();
    String passwordConfirm = passwordConfirmController.text.trim();
    if (password.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir votre mot de passe svp!",
        type: 'error',
        context: context,
      );
    } else if (passwordConfirm.isEmpty) {
      showCustomSnackBar(
        "Veuillez confirmer votre mot de passe svp!",
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
      widget.registerModel.password = password;
      widget.registerModel.password_confirmation = passwordConfirm;

      registerController.registerApi(widget.registerModel).then((status) {
        if (status.isSuccess) {
          ModalLoading.showAlertDialog(
            context,
            status.message,
            "success",
            bntLabel: "Se connecter",
            onRedirect: () {
              Get.offAll(() => LoginPage(
                    isHome: true,
                  ));
            },
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
    return Obx(() {
      if (checkInternet.connectionType.value != 'none') {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.width20,
                vertical: AppDimensions.height10,
              ),
              child: Column(
                children: [
                  AppBigText(
                    text: "Inscrivez-vous",
                    size: AppDimensions.font36,
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
      child: GetBuilder<RegisterController>(builder: (registerController) {
        return Column(
          children: [
            FormBuilder(
              key: formKey,
              onChanged: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    isAccept = true;
                  });
                } else {
                  setState(() {
                    isAccept = false;
                  });
                }
              },
              child: Column(
                children: [
                  DelayedAnimation(
                    delay: 400,
                    child: AppTextField(
                      name: 'password',
                      textEditingController: passwordController,
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
                    height: AppDimensions.height30,
                  ),
                  DelayedAnimation(
                    delay: 400,
                    child: AppTextField(
                      name: 'password_conform',
                      textEditingController: passwordConfirmController,
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
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  GetBuilder<RegisterController>(builder: (registerController) {
                    return registerController.isLoading
                        ? const CustomLoader()
                        : DelayedAnimation(
                            delay: 500,
                            child: AppButtonWidget(
                              onTap: isAccept
                                  ? () {
                                      if (formKey.currentState!.validate()) {
                                        isAccept
                                            ? register(
                                                context, registerController)
                                            : null;
                                      }
                                    }
                                  : () {},
                              text: "TERMINER",
                              icon: Icons.check,
                              color: isAccept
                                  ? AppColors.white
                                  : AppColors.black.withOpacity(0.6),
                              iconColor: isAccept
                                  ? AppColors.white
                                  : AppColors.black.withOpacity(0.6),
                              buttonColor: isAccept
                                  ? Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppColors.primary
                                      : AppColors.primaryDark
                                  : AppColors.grey.withOpacity(0.3),
                              buttonBorderColor: isAccept
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
        );
      }),
    );
  }
}
