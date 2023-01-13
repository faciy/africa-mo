// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unnecessary_nullable_for_final_variable_declarations

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstants {
  static String? token = "";
  static String? TOKEN = "";

  AppConstants() {
    getToken();
    TOKEN = token;
  }

  void getToken() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    token = p.getString("token");
  }

  static const LatLng INIT_POSITION =
      LatLng(5.360011408924668, -4.009066768410434);
  static const String GOOGLE_API_KEY =
      'AIzaSyBUilLTn_wojm6T99TII67EZjJy_eqX8HE';
  static const String APP_NAME = 'AFRICA BOOKING';
  static const String APP_NAME_DEV = 'INNOV IMMOBILIER';
  static const String APP_TOKEN = 'token_innov';
  static const String APP_SHOW_HOME = 'showHome_innov';
  static const String APP_TOKEN_RESET = 'token_innov_reset';
  static const String APP_TOKEN_REGISTRATION = 'token_innov_registration';

  static const String APP_USER_ID = "user_id";

  static const int APP_PHONE_MAX_LENGTH = 10;
  static const int APP_PASSWORD_MAX_LENGTH = 8;
  static const int HOTE_ROLE = 4;
  static const int ADMIN_ROLE = 2;
  static const String APP_KKIAPAY_KEY_SANDBOX =
      '7f6e17305ac211edb8ac138e4aec3a64';
  static const String APP_KKIAPAY_KEY =
      '43e0012e5263fd85933b1d994b537d3abca97cac';
  static const bool APP_KKIAPAY_SANDBOX = false;
}
