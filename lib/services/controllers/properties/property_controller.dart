// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:innovimmobilier/services/models/body_model.dart';
import 'package:innovimmobilier/services/models/properties/add/add_property_model.dart';
import 'package:innovimmobilier/services/models/properties/data_property_model.dart';
import 'package:innovimmobilier/services/models/properties/property_model.dart';
import 'package:innovimmobilier/services/models/properties/property_response.dart';
import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/repository/properties/property_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';
import 'package:http/http.dart' as httpReq;

class PropertyController extends GetxController implements GetxService {
  final PropertyRepository propertyRepository;

  PropertyController({required this.propertyRepository});

  List<DataPropertyModel>? _propertyListModel = [];
  List<DataPropertyModel>? get properties => _propertyListModel;

  List<DataPropertyModel>? _userPropertyListModel = [];
  List<DataPropertyModel>? get userProperties => _userPropertyListModel;

  List<PropertyResponse>? _propertySingle = [];
  List<PropertyResponse>? get propertySingle => _propertySingle;

  DataPropertyModel? _propertyModel = DataPropertyModel();
  DataPropertyModel? get propertyModel => _propertyModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> findAll({bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }

    Response response = await propertyRepository.findAll();
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      _propertyListModel = List.from(response.body)
          .map<DataPropertyModel>(
              (property) => DataPropertyModel.fromMap(property))
          .toList();
      responseModel = ResponseModel(true, "Succès");
      update();
    } else {
      _propertyListModel = [];
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
      update();
    }
    if (isLoaded) {
      _isLoading = false;
      update();
    }
    return responseModel;
  }

  Future<ResponseModel> getUserProperties({bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }
    Response response = await propertyRepository.getUserProperties();
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      var body = List.from(response.body)
          .map<DataPropertyModel>(
              (property) => DataPropertyModel.fromMap(property))
          .toList();
      _userPropertyListModel = body;
      responseModel = ResponseModel(true, "Succès");
      update();
    } else {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      _userPropertyListModel = [];
      if (bodyResponse.status == false) {
        responseModel =
            ResponseModel(bodyResponse.status!, bodyResponse.message);
      } else {
        responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
      }

      update();
    }
    if (isLoaded) {
      _isLoading = false;
      update();
    }
    return responseModel;
  }

  Future<ResponseModel> find(int id) async {
    _isLoading = true;
    update();

    Response response = await propertyRepository.find(id);

    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      _propertySingle = [];
      update();
      _propertySingle = List.from(response.body)
          .map<PropertyResponse>(
              (property) => PropertyResponse.fromMap(property))
          .toList();
      update();
      responseModel = ResponseModel(true, "success");
    } else {
      _propertySingle = [];
      update();
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
      update();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> updateData(
    PropertyModel propertyModel,
    File? image,
  ) async {
    _isLoading = true;
    update();

    httpReq.Response response =
        await propertyRepository.update(propertyModel, image);

    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse =
          DataPropertyModel.fromJson(jsonDecode(response.body));
      _propertyModel = bodyResponse;
      await find(propertyModel.id!);
      await getUserProperties();
      responseModel = ResponseModel(true, "Votre bien a bien été mise à jour.");
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> delete(int id) async {
    _isLoading = true;
    update();

    Response response = await propertyRepository.delete(id);

    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      await getUserProperties();
      responseModel = ResponseModel(true, "Votre bien a bien été supprimé.");
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> add(AddPropertyModel addPropertyModel) async {
    _isLoading = true;
    update();
    httpReq.Response response =
        await propertyRepository.addProperty(addPropertyModel);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse =
          BodyResponseModel.fromJson(jsonDecode(response.body));
      await getUserProperties();
      responseModel =
          ResponseModel(bodyResponse.status!, "Votre bien a bien été ajouté.");
    } else if (response.statusCode == 302) {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> addNewPicture(dynamic image, int propertyId) async {
    _isLoading = true;
    update();
    httpReq.Response response =
        await propertyRepository.addNewPicture(image, propertyId);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse =
          BodyResponseModel.fromJson(jsonDecode(response.body));
      await find(propertyId);
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> addPicture(dynamic image) async {
    _isLoading = true;
    update();
    httpReq.Response response = await propertyRepository.addPicture(image);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse =
          BodyResponseModel.fromJson(jsonDecode(response.body));
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> addPictures(AddPropertyModel addPropertyModel) async {
    _isLoading = true;
    update();
    httpReq.Response response =
        await propertyRepository.addPictures(addPropertyModel);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse =
          BodyResponseModel.fromJson(jsonDecode(response.body));
      await getUserProperties();
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> editPicture(dynamic image, int imageId) async {
    _isLoading = true;
    update();
    httpReq.Response response =
        await propertyRepository.editPicture(image, imageId);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse =
          BodyResponseModel.fromJson(jsonDecode(response.body));
      await getUserProperties();
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> deletePicture(int imageId) async {
    _isLoading = true;
    update();
    Response response = await propertyRepository.deletePicture(imageId);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      await getUserProperties();
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
