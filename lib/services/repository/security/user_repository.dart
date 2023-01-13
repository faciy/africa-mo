// ignore_for_file: library_prefixes

import 'dart:io';

import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';
import 'package:innovimmobilier/services/models/users/user_model.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as httpReq;

class UserRepository {
  final ApiClient apiClient;
  late SharedPreferences sharedPreferences;

  UserRepository({required this.apiClient, required this.sharedPreferences});

  Future<Response> getUserInfos() async {
    var token = sharedPreferences.getString(AppConstants.APP_TOKEN);

    if (token != null) {
      apiClient.updateSessionHeader(token);
    }

    return await apiClient.getData(ApiUri.APP_USER_PROFIL);
  }

  Future<Response> logout() async {
    var token = sharedPreferences.getString(AppConstants.APP_TOKEN);
    if (token != null) {
      apiClient.updateSessionHeader(token);
    }
    return await apiClient.getData(ApiUri.APP_LOGOUT_URI);
  }

  Future<httpReq.Response> editUserInfos(
      UserModel userModel, File? avatar) async {
    return await apiClient.editUserDataWithFiles(
        ApiUri.APP_USER_EDIT_INFOS, userModel, avatar);
  }

  Future<Response> editPassword(String confirmPassword, int userId) async {
    return await apiClient.postData("${ApiUri.APP_USER_EDIT_PWD}/$userId", {
      "newpassword": confirmPassword,
    });
  }

  Future<Response> delete(int id) async {
    return await apiClient.deleteData(
      "${ApiUri.APP_USER_DELETE}/$id",
    );
  }

  Future<bool> clearShareData() async {
    await sharedPreferences.remove(AppConstants.APP_TOKEN);
    await sharedPreferences.remove(AppConstants.APP_USER_ID);
    apiClient.token = '';
    apiClient.updateHeader('');
    return true;
  }

  bool userLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.APP_TOKEN);
  }

  Future<String> getUserToken() async {
    return sharedPreferences.getString(AppConstants.APP_TOKEN) ?? "None";
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.APP_TOKEN, token);
  }
}
