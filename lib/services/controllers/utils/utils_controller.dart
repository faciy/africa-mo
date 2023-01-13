// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/services/controllers/messages/message_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/communes/commune_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/types/property_type_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/taxes/taxe_controller.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/templates/security/authentication/login_page.dart';
import 'package:innovimmobilier/utilities/services/modal_loading.dart';
import 'package:intl/intl.dart' as intl;

class UtilsController extends GetxController implements GetxService {
  int _increment = 0;
  bool _incrementIsActive = false;
  Timer? timer;

  int get increment => _increment;
  bool get incrementIsActive => _incrementIsActive;

  void checkUserValid({BuildContext? context}) async {
    if (Get.find<UserController>().userLoggedIn()) {
      await Get.find<UserController>()
          .getUserInfos(isLoaded: false)
          .then((status) async {
        if (status.isSuccess) {
          var user = Get.find<UserController>().userModel;
          if (user!.valid == 0) {
            await Get.find<UserController>()
                .logout(isLoaded: false)
                .then((statutLogout) {
              if (statutLogout.isSuccess) {
                if (Get.key.currentContext != null) {
                  ModalLoading.alert(
                    Get.key.currentContext!,
                    "Information",
                    "Votre compte a été supprimé ou désactivé, veuillez réessayer plutard ou contacter le service client.",
                    "success",
                    onRedirect: () {
                      Get.offAll(() => LoginPage());
                    },
                  );
                }
              }
            });
          }
        }
      });
    }
  }

  void refreshDatas() async {
    await Get.find<UserController>()
        .getUserInfos(isLoaded: false)
        .then((status) async {
      if (status.isSuccess) {
        if (Get.find<PropertyController>().properties!.isEmpty) {
          await Get.find<PropertyController>().findAll(isLoaded: false);
        }
        if (Get.find<PropertyController>().userProperties!.isEmpty) {
          await Get.find<PropertyController>()
              .getUserProperties(isLoaded: false);
        }
        if (Get.find<PropertyTypeController>().propertiesListModel!.isEmpty) {
          await Get.find<PropertyTypeController>().findAll(isLoaded: false);
        }
        if (Get.find<MessageController>().messageListHoteModel!.isEmpty) {
          await Get.find<MessageController>().findAllHote(isLoaded: false);
        }

        if (Get.find<MessageController>().messageListClientModel!.isEmpty) {
          await Get.find<MessageController>().findAllClient(isLoaded: false);
        }
        if (Get.find<CommuneController>().communeListModel!.isEmpty) {
          await Get.find<CommuneController>().findAll(isLoaded: false);
        }
        if (Get.find<TaxeController>().taxeListModel!.isEmpty) {
          await Get.find<TaxeController>().findAll(isLoaded: false);
        }
      }
    });
  }

  String formatDate(String dateString) {
    var dateInit = dateString.substring(0, 10);
    var dateExplode = dateInit.split('-');
    var heure = dateString.substring(11, 16);

    var date = '${dateExplode[2]}/${dateExplode[1]}/${dateExplode[0]} à $heure';
    return date;
  }

  void setIncrement() {
    if (_increment >= 0) {
      _increment++;
      _incrementIsActive = true;
      update();
    } else {
      _incrementIsActive = false;
      update();
    }
  }

  void setDecrement() {
    if (_increment < 1) {
      _incrementIsActive = false;
      update();
    } else {
      _increment--;
      _incrementIsActive = true;
      update();
    }
  }

  void resetInscrement() {
    _increment = 0;
    update();
  }

  String currency(String price) {
    return intl.NumberFormat.currency(
      locale: 'fr',
      symbol: 'FCFA',
      decimalDigits: 0,
    ).format(double.parse(price));
  }

  bool isMobileNumberValid(String phoneNumber) {
    String regexPattern =
        r'^((0[1-9])|(2[1-9])|(4[0-2])|(4[4-9])|(5[4-9])|(6[0-1])|6[5-7]|(77)|(75))[0-9]{8}$';
    var regExp = RegExp(regexPattern);

    if (phoneNumber.isEmpty) {
      return false;
    } else if (regExp.hasMatch(phoneNumber)) {
      return true;
    }
    return false;
  }
}
