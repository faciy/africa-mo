import 'package:get/get.dart';
import 'package:innovimmobilier/services/models/properties/taxes/taxe_model.dart';
import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/repository/properties/taxes/taxe_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';

class TaxeController extends GetxController implements GetxService {
  final TaxeRepository taxeRepository;

  TaxeController({required this.taxeRepository});

  List<TaxeModel>? _taxeListModel = [];
  List<TaxeModel>? get taxeListModel => _taxeListModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> findAll({bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }
    Response response = await taxeRepository.findAll();
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      _taxeListModel = List.from(response.body)
          .map<TaxeModel>((property) => TaxeModel.fromMap(property))
          .toList();

      responseModel = ResponseModel(true, "Succès");
      update();
    } else {
      _taxeListModel = [];
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
