import 'package:get/get.dart';
import 'package:innovimmobilier/services/models/body_model.dart';
import 'package:innovimmobilier/services/models/properties/data_property_model.dart';
import 'package:innovimmobilier/services/models/properties/type_model.dart';
import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/repository/properties/types/property_type_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';

class PropertyTypeController extends GetxController implements GetxService {
  final PropertyTypeRepository propertyTypeRepository;

  PropertyTypeController({required this.propertyTypeRepository});

  List<TypeModel>? _categoryListModel = [];
  List<TypeModel>? get categoryListModel => _categoryListModel;

  List<DataPropertyModel>? _propertiesListModel = [];
  List<DataPropertyModel>? get propertiesListModel => _propertiesListModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> findAll({bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }
    Response response = await propertyTypeRepository.findAll();
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      _categoryListModel = List.from(response.body)
          .map<TypeModel>((property) => TypeModel.fromMap(property))
          .toList();

      responseModel = ResponseModel(true, "Succès");
      update();
    } else {
      _categoryListModel = [];
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
      update();
    }
    if (isLoaded) {
      _isLoading = false;
      update();
    }
    return responseModel;
  }

  Future<ResponseModel> findProperties(int id, {bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }

    Response response = await propertyTypeRepository.findProperties(id);

    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      var body = List.from(response.body)
          .map<DataPropertyModel>(
              (property) => DataPropertyModel.fromMap(property))
          .toList();
      _propertiesListModel = body;
      responseModel = ResponseModel(true, "Biens trouvés");
    } else {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    }
    if (isLoaded) {
      _isLoading = false;
      update();
    }
    return responseModel;
  }
}
