import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';
import 'package:innovimmobilier/services/models/decorations/decoration_model.dart';

class DecorationRepository {
  final ApiClient apiClient;

  DecorationRepository({required this.apiClient});

  Future<Response> sendDevis(DecorationModel decorationModel) async {
    return await apiClient.postData(ApiUri.APP_SEND_DECORATION_URI, {
      'nom': decorationModel.nom,
      'prenoms': decorationModel.prenoms,
      'email': decorationModel.email,
      'numero': decorationModel.numero,
      'residence': decorationModel.residence,
    });
  }
}
