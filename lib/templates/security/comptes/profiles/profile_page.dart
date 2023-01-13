// ignore_for_file: use_build_context_synchronously

import 'dart:io';

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
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/services/models/users/user_model.dart';
import 'package:innovimmobilier/templates/security/comptes/compte_screen.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:innovimmobilier/utilities/services/modal_loading.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());

  final _formKey = GlobalKey<FormBuilderState>();
  UtilsController utilsController = Get.put(UtilsController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  bool _isAccept = false;
  String countPhoneCaracter = "";
  List<String> extensions = ['jpg', 'png'];
  bool isPAvatarLoad = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserInfos();
    });
  }

  checkUserInfos() {
    var user = Get.find<UserController>().userModel;
    if (user == null) {
      Get.find<UserController>().getUserInfos();
    }
    _nomController.text = user!.nom!;
    _prenomController.text = user.prenoms!;
    _emailController.text = user.email!;

    if (user.tel != null) {
      _numeroController.text = user.tel!;
    }
    if (user.profession != null) {
      _professionController.text = user.profession!;
    }

    setState(() {});
  }

  _editUserInfos(BuildContext context, UserController userController) async {
    String email = _emailController.text.trim();
    String nom = _nomController.text.trim();
    String prenom = _prenomController.text.trim();
    String numero = _numeroController.text.trim();
    String profession = _professionController.text.trim();

    _formKey.currentState!.save();
    dynamic avatar;
    if (isPAvatarLoad) {
      avatar = File(_formKey.currentState!.value['avatar'][0].path);
    }

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
    } else if (numero.length != AppConstants.APP_PHONE_MAX_LENGTH) {
      showCustomSnackBar(
        "Numéro de téléphone invalide.",
        type: 'error',
        context: context,
      );
    } else if (utilsController.isMobileNumberValid(numero) == false) {
      showCustomSnackBar(
        "Numéro de téléphone invalide",
        type: 'error',
        context: context,
      );
    } else {
      UserModel userModel = UserModel();
      setState(() {
        userModel.nom = nom;
        userModel.prenoms = prenom;
        userModel.email = email;
        userModel.tel = numero;
        userModel.profession = profession;
      });
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: AppBigText(
              text: 'Confirmation',
              size: AppDimensions.font18,
            ),
            content: GetBuilder<UserController>(builder: (usController) {
              return usController.isLoading
                  ? CustomBtnLoader()
                  : AppSmallText(
                      text: 'Voulez-vous sauvégarder les informations?',
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
                      .editUserInfos(userModel, avatar)
                      .then((status) {
                    if (status.isSuccess) {
                      ModalLoading.showAlertDialog(
                        context,
                        status.message,
                        "success",
                        bntLabel: "Fermer",
                        onRedirect: () {
                          Get.off(() => const CompteScreen());
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
                  text: 'Oui',
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
                text: "Informations personnelles",
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
                                ? _editUserInfos(context, userController)
                                : null;
                          }
                        }
                      : () {},
                  size: AppDimensions.font16,
                  text: "Sauvégarder les informations",
                  icon: Icons.save,
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
                  vertical: AppDimensions.height10,
                ),
                child: Column(
                  children: [
                    _editForm(),
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

  Widget _editForm() {
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
                    label: "Nom",
                    name: 'nom',
                    textEditingController: _nomController,
                    hintText: 'Votre nom *',
                    icon: Icons.person,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: "Le champs nom est obligatoire",
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
                    label: "Prénoms",
                    name: 'prenom',
                    textEditingController: _prenomController,
                    hintText: 'Votre prénom *',
                    icon: Icons.person,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: "Le champs prenom est obligatoire",
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
                    label: "Adresse email",
                    name: 'email',
                    textEditingController: _emailController,
                    hintText: 'Adresse email*',
                    icon: Icons.email,
                    validators: [
                      FormBuilderValidators.email(
                        errorText: "Adresse email invalide",
                      ),
                      FormBuilderValidators.required(
                        errorText: "Adresse email obligatoire",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppDimensions.height20,
                ),
                DelayedAnimation(
                  delay: 700,
                  child: AppTextField(
                    label: "Numéro de téléphone",
                    name: 'numero',
                    type: TextInputType.number,
                    limitNumber: AppConstants.APP_PHONE_MAX_LENGTH,
                    textEditingController: _numeroController,
                    hintText: 'Numéro de téléphone',
                    icon: Icons.phone,
                    onChange: (phone) {
                      setState(() {
                        countPhoneCaracter = phone!;
                      });
                    },
                    counterText:
                        "${countPhoneCaracter.length.toString()}/${AppConstants.APP_PHONE_MAX_LENGTH}",
                  ),
                ),
                DelayedAnimation(
                  delay: 300,
                  child: AppTextField(
                    label: "Profession",
                    name: 'profession',
                    textEditingController: _professionController,
                    hintText: 'Profession',
                    icon: Icons.grade_rounded,
                  ),
                ),
                /* SizedBox(
                  height: AppDimensions.height10,
                ),
                DelayedAnimation(
                  delay: 600,
                  child: FormBuilderFilePicker(
                    name: 'avatar',
                    maxFiles: null,
                    previewImages: true,
                    onChanged: (val) => debugPrint(val.toString()),
                    typeSelectors: [
                      TypeSelector(
                          type: FileType.custom,
                          selector: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Icon(Icons.add_a_photo),
                              SizedBox(
                                width: AppDimensions.width20,
                              ),
                              const Text("Selectionner une photo"),
                            ],
                          ))
                    ],
                    onFileLoading: (val) {
                      setState(() {
                        isPAvatarLoad = true;
                      });
                      debugPrint(val.toString());
                    },
                    allowedExtensions: extensions,
                  ),
                ), */
              ],
            ),
          )
        ],
      ),
    );
  }
}
