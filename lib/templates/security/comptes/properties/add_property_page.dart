import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/models/properties/add/add_property_model.dart';
import 'package:innovimmobilier/templates/security/comptes/properties/identification_step1.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({Key? key}) : super(key: key);

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isAccept = false;

  _goToNext(BuildContext context, PropertyController propertyController) async {
    if (_isAccept == false) {
      showCustomSnackBar(
        "Veuillez accepter les conditions générales d'utilisation",
        type: 'error',
        context: context,
      );
    } else {
      AddPropertyModel addPropertyModel = AddPropertyModel(isAccept: _isAccept);
      Get.to(() => IdentificationStep1(addPropertyModel: addPropertyModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityController.connectionType.value != 'none') {
        return Scaffold(
          appBar: AppBar(
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
              text: "Déposer un bien",
              size: AppDimensions.font18,
            ),
            leading: HomeActionWidget(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.black.withOpacity(0.6)
                  : AppColors.white,
            ),
          ),
          bottomNavigationBar:
              GetBuilder<PropertyController>(builder: (propertyController) {
            return Container(
              padding: EdgeInsets.all(AppDimensions.width20),
              child: DelayedAnimation(
                delay: 100,
                child: AppButtonWidget(
                  onTap: _isAccept
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            _isAccept
                                ? _goToNext(context, propertyController)
                                : null;
                          }
                        }
                      : () {},
                  size: AppDimensions.font16,
                  text: "Accepter et continuer",
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
            );
          }),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.only(
                top: AppDimensions.height20,
                left: AppDimensions.height20,
                right: AppDimensions.height20,
              ),
              child: FormBuilder(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: AppBigText(
                        text: "Conditions générales d'utilisations",
                        size: AppDimensions.font15,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppDimensions.height35,
                    ),
                    cguText(),
                    SizedBox(
                      child: FormBuilderCheckbox(
                        activeColor:
                            Theme.of(context).brightness == Brightness.light
                                ? AppColors.primary
                                : AppColors.warning,
                        name: 'isAccept',
                        decoration: InputDecoration(
                          isDense: true,
                          errorMaxLines: 1,
                          errorStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? AppColors.white
                                    : AppColors.dark,
                            height: 0,
                            decoration: TextDecoration.none,
                          ),
                          errorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        title: const Text(
                            "J'accept les conditions générales d'utilisations"),
                        onChanged: (value) {
                          if (_formKey.currentState!.validate() && value!) {
                            setState(() {
                              _isAccept = true;
                            });
                          } else {
                            setState(() {
                              _isAccept = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return const NoConnexion();
      }
    });
  }

  Widget cguText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSmallText(
          text: "CGU",
          size: AppDimensions.font15,
        ),
        SizedBox(
          height: AppDimensions.height10,
        ),
        AppSmallText(
          text: "Devenir Hôte sur Africa Booking !",
          size: AppDimensions.font15,
        ),
        SizedBox(
          height: AppDimensions.height10,
        ),
        AppSmallText(
          text:
              "Seuls les propriétaires, les mandataires et toute autre personne physique ou morale ayant l’autorisation préalable du propriétaire sont habilités à enregistrer leurs biens sur la plateforme.",
          maxline: 10,
          size: AppDimensions.font15,
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: AppDimensions.height10,
        ),
        AppBigText(
          text: "Comment enregistrer son bien sur Africa Booking ?",
          maxlines: 2,
          size: AppDimensions.font15,
        ),
        SizedBox(
          height: AppDimensions.height10,
        ),
        AppSmallText(
          text:
              "Créer son compte avec les informations exactes de son identité. Un scanne de la pièce d’identité vous sera demandé pour authentification ; Donner les informations exactes du bien (localisation, nombre de pièces, équipements disponibles…) ainsi que des photos récentes de bonne qualité qui reflètent la réalité ; Vous serez guidé sur la plateforme sur les différentes informations à avoir et à soumettre.",
          maxline: 10,
          size: AppDimensions.font15,
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: AppDimensions.height10,
        ),
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text: AppConstants.APP_NAME,
            style: TextStyle(
              color: Colors.black,
              fontSize: AppDimensions.font15,
              fontWeight: FontWeight.bold,
            ),
            children: <InlineSpan>[
              TextSpan(
                text:
                    " se réserve le droit de refuser l’enregistrement d’un bien si les conditions ne sont pas remplies notamment la qualité des images, photos mensongères, identité méconnue de l’hôte etc. Aucun frais de dépôt n’est exigé. En revanche, des frais sont prélevés pour l’opérateur de paiement automatisé, et des frais de maintenance à ladite plateforme. Le bien est visible par tous les utilisateurs sur le site dès validation de l’enregistrement par ",
                style: TextStyle(
                  fontSize: AppDimensions.font15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: AppConstants.APP_NAME,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: AppDimensions.font15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppDimensions.height10,
        ),
        AppBigText(
          text: "Frais de gestion Africa Booking",
          maxlines: 2,
          size: AppDimensions.font15,
        ),
        SizedBox(
          height: AppDimensions.height10,
        ),
        AppSmallText(
          text:
              "Les frais de gestion s’élève à 2.5% sur une réservation confirmée.",
          maxline: 2,
          size: AppDimensions.font15,
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: AppDimensions.height10,
        ),
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text: "Le bien enregistré sur ",
            style: TextStyle(
              color: Colors.black,
              fontSize: AppDimensions.font15,
            ),
            children: <InlineSpan>[
              TextSpan(
                text: '${AppConstants.APP_NAME}:\n\n',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: AppDimensions.font15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                    "- Innov se réserve le droit de refuser un bien sur sa plateforme sans préavis. Elle peut également suspendre et interrompre l’annonce d’un hébergeur sur sa plateforme sans prévis,\n\n",
                style: TextStyle(
                  fontSize: AppDimensions.font15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text:
                    "- Les images des biens doivent être de bonnes qualités et refléter la réalité. Il est interdit d’enregistrer des photos qui ne respectent l’objet du site, Africa Booking reste l’intermédiaire unique entre l’hôte et le voyageur,\n\n",
                style: TextStyle(
                  fontSize: AppDimensions.font15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text:
                    "- Il est formellement donc formellement interdit aux voyageurs comme à l’hôte de s’échanger les emails, les contacts de quelque façon que ce soit avant la confirmation d’une réservation,\n\n",
                style: TextStyle(
                  fontSize: AppDimensions.font15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text:
                    "- Africa Booking se réserve le droit de faire des contrôles inopinés dans les messageries des hôtes, sauf en cas de litige avec un client.",
                style: TextStyle(
                  fontSize: AppDimensions.font15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
