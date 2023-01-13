// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/models/body_model.dart';
import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/models/security/authentication/login_model.dart';
import 'package:innovimmobilier/services/repository/security/login_repository.dart';
import 'package:innovimmobilier/services/repository/security/user_repository.dart';

class LoginController extends GetxController implements GetxService {
  final LoginRepository loginRepository;
  final UserRepository userRepository;

  LoginController({
    required this.loginRepository,
    required this.userRepository,
  });

  bool _isLogingLoading = false;
  bool get isLogingLoading => _isLogingLoading;

  Future<ResponseModel> login(LoginModel loginModel) async {
    _isLogingLoading = true;
    update();
    Response response = await loginRepository.login(loginModel);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = BodyResponseModel.fromJson(response.body);

      if (bodyResponse.status == false) {
        responseModel =
            ResponseModel(bodyResponse.status!, bodyResponse.message);
      } else {
        if (bodyResponse.token != null) {
          loginRepository.saveUserToken(bodyResponse.token!).then((status) {
            if (status) {
              Get.find<UserController>().getUserInfos().then((data) async {
                if (data.isSuccess == false) {
                  responseModel = ResponseModel(false, bodyResponse.message);
                }

                await Get.find<PropertyController>().findAll(isLoaded: false);
              });
            }
          });
        }
      }

      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    } else {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    }
    _isLogingLoading = false;
    update();
    return responseModel;
  }
}
