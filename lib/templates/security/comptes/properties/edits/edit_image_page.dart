// ignore_for_file: must_be_immutable, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/services/models/properties/image_model.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class EditImagePage extends StatefulWidget {
  ImageModel? imageModel;
  EditImagePage({Key? key, required this.imageModel}) : super(key: key);

  @override
  State<EditImagePage> createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final _formKey = GlobalKey<FormBuilderState>();
  UtilsController utilsController = Get.put(UtilsController());
  bool _isAccept = false;

  List<String> extensions = ['jpg', 'png'];
  bool isImageLoad = false;

  _editImage(
      BuildContext context, PropertyController propertyController) async {
    _formKey.currentState!.save();
    dynamic image;
    if (isImageLoad) {
      image = File(_formKey.currentState!.value['image'][0].path);
    }
    propertyController
        .editPicture(
      image,
      widget.imageModel!.id!,
    )
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
                text: "Modifier l'image",
                size: AppDimensions.font18,
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(AppDimensions.width20),
              child: DelayedAnimation(
                delay: 900,
                child: propertyController.isLoading
                    ? CustomBtnLoader()
                    : AppButtonWidget(
                        onTap: _isAccept
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  _isAccept
                                      ? _editImage(context, propertyController)
                                      : null;
                                }
                              }
                            : () {},
                        size: AppDimensions.font16,
                        text: "Modifier l'image",
                        icon: Icons.edit,
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
            body: Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.width20,
                vertical: AppDimensions.height10,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: AppDimensions.height15,
                  ),
                  _getForm(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: AppDimensions.height300,
                    child: Image.network(
                      fit: BoxFit.cover,
                      ApiUri.APP_UPLOAD + widget.imageModel!.src.toString(),
                    ),
                  ),
                ],
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
                SizedBox(
                  height: AppDimensions.height20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
