import 'package:get/get.dart';
import 'package:innovimmobilier/services/models/properties/communes/commune_model.dart';
import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/repository/properties/communes/commune_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';

class CommuneController extends GetxController implements GetxService {
  final CommuneRepository communeRepository;

  CommuneController({required this.communeRepository});

  List<CommuneModel>? _communeListModel = [];
  List<CommuneModel>? get communeListModel => _communeListModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> findAll({bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }
    Response response = await communeRepository.findAll();
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      _communeListModel = List.from(response.body)
          .map<CommuneModel>((property) => CommuneModel.fromMap(property))
          .toList();

      responseModel = ResponseModel(true, "Succès");
      update();
    } else {
      _communeListModel = [];
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
