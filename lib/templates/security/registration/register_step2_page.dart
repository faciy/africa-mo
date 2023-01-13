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
import 'package:innovimmobilier/commons/widgets/buttons/app_link_widget.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_text_field.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/security/registration/register_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/models/security/registration/register_model.dart';
import 'package:innovimmobilier/templates/security/registration/register_step3_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class RegisterStep2Page extends StatefulWidget {
  RegisterModel registerModel;
  RegisterStep2Page({Key? key, required this.registerModel}) : super(key: key);

  @override
  State<RegisterStep2Page> createState() => _RegisterStep2PageState();
}

class _RegisterStep2PageState extends State<RegisterStep2Page> {
  ConnectivityController checkInternet = Get.put(ConnectivityController());
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  TextEditingController codeController = TextEditingController();

  bool isAccept = false;

  @override
  void initState() {
    super.initState();
  }

  codeVerify(
    BuildContext context,
    RegisterController registerController,
  ) async {
    String code = codeController.text.trim();
    if (code.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir votre code reçu par mail svp!",
        type: 'error',
        context: context,
      );
    } else {
      widget.registerModel.code = code;
      registerController.codeVerifyApi(widget.registerModel).then((status) {
        if (status.isSuccess) {
          Get.to(() => RegisterStep3Page(registerModel: widget.registerModel));
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

  codeResent(
      BuildContext context, RegisterController registerController) async {
    registerController
        .codeResentApi(widget.registerModel.email!)
        .then((status) {
      if (status.isSuccess) {
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
                    delay: 300,
                    child: AppTextField(
                      name: 'code',
                      type: TextInputType.number,
                      limitNumber: 3,
                      textEditingController: codeController,
                      hintText: 'Code reçu par mail *',
                      icon: Icons.code,
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
                  Align(
                    alignment: Alignment.center,
                    child: DelayedAnimation(
                      delay: 600,
                      child: AppLinkWidget(
                        onTap: () {
                          codeResent(context, registerController);
                        },
                        text: "Renvoyez le code",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  DelayedAnimation(
                    delay: 500,
                    child: registerController.isLoading
                        ? CustomBtnLoader()
                        : AppButtonWidget(
                            onTap: isAccept
                                ? () {
                                    if (formKey.currentState!.validate()) {
                                      isAccept
                                          ? codeVerify(
                                              context, registerController)
                                          : null;
                                    }
                                  }
                                : () {},
                            text: "VERIFIER",
                            icon: Icons.email,
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
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
