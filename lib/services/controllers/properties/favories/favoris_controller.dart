import 'package:get/get.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/models/properties/data_favoris_model.dart';
import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/repository/properties/favories/favoris_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';

class FavorisController extends GetxController implements GetxService {
  final FavorisRepository favorisRepository;

  FavorisController({required this.favorisRepository});

  List<DataFavorisModel>? _favorisListModel = [];
  List<DataFavorisModel>? get favorisList => _favorisListModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> findAll(String email, int id) async {
    _isLoading = true;
    update();
    Response response = await favorisRepository.findAll(email, id);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      _favorisListModel = /* List.from(response.body)
          .map<DataFavorisModel>(
              (property) => DataFavorisModel.fromMap(property))
          .toList() */
          [];
      responseModel = ResponseModel(true, "Succès");
      update();
    } else {
      _favorisListModel = [];
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
      update();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> postFavoris(String email, int propertyId) async {
    _isLoading = true;
    update();
    Response response = await favorisRepository.postFavoris(email, propertyId);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      await Get.find<PropertyController>().find(propertyId);
      await Get.find<UserController>().getUserInfos();
      responseModel = ResponseModel(true, "Succès");
      update();
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
      update();
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
