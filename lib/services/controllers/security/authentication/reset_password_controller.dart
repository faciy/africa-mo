// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'package:innovimmobilier/services/models/body_model.dart';
import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/models/security/authentication/reset_password/reset_password_model.dart';
import 'package:innovimmobilier/services/repository/security/reset_password_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';

class ResetPasswordController extends GetxController implements GetxService {
  final ResetPasswordRepository resetPasswordRepository;

  ResetPasswordController({
    required this.resetPasswordRepository,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> resetPassword(
    ResetPasswordModel resetModel,
    int step,
  ) async {
    _isLoading = true;
    update();

    Response response = const Response();
    if (step == 1) {
      response = await resetPasswordRepository.resetStep1(resetModel);
    } else if (step == 2) {
      response = await resetPasswordRepository.resetStep2(resetModel);
    } else {
      response = await resetPasswordRepository.resetStep3(resetModel);
    }

    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
