import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';
import 'package:innovimmobilier/services/models/security/registration/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  RegisterRepository(
      {required this.apiClient, required this.sharedPreferences});

  Future<Response> getCode(RegisterModel registerModel) async {
    apiClient.emptyHeader();
    return await apiClient.postData(
      ApiUri.APP_REGISTER_GET_CODE_URI,
      {
        "nom": registerModel.nom,
        "prenoms": registerModel.prenoms,
        "email": registerModel.email,
      },
    );
  }

  Future<Response> codeVerify(RegisterModel registerModel) async {
    apiClient.emptyHeader();
    return await apiClient.postData(
      ApiUri.APP_REGISTER_CODE_VERIFY_URI,
      {"code": registerModel.code, "email": registerModel.email},
    );
  }

  Future<Response> codeResent(String email) async {
    apiClient.emptyHeader();
    return await apiClient
        .postData(ApiUri.APP_REGISTER_CODE_RESEND_URI, {"email": email});
  }

  Future<Response> createPassword(RegisterModel registerModel) async {
    apiClient.emptyHeader();
    return await apiClient.postData(
      ApiUri.APP_REGISTER_CREATE_PASSWORD_URI,
      {"email": registerModel.email, "password": registerModel.password},
    );
  }
}
