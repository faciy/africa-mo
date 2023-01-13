import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';

class NotificationRepository {
  final ApiClient apiClient;

  NotificationRepository({required this.apiClient});

  Future<Response> findAll() async {
    return await apiClient.getData(ApiUri.APP_NOTIFICATION_LIST_URI);
  }

  Future<Response> find(int notificationId) async {
    return await apiClient
        .getData("${ApiUri.APP_FIND_NOTIFICATION_URI}/$notificationId");
  }
}
