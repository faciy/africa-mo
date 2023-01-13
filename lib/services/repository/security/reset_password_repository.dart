import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';
import 'package:innovimmobilier/services/models/security/authentication/reset_password/reset_password_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  ResetPasswordRepository(
      {required this.apiClient, required this.sharedPreferences});

  Future<Response> resetStep1(ResetPasswordModel resetPasswordModel) async {
    return await apiClient.postData(
      ApiUri.APP_RESET_PWD_STEP1_URI,
      {"email": resetPasswordModel.email},
    );
  }

  Future<Response> resetStep2(ResetPasswordModel resetPasswordModel) async {
    return await apiClient.postData(
      ApiUri.APP_RESET_PWD_STEP2_URI,
      {"email": resetPasswordModel.email, "code": resetPasswordModel.code},
    );
  }

  Future<Response> resetStep3(ResetPasswordModel resetPasswordModel) async {
    return await apiClient.postData(
      ApiUri.APP_RESET_PWD_STEP3_URI,
      {
        "email": resetPasswordModel.email,
        "password": resetPasswordModel.password_confirmation
      },
    );
  }
}
