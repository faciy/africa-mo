import 'package:get/get.dart';
import 'package:innovimmobilier/services/models/booking/reservation/reservation_response.dart';

import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/repository/booking/reservation/reservation_repository.dart';

class ReservationController extends GetxController implements GetxService {
  final ReservationRepository reservationRepository;

  ReservationController({required this.reservationRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ReservationResponse>? _reservations = [];
  List<ReservationResponse>? get reservations => _reservations;

  Future<ResponseModel> findAll({bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }

    Response response = await reservationRepository.findAll();
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      _reservations = List.from(response.body)
          .map<ReservationResponse>(
              (message) => ReservationResponse.fromMap(message))
          .toList();
      responseModel = ResponseModel(true, "Succès");
      update();
    } else {
      final bodyResponse = ReservationResponse.fromJson(response.body);
      responseModel = ResponseModel(false, bodyResponse.message);
    }

    if (isLoaded) {
      _isLoading = false;
      update();
    }
    return responseModel;
  }
}
