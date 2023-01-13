// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_text_field.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/templates/initial_home_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:innovimmobilier/utilities/services/modal_loading.dart';

class SaveInvestissementPage extends StatefulWidget {
  const SaveInvestissementPage({Key? key}) : super(key: key);

  @override
  State<SaveInvestissementPage> createState() => _SaveInvestissementPageState();
}

class _SaveInvestissementPageState extends State<SaveInvestissementPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  UtilsController utilsController = Get.put(UtilsController());
  bool _isAccept = false;
  bool isLoading = false;
  String countPhoneCaracter = "";

  _goToNext(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    String email = _contactEmailController.text.trim();
    String phone = _contactPhoneController.text.trim();

    if (email.isEmpty) {
      setState(() {
        isLoading = false;
      });
      showCustomSnackBar(
        "Entrez votre adresse email svp!",
        type: 'error',
        context: context,
      );
    } else if (phone.isEmpty) {
      setState(() {
        isLoading = false;
      });
      showCustomSnackBar(
        "Entrez votre numéro de téléphone svp!",
        type: 'error',
        context: context,
      );
    } else if (phone.length != AppConstants.APP_PHONE_MAX_LENGTH) {
      setState(() {
        isLoading = false;
      });
      showCustomSnackBar(
        "Entrez un numéro à ${AppConstants.APP_PHONE_MAX_LENGTH} chiffres svp!",
        type: 'error',
        context: context,
      );
    } else if (utilsController.isMobileNumberValid(phone) == false) {
      setState(() {
        isLoading = false;
      });
      showCustomSnackBar(
        "Numéro de téléphone invalide",
        type: 'error',
        context: context,
      );
    } else {
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        isLoading = false;
      });
      ModalLoading.showAlertDialog(
          context, "Votre bien a bien été pris en compte.", "success",
          bntLabel: "Terminer", onRedirect: () {
        Get.to(() => const InitialHomePage());
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
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(AppDimensions.width20),
            child: DelayedAnimation(
              delay: 900,
              child: AppButtonWidget(
                onTap: _isAccept
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          _isAccept ? _goToNext(context) : null;
                        }
                      }
                    : () {},
                size: AppDimensions.font16,
                text: "Déposer le bien",
                icon: Icons.check,
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
                            text: "Prise de contact",
                            size: AppDimensions.font15,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(
                          height: AppDimensions.height35,
                        ),
                        _getForm(),
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
                  delay: 300,
                  child: AppTextField(
                    name: 'email',
                    textEditingController: _contactEmailController,
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
                  height: AppDimensions.height30,
                ),
                DelayedAnimation(
                  delay: 300,
                  child: AppTextField(
                    name: 'phone',
                    type: TextInputType.number,
                    limitNumber: AppConstants.APP_PHONE_MAX_LENGTH,
                    textEditingController: _contactPhoneController,
                    hintText: 'Numéro de téléphone*',
                    icon: Icons.phone,
                    onChange: (phone) {
                      setState(() {
                        countPhoneCaracter = phone!;
                      });
                    },
                    counterText:
                        "${countPhoneCaracter.length.toString()}/${AppConstants.APP_PHONE_MAX_LENGTH}",
                    validators: [
                      FormBuilderValidators.equalLength(
                        AppConstants.APP_PHONE_MAX_LENGTH,
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
