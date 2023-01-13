import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';

class ReservationRepository {
  final ApiClient apiClient;

  ReservationRepository({required this.apiClient});

  Future<Response> findAll() async {
    return await apiClient.getData(ApiUri.APP_RESERVATION_URI);
  }
}
