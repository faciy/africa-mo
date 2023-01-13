// ignore_for_file: must_be_immutable

import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_text_field.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_textarea_field.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/locations/location_service_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/communes/commune_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/types/property_type_controller.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/services/models/properties/add/add_property_model.dart';
import 'package:innovimmobilier/templates/security/comptes/properties/identification_step2.dart';
import 'package:innovimmobilier/templates/security/comptes/properties/show_map.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class IdentificationStep1 extends StatefulWidget {
  AddPropertyModel? addPropertyModel;
  IdentificationStep1({Key? key, required this.addPropertyModel})
      : super(key: key);

  @override
  State<IdentificationStep1> createState() => _IdentificationStep1State();
}

class _IdentificationStep1State extends State<IdentificationStep1> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _libelleController = TextEditingController();
  final TextEditingController _natureController = TextEditingController();
  final TextEditingController _communeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _nombrePieceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  UtilsController utilsController = Get.put(UtilsController());
  bool _isAccept = false;
  bool _isNbrePiece = false;
  String countPhoneCaracter = "";

  @override
  void initState() {
    super.initState();
    _nombrePieceController.text = "1";
  }

  final geoMethods = GeoMethods(
    googleApiKey: AppConstants.GOOGLE_API_KEY,
    language: 'fr',
    countryCode: 'ci',
    countryCodes: ['CI'],
    country: 'Côte d\'Ivoire',
    city: 'Abidjan',
  );

  _goToNext(BuildContext context, PropertyController propertyController) async {
    var userId = Get.find<UserController>().userModel!.id;
    String libelle = _libelleController.text.trim();
    String nature = _natureController.text.trim();
    String commune = _communeController.text.trim();
    String location = _locationController.text.trim();
    String price = _priceController.text.trim();
    String nombrePiece = _nombrePieceController.text.trim();
    String description = _descriptionController.text.trim();

    if (libelle.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir le libéllé du bien svp!",
        type: 'error',
        context: context,
      );
    } else if (nature.isEmpty) {
      showCustomSnackBar(
        "Veuillez sélectionner un type de bien svp!",
        type: 'error',
        context: context,
      );
    } else if (commune.isEmpty) {
      showCustomSnackBar(
        "Veuillez sélectionner une commune svp!",
        type: 'error',
        context: context,
      );
    } else if (location.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir la localisation du bien svp!",
        type: 'error',
        context: context,
      );
    } else if (price.isEmpty) {
      showCustomSnackBar(
        "Entrez le prix du bien svp!",
        type: 'error',
        context: context,
      );
    } else if (description.isEmpty) {
      showCustomSnackBar(
        "Entrez la description svp!",
        type: 'error',
        context: context,
      );
    } else {
      if (Get.find<LocationServiceController>().markerPosition != null) {
        var position =
            "${Get.find<LocationServiceController>().markerPosition!.latitude};${Get.find<LocationServiceController>().markerPosition!.longitude}";
        widget.addPropertyModel!.map = position.toString();
        setState(() {});
      }

      setState(() {
        widget.addPropertyModel!.user_id = userId;
        widget.addPropertyModel!.libelle = libelle;
        widget.addPropertyModel!.typebien_id = int.parse(nature);
        widget.addPropertyModel!.commune_id = int.parse(commune);
        widget.addPropertyModel!.localisation = location;
        widget.addPropertyModel!.prix = int.parse(price);
        widget.addPropertyModel!.nombre_piece = int.parse(nombrePiece);
        widget.addPropertyModel!.description = description;
      });

      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: AppBigText(
              text: 'Confirmation',
              size: AppDimensions.font18,
            ),
            content: GetBuilder<PropertyController>(builder: (proController) {
              return proController.isLoading
                  ? CustomBtnLoader()
                  : AppSmallText(
                      text: 'Voulez-vous continuer?',
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
                  await propertyController
                      .add(widget.addPropertyModel!)
                      .then((status) {
                    if (status.isSuccess) {
                      Get.to(
                        () => IdentificationStep3(
                          addPropertyModel: widget.addPropertyModel,
                        ),
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
        return GetBuilder<PropertyController>(builder: (propertyController) {
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
                text: "Déposer un bien",
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
                                ? _goToNext(context, propertyController)
                                : null;
                          }
                        }
                      : () {},
                  size: AppDimensions.font16,
                  text: "Suivant",
                  icon: Icons.arrow_forward_ios,
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
                    Center(
                      child: AppBigText(
                        text: "Identification",
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
                  child: GetBuilder<PropertyTypeController>(
                      builder: (propertyTypeController) {
                    var itemsDrop =
                        propertyTypeController.categoryListModel!.toList();
                    return FormBuilderDropdown(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.width10),
                        labelText: 'Nature du bien *',
                        hintText: 'Sélectionner un type de bien',
                        prefixIcon: Icon(
                          Icons.inbox,
                          size: AppDimensions.font16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(errorText: "")],
                      ),
                      name: "nature_bien",
                      items: itemsDrop.map((item) {
                        return DropdownMenuItem(
                          value: item.id.toString(),
                          child: Text(item.libelle.toString()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _isNbrePiece = false;
                          _natureController.text = val.toString();

                          if (val.toString() != "1") {
                            _isNbrePiece = true;
                          }
                        });
                      },
                    );
                  }),
                ),
                if (_isNbrePiece == true)
                  SizedBox(
                    height: AppDimensions.height20,
                  ),
                if (_isNbrePiece == true)
                  DelayedAnimation(
                    delay: 300,
                    child: AppTextField(
                      label: "Nombre de pièces",
                      name: 'nombrePiece',
                      type: TextInputType.number,
                      textEditingController: _nombrePieceController,
                      hintText: 'Nombre de pièce *',
                      icon: Icons.numbers,
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
                  child: GetBuilder<CommuneController>(
                      builder: (communeController) {
                    var itemsDrop =
                        communeController.communeListModel!.toList();
                    return FormBuilderDropdown(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.width10),
                        labelText: 'Commune où se trouve le bien *',
                        hintText: 'Sélectionner une commune svp!',
                        prefixIcon: Icon(
                          Icons.maps_home_work_outlined,
                          size: AppDimensions.font16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(errorText: "")],
                      ),
                      name: "commune",
                      items: itemsDrop.map((item) {
                        return DropdownMenuItem(
                          value: item.id.toString(),
                          child: Text(item.libelle.toString()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _communeController.text = val.toString();
                        });
                      },
                    );
                  }),
                ),
                SizedBox(
                  height: AppDimensions.height20,
                ),
                DelayedAnimation(
                  delay: 300,
                  child: AppTextField(
                    label: "Libéllé du bien",
                    name: 'libelle',
                    textEditingController: _libelleController,
                    hintText: 'Libélle du bien *',
                    icon: Icons.text_fields,
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
                AppSmallText(
                    text:
                        "Cliquez sur la map pour sélectionner le lieu du bien"),
                SizedBox(
                  height: AppDimensions.height5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                    color: AppColors.cream,
                  ),
                  child: GetBuilder<LocationServiceController>(
                      builder: (mapController) {
                    return GoogleMap(
                      zoomControlsEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: false,
                      mapType: MapType.normal,
                      initialCameraPosition: const CameraPosition(
                        target: AppConstants.INIT_POSITION,
                        tilt: 50.0,
                        bearing: 45.0,
                        zoom: 14.0,
                      ),
                      onMapCreated: (GoogleMapController controller) async {
                        mapController.onMapCreated(controller);
                      },
                      markers: mapController.marker,
                      onTap: (LatLng latLng) {
                        Get.to(() => const ShowMap(), fullscreenDialog: true);
                      },
                    );
                  }),
                ),
                SizedBox(
                  height: AppDimensions.height20,
                ),
                DelayedAnimation(
                  delay: 300,
                  child: AppTextField(
                    label: "Localisation du bien",
                    name: 'localisation',
                    textEditingController: _locationController,
                    hintText: 'Localiation du bien *',
                    icon: Icons.location_on,
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AddressSearchDialog(
                        geoMethods: geoMethods,
                        controller: _locationController,
                      ),
                    ),
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
                    label: "Prix du bien",
                    name: 'prix',
                    type: TextInputType.number,
                    textEditingController: _priceController,
                    hintText: 'Prix de la nuitée *',
                    icon: Icons.attach_money_sharp,
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
                  child: AppTextareaField(
                    label: "Description du bien",
                    name: 'description',
                    textEditingController: _descriptionController,
                    hintText: 'Description du bien *',
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
