// ignore_for_file: library_prefixes

import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';
import 'package:innovimmobilier/services/models/properties/searchs/search_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepository {
  final ApiClient apiClient;
  late SharedPreferences sharedPreferences;

  SearchRepository({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> search(SearchModel searchModel) async {
    return await apiClient.postData(ApiUri.APP_SEARCH_URI, {
      'localisation': searchModel.localisation,
      'typebien': searchModel.typebien,
      'nb_piece': searchModel.nb_piece,
      'date_debut': searchModel.date_debut!.split('-').join('/'),
      'date_fin': searchModel.date_fin!.split('-').join('/'),
    });
  }
}
