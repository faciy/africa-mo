import 'package:get/get.dart';

import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/repository/notifications/notification_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepository notificationRepository;

  NotificationController({required this.notificationRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> findAll() async {
    _isLoading = true;
    update();
    Response response = await notificationRepository.findAll();
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      responseModel = ResponseModel(true, "Succès");

      update();
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> find(int notificationId) async {
    _isLoading = true;
    update();
    Response response = await notificationRepository.find(notificationId);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      responseModel = ResponseModel(true, "Succès");

      update();
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
