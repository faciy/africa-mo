import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyTypeRepository {
  final ApiClient apiClient;
  late SharedPreferences sharedPreferences;

  PropertyTypeRepository({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> findAll() async {
    return await apiClient.getData(ApiUri.APP_TYPE_LIST_URI);
  }

  Future<Response> findProperties(int id) async {
    return await apiClient
        .getData("${ApiUri.APP_BIENS_LIST_BY_TYPE_URI}/$id/$id");
  }
}
