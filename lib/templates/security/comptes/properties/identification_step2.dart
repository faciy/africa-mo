// ignore_for_file: must_be_immutable

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
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/models/properties/add/add_property_model.dart';
import 'package:innovimmobilier/templates/initial_home_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

class IdentificationStep3 extends StatefulWidget {
  AddPropertyModel? addPropertyModel;
  IdentificationStep3({Key? key, required this.addPropertyModel})
      : super(key: key);

  @override
  State<IdentificationStep3> createState() => _IdentificationStep3State();
}

class _IdentificationStep3State extends State<IdentificationStep3> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isAccept = false;

  _goToNext(BuildContext context, PropertyController propertyController) async {
    _formKey.currentState!.save();
    var images = _formKey.currentState!.value['images'];
    widget.addPropertyModel!.images = images;

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
                    text: 'Voulez-vous confirmer?',
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
                for (var i = 0;
                    i < widget.addPropertyModel!.images.length;
                    i++) {
                  propertyController
                      .addPicture(widget.addPropertyModel!.images[i])
                      .then((status) {
                    if (status.isSuccess) {
                      Get.off(() => const InitialHomePage());
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
                  vertical: AppDimensions.height20,
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
                      Center(
                        child: AppBigText(
                          text: "Enregistrement",
                          size: AppDimensions.font15,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(
                        height: AppDimensions.height35,
                      ),
                      FormBuilderFilePicker(
                        name: "images",
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.grey.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColors.grey.withOpacity(0.1),
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.height20,
                              vertical: AppDimensions.height60,
                            )),
                        maxFiles: null,
                        previewImages: true,
                        onChanged: (val) {},
                        allowMultiple: true,
                        typeSelectors: [
                          TypeSelector(
                            type: FileType.image,
                            selector: Row(
                              children: const <Widget>[
                                Icon(Icons.add_a_photo),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child:
                                      Text("Ajouter des photos de votre bien"),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onFileLoading: (val) {},
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "",
                          ),
                        ]),
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
