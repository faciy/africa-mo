import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';

class MessageRepository {
  final ApiClient apiClient;

  MessageRepository({required this.apiClient});

  Future<Response> findAllHote() async {
    return await apiClient.getData(ApiUri.APP_HOTE_MESSAGE_LIST_URI);
  }

  Future<Response> findAllClient() async {
    return await apiClient.getData(ApiUri.APP_CLIENT_MESSAGE_LIST_URI);
  }

  Future<Response> getConversasion(int receptId, int bienId) async {
    return await apiClient.postData(ApiUri.APP_CONVERSE_MESSAGE_URI, {
      'recept_id': receptId,
      'bien_id': bienId,
    });
  }

  Future<Response> postMessageHote(
      String message, int bienId, int receptId) async {
    return await apiClient.postData(ApiUri.APP_SEND_MESSAGE_URI, {
      'message': message,
      'bien_id': bienId,
      'recept_id': receptId,
    });
  }

  Future<Response> postMessageClient(String message, int receptId) async {
    return await apiClient.postData(ApiUri.APP_SEND_MESSAGE_URI, {
      'message': message,
      'recept_id': receptId,
    });
  }
}
