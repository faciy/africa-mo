import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';
import 'package:innovimmobilier/services/models/booking/booking_model.dart';

class BookingRepository {
  final ApiClient apiClient;

  BookingRepository({required this.apiClient});

  Future<Response> save(BookingModel bookingModel) async {
    var initalStartDate = bookingModel.startSejour;
    var splitStartDate = initalStartDate!.split(' ');
    var splitDateStart = splitStartDate[0].split('-');
    var newDateStart =
        "${splitDateStart[2]}-${splitDateStart[1]}-${splitDateStart[0]} ${splitStartDate[1]}";

    var initalEndDate = bookingModel.endSejour;
    var splitEndDate = initalEndDate!.split(' ');
    var splitDateEnd = splitEndDate[0].split('-');
    var newDateEnd =
        "${splitDateEnd[2]}-${splitDateEnd[1]}-${splitDateEnd[0]} ${splitEndDate[1]}";

    return await apiClient.postData(ApiUri.APP_BOOKING_URI, {
      'date_debut': newDateStart,
      'date_fin': newDateEnd,
      'number_nuit': bookingModel.nbreSejour,
      'bien_id': bookingModel.propertyId,
    });
  }

  Future<Response> payement(String paymentId) async {
    return await apiClient.postData(
        "${ApiUri.APP_PAYEMENT_URI}/$paymentId", {'transactionId': paymentId});
  }
}
