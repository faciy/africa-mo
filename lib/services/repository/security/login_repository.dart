import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';
import 'package:innovimmobilier/services/models/security/authentication/login_model.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  LoginRepository({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(LoginModel loginModel) async {
    return await apiClient.postData(
      ApiUri.APP_LOGIN_URI,
      {"email": loginModel.email, "password": loginModel.password},
    );
  }

  Future<bool> saveUserId(int id) async {
    return await sharedPreferences.setInt(AppConstants.APP_USER_ID, id);
  }

  Future<bool> saveUserToken(String token) async {
    return await sharedPreferences.setString(AppConstants.APP_TOKEN, token);
  }
}
