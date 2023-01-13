// ignore_for_file: library_prefixes

import 'package:get/get.dart';
import 'package:innovimmobilier/services/models/properties/data_property_model.dart';
import 'package:innovimmobilier/services/models/properties/searchs/search_model.dart';
import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/repository/properties/searchs/search_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';

class SearchController extends GetxController implements GetxService {
  final SearchRepository searchRepository;

  SearchController({required this.searchRepository});

  List<DataPropertyModel>? _searchPropertyListModel = [];
  List<DataPropertyModel>? get searchPropertyListModel =>
      _searchPropertyListModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void clearSeachResults() {
    _searchPropertyListModel = [];
    update();
  }

  Future<ResponseModel> search(SearchModel searchModel,
      {bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }

    Response response = await searchRepository.search(searchModel);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body != null) {
        _searchPropertyListModel = List.from(response.body)
            .map<DataPropertyModel>(
                (property) => DataPropertyModel.fromMap(property))
            .toList();
        update();
        responseModel = ResponseModel(true, "Biens disponibles.");
      } else {
        responseModel = ResponseModel(false, "Aucun bien trouvé.");
      }
    } else {
      _searchPropertyListModel = [];
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
      update();
    }
    if (isLoaded) {
      _isLoading = false;
      update();
    }
    return responseModel;
  }
}
