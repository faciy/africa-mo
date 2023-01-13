import 'package:get/get.dart';
import 'package:innovimmobilier/services/models/body_model.dart';
import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/models/security/registration/register_model.dart';
import 'package:innovimmobilier/services/repository/security/login_repository.dart';
import 'package:innovimmobilier/services/repository/security/register_repository.dart';
import 'package:innovimmobilier/services/repository/security/user_repository.dart';

class RegisterController extends GetxController implements GetxService {
  final RegisterRepository registerRepository;
  final UserRepository userRepository;
  final LoginRepository loginRepository;

  RegisterController({
    required this.registerRepository,
    required this.userRepository,
    required this.loginRepository,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late RegisterModel _registerModel;
  RegisterModel get registerModel => _registerModel;

  @override
  void onClose() {}

  Future<ResponseModel> getCodeApi(RegisterModel registerModel) async {
    _isLoading = true;
    update();

    Response response = await registerRepository.getCode(registerModel);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> codeVerifyApi(RegisterModel registerModel) async {
    _isLoading = true;
    update();

    Response response = await registerRepository.codeVerify(registerModel);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    } else {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> codeResentApi(String email) async {
    _isLoading = true;
    update();

    Response response = await registerRepository.codeResent(email);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = BodyResponseModel.fromJson(response.body);

      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> registerApi(RegisterModel registerModel) async {
    _isLoading = true;
    update();

    Response response = await registerRepository.createPassword(registerModel);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = BodyResponseModel.fromJson(response.body);

      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    } else {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
