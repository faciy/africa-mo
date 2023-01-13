// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/custom_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_text_field.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/decorations/decoration_controller.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/services/models/decorations/decoration_model.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:innovimmobilier/utilities/services/modal_loading.dart';

class DecorationPage extends StatefulWidget {
  String title;
  DecorationPage({Key? key, required this.title}) : super(key: key);

  @override
  State<DecorationPage> createState() => _DecorationPageState();
}

class _DecorationPageState extends State<DecorationPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _residenceController = TextEditingController();
  UtilsController utilsController = Get.put(UtilsController());
  String countPhoneCaracter = "";
  bool _isAccept = false;

  @override
  void initState() {
    super.initState();
    var user = Get.find<UserController>().userModel;
    _nomController.text = user!.nom!;
    _prenomController.text = user.prenoms!;
    _contactEmailController.text = user.email!;
    _contactPhoneController.text = user.tel!;
  }

  _sendDevis(
      BuildContext context, DecorationController decorationController) async {
    String nom = _nomController.text.trim();
    String prenom = _prenomController.text.trim();
    String email = _contactEmailController.text.trim();
    String phone = _contactPhoneController.text.trim();
    String residence = _residenceController.text.trim();

    if (nom.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir votre nom svp!",
        type: 'error',
        context: context,
      );
    } else if (prenom.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir votre prenom svp!",
        type: 'error',
        context: context,
      );
    } else if (email.isEmpty) {
      showCustomSnackBar(
        "Entrez votre adresse email svp!",
        type: 'error',
        context: context,
      );
    } else if (phone.isEmpty) {
      showCustomSnackBar(
        "Entrez votre numéro de téléphone svp!",
        type: 'error',
        context: context,
      );
    } else if (phone.length != AppConstants.APP_PHONE_MAX_LENGTH) {
      showCustomSnackBar(
        "Entrez un numéro à ${AppConstants.APP_PHONE_MAX_LENGTH} chiffres svp!",
        type: 'error',
        context: context,
      );
    } else if (utilsController.isMobileNumberValid(phone) == false) {
      showCustomSnackBar(
        "Numéro de téléphone invalide",
        type: 'error',
        context: context,
      );
    } else if (residence.isEmpty) {
      showCustomSnackBar(
        "Saisissez votre lieu de résidence",
        type: 'error',
        context: context,
      );
    } else {
      DecorationModel decorationModel = DecorationModel(
        nom: nom,
        prenoms: prenom,
        email: email,
        numero: phone,
        residence: residence,
      );
      setState(() {});

      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: AppBigText(
              text: 'Confirmation',
              size: AppDimensions.font18,
            ),
            content:
                GetBuilder<DecorationController>(builder: (devisController) {
              return devisController.isLoading
                  ? CustomBtnLoader()
                  : AppSmallText(
                      text: 'Voulez-vous envoyer ces informations?',
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
                  decorationController
                      .sendDevis(decorationModel)
                      .then((status) {
                    if (status.isSuccess) {
                      ModalLoading.showAlertDialog(
                        context,
                        status.message,
                        "success",
                        bntLabel: "Fermer",
                        onRedirect: () {
                          Get.offAll(() => DecorationPage(
                                title: "Décoration d'intérieur",
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
        return GetBuilder<DecorationController>(
            builder: (decorationController) {
          return GetBuilder<DecorationController>(
              builder: (decorationController) {
            return Scaffold(
              appBar: AppBar(
                leading: HomeActionWidget(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.black.withOpacity(0.6)
                      : AppColors.white,
                ),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor:
                      Theme.of(context).brightness == Brightness.light
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
                  text: widget.title,
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
                                  ? _sendDevis(context, decorationController)
                                  : null;
                            }
                          }
                        : () {},
                    size: AppDimensions.font16,
                    text: "Envoyer",
                    icon: Icons.send,
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
              body: decorationController.isLoading
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
                                text: "Demander un dévis",
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
          });
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
                  delay: 300,
                  child: AppTextField(
                    name: 'nom',
                    textEditingController: _nomController,
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
                  height: AppDimensions.height20,
                ),
                DelayedAnimation(
                  delay: 300,
                  child: AppTextField(
                    name: 'prenom',
                    textEditingController: _prenomController,
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
                  height: AppDimensions.height20,
                ),
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
                  height: AppDimensions.height20,
                ),
                DelayedAnimation(
                  delay: 300,
                  child: AppTextField(
                    name: 'residence',
                    textEditingController: _residenceController,
                    hintText: 'Residence *',
                    icon: Icons.email,
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
