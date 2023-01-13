import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/custom_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/empty_page.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_date_field.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_text_field.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/properties/communes/commune_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/communes/searchs/search_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/types/property_type_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/models/properties/searchs/search_model.dart';
import 'package:innovimmobilier/templates/initial_home_page.dart';
import 'package:innovimmobilier/templates/search/search_result_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({Key? key}) : super(key: key);

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _communeController = TextEditingController();
  final TextEditingController _typePropertyController = TextEditingController();
  final TextEditingController _nbrePieceController = TextEditingController();
  final TextEditingController _startSejourController = TextEditingController();
  final TextEditingController _endSejourController = TextEditingController();

  bool _isAccept = false;
  bool _isNbrePiece = false;

  @override
  void initState() {
    super.initState();
    _nbrePieceController.text = "1";
  }

  _fetchData(BuildContext context, SearchController searchController) async {
    var communeId = _communeController.text;
    var typeId = _typePropertyController.text;
    var nbrePiece = _nbrePieceController.text;
    var startDate = _startSejourController.text;
    var endDate = _endSejourController.text;

    if (communeId.isEmpty) {
      showCustomSnackBar(
        "Veuillez sélectionner une commune svp!",
        type: 'error',
        context: context,
      );
    } else if (typeId.isEmpty) {
      showCustomSnackBar(
        "Veuillez sélectionner un type de bien svp!",
        type: 'error',
        context: context,
      );
    } else {
      SearchModel searchModel = SearchModel(
        localisation: int.parse(communeId),
        typebien: int.parse(typeId),
        nb_piece: nbrePiece,
        date_debut: startDate,
        date_fin: endDate,
      );
      setState(() {});
      searchController.search(searchModel).then((status) {
        if (status.isSuccess) {
          showCustomSnackBar(
            status.message,
            type: 'success',
            context: context,
          );
        } else {
          _communeController.text = communeId;
          _typePropertyController.text = typeId;
          _startSejourController.text = startDate;
          _endSejourController.text = endDate;
          setState(() {});
          Get.back();
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
        return GetBuilder<SearchController>(builder: (searchController) {
          var listProperties =
              searchController.searchPropertyListModel!.toList();
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
              title: listProperties.isNotEmpty
                  ? AppSmallText(
                      text: "Résultats de la recherche",
                      size: AppDimensions.font18,
                    )
                  : AppSmallText(
                      text: "Recherchez un bien",
                      size: AppDimensions.font18,
                    ),
              actions: listProperties.isNotEmpty
                  ? [
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: AppDimensions.width10),
                        child: GestureDetector(
                          onTap: () {
                            searchController.clearSeachResults();
                            Get.offAll(() => const InitialHomePage());
                          },
                          child: const Icon(Icons.close),
                        ),
                      )
                    ]
                  : [],
            ),
            bottomNavigationBar: listProperties.isEmpty
                ? Container(
                    padding: EdgeInsets.all(AppDimensions.width20),
                    child: DelayedAnimation(
                      delay: 900,
                      child: searchController.isLoading
                          ? CustomBtnLoader()
                          : AppButtonWidget(
                              onTap: _isAccept
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        _isAccept
                                            ? _fetchData(
                                                context, searchController)
                                            : null;
                                      }
                                    }
                                  : () {},
                              size: AppDimensions.font16,
                              text: "Rechercher",
                              icon: Icons.search,
                              color: _isAccept
                                  ? AppColors.white
                                  : AppColors.black.withOpacity(0.6),
                              iconColor: _isAccept
                                  ? AppColors.white
                                  : AppColors.black.withOpacity(0.6),
                              buttonColor: _isAccept
                                  ? AppColors.primary
                                  : AppColors.grey,
                              buttonBorderColor: _isAccept
                                  ? AppColors.primary
                                  : AppColors.grey,
                              width: MediaQuery.of(context).size.width,
                            ),
                    ),
                  )
                : const SizedBox(),
            body: searchController.isLoading
                ? const CustomLoader()
                : listProperties.isNotEmpty
                    ? const SearchResultPage()
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          margin: EdgeInsets.only(
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
                              children: [
                                SizedBox(height: AppDimensions.height30),
                                DelayedAnimation(
                                  delay: 100,
                                  child: GetBuilder<CommuneController>(
                                      builder: (communeController) {
                                    var itemsDrop = communeController
                                        .communeListModel!
                                        .toList();
                                    return FormBuilderDropdown(
                                      hint: AppSmallText(
                                          text: "Sélectionner une commune"),
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        floatingLabelAlignment:
                                            FloatingLabelAlignment.center,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: AppDimensions.width10),
                                        labelText: 'Commune *',
                                        labelStyle: TextStyle(
                                          fontSize: AppDimensions.font22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.home,
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
                                        [
                                          FormBuilderValidators.required(
                                              errorText:
                                                  "Veuillez sélectionner une commune svp!")
                                        ],
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
                                          _communeController.text =
                                              val.toString();
                                        });
                                      },
                                    );
                                  }),
                                ),
                                SizedBox(
                                  height: AppDimensions.height20,
                                ),
                                DelayedAnimation(
                                  delay: 200,
                                  child: GetBuilder<PropertyTypeController>(
                                      builder: (propertyTypeController) {
                                    var itemsDrop = propertyTypeController
                                        .categoryListModel!
                                        .toList();
                                    return FormBuilderDropdown(
                                      hint: AppSmallText(
                                          text: "Sélectionner un type de bien"),
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        floatingLabelAlignment:
                                            FloatingLabelAlignment.center,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: AppDimensions.width10),
                                        labelText: 'Type de bien *',
                                        labelStyle: TextStyle(
                                          fontSize: AppDimensions.font22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.home,
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
                                        [
                                          FormBuilderValidators.required(
                                              errorText:
                                                  "Veuillez sélectionner un type de bien svp!")
                                        ],
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
                                          _typePropertyController.text =
                                              val.toString();
                                          _isNbrePiece = false;
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
                                      label: "Nombre de pièce",
                                      name: 'nombrePiece',
                                      type: TextInputType.number,
                                      textEditingController:
                                          _nbrePieceController,
                                      hintText: 'Nombre de pièce',
                                      icon: Icons.numbers,
                                    ),
                                  ),
                                SizedBox(
                                  height: AppDimensions.height20,
                                ),
                                Column(
                                  children: [
                                    DelayedAnimation(
                                      delay: 400,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: AppDateField(
                                          lastDate: true,
                                          textEditingController:
                                              _startSejourController,
                                          name: "start_sejour",
                                          label: "Début du séjour",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppDimensions.height20,
                                    ),
                                    DelayedAnimation(
                                      delay: 500,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: AppDateField(
                                          lastDate: true,
                                          textEditingController:
                                              _endSejourController,
                                          name: "end_sejour",
                                          label: "Fin du séjour",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: AppDimensions.height40,
                                ),
                                EmptyPage(
                                  isHome: false,
                                ),
                                SizedBox(
                                  height: AppDimensions.height40,
                                ),
                              ],
                            ),
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
}
