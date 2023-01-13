import 'package:get/get.dart';
import 'package:innovimmobilier/services/models/body_model.dart';
import 'package:innovimmobilier/services/models/decorations/decoration_model.dart';

import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/repository/decorations/decoration_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';

class DecorationController extends GetxController implements GetxService {
  final DecorationRepository decorationRepository;

  DecorationController({required this.decorationRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> sendDevis(DecorationModel decorationModel) async {
    _isLoading = true;
    update();
    Response response = await decorationRepository.sendDevis(decorationModel);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
      update();
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
