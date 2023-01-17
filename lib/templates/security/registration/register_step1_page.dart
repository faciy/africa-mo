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
import 'package:innovimmobilier/templates/security/authentication/login_page.dart';
import 'package:innovimmobilier/templates/security/registration/register_step2_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class RegisterStep1Page extends StatefulWidget {
  const RegisterStep1Page({Key? key}) : super(key: key);

  @override
  State<RegisterStep1Page> createState() => _RegisterStep1PageState();
}

class _RegisterStep1PageState extends State<RegisterStep1Page> {
  ConnectivityController checkInternet = Get.put(ConnectivityController());
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomsController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isAccept = false;

  @override
  void initState() {
    super.initState();
  }

  getCode(BuildContext context, RegisterController registerController) async {
    String nom = nomController.text.trim();
    String prenoms = prenomsController.text.trim();
    String email = emailController.text.trim();
    if (nom.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir votre nom svp!",
        type: 'error',
        context: context,
      );
    } else if (prenoms.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir votre prénom svp!",
        type: 'error',
        context: context,
      );
    } else if (email.isEmpty) {
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
      RegisterModel registerModel = RegisterModel(
        email: email,
        nom: nom,
        prenoms: prenoms,
      );
      registerController.getCodeApi(registerModel).then((status) {
        if (status.isSuccess) {
          Get.to(() => RegisterStep2Page(registerModel: registerModel));
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
                      name: 'nom',
                      textEditingController: nomController,
                      hintText: 'Votre nom *',
                      icon: Icons.person,
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
                    delay: 300,
                    child: AppTextField(
                      name: 'prenom',
                      textEditingController: prenomsController,
                      hintText: 'Votre prénom *',
                      icon: Icons.person,
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
                    delay: 300,
                    child: AppTextField(
                      name: 'email',
                      textEditingController: emailController,
                      hintText: 'Adresse email*',
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
                    height: AppDimensions.height40,
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
                                          ? getCode(context, registerController)
                                          : null;
                                    }
                                  }
                                : () {},
                            text: "CONTINUER",
                            icon: Icons.arrow_forward_ios,
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
                  SizedBox(
                    height: AppDimensions.height40,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: DelayedAnimation(
                      delay: 500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.translate(
                            offset: const Offset(-5, 0),
                            child: AppLinkWidget(
                              onTap: () {
                                Get.offAll(() => LoginPage(
                                      isHome: true,
                                    ));
                              },
                              text: "Déjà un compte? Connectez vous",
                              size: AppDimensions.font14,
                            ),
                          ),
                        ],
                      ),
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
