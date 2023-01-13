// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_link_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_text_field.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/security/authentication/login_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/models/security/authentication/login_model.dart';
import 'package:innovimmobilier/templates/initial_home_page.dart';
import 'package:innovimmobilier/templates/security/authentication/reset_pasword/reset_password_step1_page.dart';
import 'package:innovimmobilier/templates/security/registration/register_step1_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class LoginPage extends StatefulWidget {
  bool? isHome;
  LoginPage({Key? key, this.isHome = false}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());

  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isAccept = false;
  bool? isHome;

  @override
  void initState() {
    super.initState();
    isHome = widget.isHome;
  }

  checkLogin(BuildContext context, LoginController loginController) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty) {
      showCustomSnackBar(
        "Entrez votre adresse email svp!",
        type: 'error',
        context: context,
      );
    } else if (password.length < AppConstants.APP_PASSWORD_MAX_LENGTH) {
      showCustomSnackBar(
        "Votre mot de passe doit comporter au moins ${AppConstants.APP_PASSWORD_MAX_LENGTH} caractères",
        type: 'error',
        context: context,
      );
    } else {
      LoginModel? loginModel = LoginModel(email: email, password: password);

      loginController.login(loginModel).then((status) {
        if (status.isSuccess) {
          Get.offAll(() => const InitialHomePage());
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
      if (connectivityController.connectionType.value != 'none') {
        return Scaffold(
          appBar: AppBar(
            leading: HomeActionWidget(
              isHome: isHome,
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
                    text: "Connectez-vous",
                    size: AppDimensions.font28,
                  ),
                  SizedBox(
                    height: AppDimensions.height20,
                  ),
                  _loginForm(),
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

  Widget _loginForm() {
    return Container(
      margin: EdgeInsets.only(
        top: AppDimensions.height50,
        right: AppDimensions.width10,
        left: AppDimensions.width10,
      ),
      child: GetBuilder<LoginController>(builder: (loginController) {
        return Column(
          children: [
            FormBuilder(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      name: 'email',
                      textEditingController: emailController,
                      hintText: 'Adresse email *',
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
                    height: AppDimensions.height40,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: DelayedAnimation(
                      delay: 500,
                      child: AppLinkWidget(
                        onTap: () {
                          Get.to(
                            () => const ResetPasswordStep1Page(),
                            fullscreenDialog: true,
                          );
                        },
                        text: "Mot de passe oublié?",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.height30,
                  ),
                  GetBuilder<LoginController>(builder: (loginController) {
                    return loginController.isLogingLoading
                        ? const CustomLoader()
                        : DelayedAnimation(
                            delay: 600,
                            child: AppButtonWidget(
                              onTap: isAccept
                                  ? () {
                                      if (formKey.currentState!.validate()) {
                                        isAccept
                                            ? checkLogin(
                                                context, loginController)
                                            : null;
                                      }
                                    }
                                  : () {},
                              text: "SE CONNECTER",
                              icon: Icons.person,
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
                          AppSmallText(
                            text: "Pas de compte? Créez par ",
                            size: AppDimensions.font14,
                          ),
                          Transform.translate(
                            offset: const Offset(-5, 0),
                            child: AppLinkWidget(
                              onTap: () {
                                Get.to(
                                  () => const RegisterStep1Page(),
                                  fullscreenDialog: true,
                                );
                              },
                              text: "ici",
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
