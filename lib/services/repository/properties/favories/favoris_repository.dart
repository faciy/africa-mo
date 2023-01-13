import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';

class FavorisRepository {
  final ApiClient apiClient;

  FavorisRepository({required this.apiClient});

  Future<Response> findAll(String email, int id) async {
    return await apiClient.getData("${ApiUri.APP_FAVORIS_LIKE_URI}/$email/$id");
  }

  Future<Response> postFavoris(String email, int propertyId) async {
    return await apiClient
        .getData("${ApiUri.APP_FAVORIS_LIKE_URI}/$email/$propertyId");
  }
}
