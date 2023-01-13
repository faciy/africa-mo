import 'package:get/get.dart';
import 'package:innovimmobilier/services/models/body_model.dart';
import 'package:innovimmobilier/services/models/booking/booking_model.dart';

import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/repository/booking/booking_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';

class BookingController extends GetxController implements GetxService {
  final BookingRepository bookingRepository;

  BookingController({required this.bookingRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> save(BookingModel bookingModel) async {
    _isLoading = true;
    update();
    Response response = await bookingRepository.save(bookingModel);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      responseModel = ResponseModel(bodyResponse.status, bodyResponse.message);
      update();
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> payement(String paymentId) async {
    _isLoading = true;
    update();
    Response response = await bookingRepository.payement(paymentId);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      responseModel =
          ResponseModel(true, "Infos paiement enrégistrés avec succès");
      update();
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
