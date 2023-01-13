import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommuneRepository {
  final ApiClient apiClient;
  late SharedPreferences sharedPreferences;

  CommuneRepository({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> findAll() async {
    return await apiClient.getData(ApiUri.APP_COMMUNE_LIST_URI);
  }
}
