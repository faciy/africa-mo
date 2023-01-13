// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
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
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/controllers/locations/location_service_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/communes/commune_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/types/property_type_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/services/models/properties/property_model.dart';
import 'package:innovimmobilier/templates/security/comptes/properties/edits/galerie_page.dart';
import 'package:innovimmobilier/templates/security/comptes/properties/properties_list_page.dart';
import 'package:innovimmobilier/templates/security/comptes/properties/show_map.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:innovimmobilier/utilities/services/modal_loading.dart';

class EditPropertyPage extends StatefulWidget {
  String title;
  PropertyModel? propertyModel;
  bool? isHome;
  EditPropertyPage(
      {Key? key, required this.title, required this.propertyModel, this.isHome})
      : super(key: key);

  @override
  State<EditPropertyPage> createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage>
    with WidgetsBindingObserver {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LocationServiceController locationController =
      Get.put(LocationServiceController());
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _libelleController = TextEditingController();
  final TextEditingController _natureController = TextEditingController();
  final TextEditingController _communceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _nombrePieceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _situationController = TextEditingController();
  final TextEditingController _equipementController = TextEditingController();
  final TextEditingController _chargeController = TextEditingController();
  UtilsController utilsController = Get.put(UtilsController());
  bool _isAccept = false;
  bool _isNbrePiece = false;
  String countPhoneCaracter = "";

  List<String> extensions = ['jpg', 'png'];
  bool isImageLoad = false;
  bool? isHome;
  LatLng latLng = AppConstants.INIT_POSITION;

  @override
  void initState() {
    super.initState();
    isHome = widget.isHome;
    WidgetsBinding.instance.addObserver(this);
    _natureController.text = widget.propertyModel!.typebien_id.toString();
    _communceController.text = widget.propertyModel!.commune_id.toString();
    _libelleController.text = widget.propertyModel!.libelle!;
    _locationController.text = widget.propertyModel!.localisation!;
    _priceController.text = widget.propertyModel!.prix.toString();
    _nombrePieceController.text = widget.propertyModel!.nombre_piece.toString();
    _descriptionController.text = widget.propertyModel!.description!;
    _conditionController.text = widget.propertyModel!.condition!;
    _situationController.text = widget.propertyModel!.situation!;
    _equipementController.text = widget.propertyModel!.equipement!;
    _chargeController.text = widget.propertyModel!.charge_incluse!;
    locationController.cleanMarer();
    getLatLng();
    if (widget.propertyModel!.typebien_id != 1) {
      _isNbrePiece = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> getLatLng() async {
    if (mounted && widget.propertyModel!.map != null) {
      var getLatLng = widget.propertyModel!.map!.split(';');
      latLng = LatLng(double.parse(getLatLng[0]), double.parse(getLatLng[1]));
      //await locationController.setMarker(latLng, id: widget.propertyModel!.id);
      _isAccept = true;
    }
  }

  final geoMethods = GeoMethods(
    googleApiKey: AppConstants.GOOGLE_API_KEY,
    language: 'fr',
    countryCode: 'ci',
    countryCodes: ['CI'],
    country: 'Côte d\'Ivoire',
    city: 'Abidjan',
  );

  _updateProperty(
      BuildContext context, PropertyController propertyController) async {
    String libelle = _libelleController.text.trim();
    String nature = _natureController.text.trim();
    String commune = _communceController.text.trim();
    String location = _locationController.text.trim();
    String price = _priceController.text.trim();
    String nombrePiece = _nombrePieceController.text.trim();
    String description = _descriptionController.text.trim();
    String situation = _situationController.text.trim();
    String condition = _conditionController.text.trim();
    String equipement = _equipementController.text.trim();
    String chargeIncluse = _chargeController.text.trim();
    setState(() {});

    _formKey.currentState!.save();
    dynamic image;
    if (isImageLoad) {
      image = File(_formKey.currentState!.value['image'][0].path);
    }

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
    } else if (nombrePiece.isEmpty && nombrePiece == 'null') {
      showCustomSnackBar(
        "Entrez le nombre de pièce svp!",
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
        widget.propertyModel!.map = position.toString();
        setState(() {});
      }
      widget.propertyModel!.libelle = libelle;
      widget.propertyModel!.localisation = location;
      widget.propertyModel!.typebien_id = int.parse(nature);
      widget.propertyModel!.commune_id = int.parse(commune);
      widget.propertyModel!.prix = int.parse(price);
      widget.propertyModel!.nombre_piece = int.parse(nombrePiece);
      widget.propertyModel!.description = description;
      widget.propertyModel!.situation = situation;
      widget.propertyModel!.condition = condition;
      widget.propertyModel!.equipement = equipement;
      widget.propertyModel!.charge_incluse = chargeIncluse;
      setState(() {});
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: AppBigText(
              text: 'Confirmation',
              size: AppDimensions.font18,
            ),
            content: GetBuilder<PropertyController>(builder: (proController) {
              return proController.isLoading
                  ? CustomBtnLoader()
                  : AppSmallText(
                      text: 'Voulez-vous sauver les informations?',
                      size: AppDimensions.font13,
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
                  propertyController
                      .updateData(widget.propertyModel!, image)
                      .then((status) {
                    if (status.isSuccess) {
                      Get.back();
                      showCustomSnackBar(
                        status.message,
                        type: 'success',
                        context: context,
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
                  text: 'Oui, sauvégarder',
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

  _deleteProperty(
      BuildContext context, PropertyController propertyController) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: AppBigText(
            text: 'Suppression',
            size: AppDimensions.font18,
          ),
          content: GetBuilder<PropertyController>(builder: (propController) {
            return propController.isLoading
                ? CustomBtnLoader()
                : AppSmallText(
                    text: 'Voulez-vous confirmer ce bien?',
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
                propertyController
                    .delete(widget.propertyModel!.id!)
                    .then((status) {
                  if (status.isSuccess) {
                    ModalLoading.showAlertDialog(
                      context,
                      status.message,
                      "success",
                      bntLabel: "Fermer",
                      onRedirect: () {
                        Get.offAll(
                          () => PropertiesListPage(
                            title: 'Gérer mes biens',
                          ),
                        );
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
                text: 'Oui, Supprimer',
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityController.connectionType.value != 'none') {
        return GetBuilder<PropertyController>(builder: (propertyController) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: HomeActionWidget(
                isHome: isHome,
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
                text: widget.title,
                size: AppDimensions.font18,
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(AppDimensions.width20),
              child: DelayedAnimation(
                delay: 900,
                child: SizedBox(
                  height: AppDimensions.height100,
                  child: Column(
                    children: [
                      AppButtonWidget(
                        onTap: _isAccept
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  _isAccept
                                      ? _updateProperty(
                                          context, propertyController)
                                      : null;
                                }
                              }
                            : () {},
                        size: AppDimensions.font16,
                        text: "Sauvégarder les informations",
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
                      SizedBox(
                        height: AppDimensions.height10,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            AppButtonWidget(
                              isResponsive: true,
                              onTap: () {
                                _deleteProperty(context, propertyController);
                              },
                              size: AppDimensions.font16,
                              icon: Icons.delete,
                              color: AppColors.white,
                              iconColor: AppColors.white,
                              buttonColor: AppColors.danger,
                              buttonBorderColor: AppColors.danger,
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            SizedBox(
                              width: AppDimensions.width10,
                            ),
                            Expanded(
                              child: AppButtonWidget(
                                onTap: () {
                                  propertyController
                                      .find(widget.propertyModel!.id!)
                                      .then((status) {
                                    if (status.isSuccess) {
                                      Get.to(
                                        () => GaleriePage(
                                          propertyModel:
                                              propertyController.propertySingle,
                                        ),
                                      );
                                    }
                                  });
                                },
                                size: AppDimensions.font16,
                                icon: Icons.image,
                                text: "Voir les images",
                                color: AppColors.white,
                                iconColor: AppColors.white,
                                buttonColor: AppColors.primary,
                                buttonBorderColor: AppColors.primary,
                                width: MediaQuery.of(context).size.width,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
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
                        text: "Modification du bien",
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
                      initialValue: int.parse(
                          widget.propertyModel!.typebien_id.toString()),
                      key: Key(widget.propertyModel!.typebien_id.toString()),
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
                          value: item.id == widget.propertyModel!.typebien_id
                              ? widget.propertyModel!.typebien_id
                              : item.id,
                          child: Text(item.libelle.toString()),
                        );
                      }).toList(),
                      onSaved: (newValue) {
                        _natureController.text = newValue.toString();
                      },
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
                      hintText: 'Nombre de pièces *',
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
                      initialValue: int.parse(
                          widget.propertyModel!.commune_id.toString()),
                      key: Key(widget.propertyModel!.commune_id.toString()),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.width10),
                        labelText: 'Commune *',
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
                          value: item.id == widget.propertyModel!.commune_id
                              ? widget.propertyModel!.commune_id
                              : item.id,
                          child: Text(item.libelle.toString()),
                        );
                      }).toList(),
                      onSaved: (newValue) {
                        _communceController.text = newValue.toString();
                      },
                      onChanged: (val) {
                        setState(() {
                          _communceController.text = val.toString();
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
                    hintText: 'libélle du bien *',
                    icon: Icons.text_fields,
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
                      initialCameraPosition: CameraPosition(
                        target: latLng,
                        tilt: 50.0,
                        bearing: 45.0,
                        zoom: 10.0,
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
                    name: 'descriptin',
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
                  height: AppDimensions.height20,
                ),
                DelayedAnimation(
                  delay: 300,
                  child: AppTextareaField(
                    label: "Situation du bien",
                    name: 'situation',
                    textEditingController: _situationController,
                    hintText: 'Situation',
                  ),
                ),
                SizedBox(
                  height: AppDimensions.height20,
                ),
                DelayedAnimation(
                  delay: 300,
                  child: AppTextareaField(
                    label: "Condition du bien",
                    name: 'condition',
                    textEditingController: _conditionController,
                    hintText: 'Contitions',
                  ),
                ),
                SizedBox(
                  height: AppDimensions.height20,
                ),
                DelayedAnimation(
                  delay: 300,
                  child: AppTextareaField(
                    label: "Equipement du bien",
                    name: 'equipement',
                    textEditingController: _equipementController,
                    hintText: 'Equipements',
                  ),
                ),
                SizedBox(
                  height: AppDimensions.height30,
                ),
                DelayedAnimation(
                  delay: 300,
                  child: AppTextareaField(
                    label: "Charge",
                    name: 'charge',
                    textEditingController: _chargeController,
                    hintText: 'Charges incluses',
                  ),
                ),
                SizedBox(
                  height: AppDimensions.height10,
                ),
                DelayedAnimation(
                  delay: 600,
                  child: FormBuilderFilePicker(
                    name: 'image',
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
                        isImageLoad = true;
                      });
                      debugPrint(val.toString());
                    },
                    allowedExtensions: extensions,
                  ),
                ),
                if (widget.propertyModel!.image != null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: AppDimensions.height300,
                    child: Image.network(
                      fit: BoxFit.cover,
                      ApiUri.APP_UPLOAD +
                          widget.propertyModel!.image.toString(),
                    ),
                  ),
                SizedBox(
                  height: AppDimensions.height10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
