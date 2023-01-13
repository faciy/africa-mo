// ignore_for_file: library_prefixes

import 'dart:io';

import 'package:get/get.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';
import 'package:innovimmobilier/services/models/properties/add/add_property_model.dart';
import 'package:innovimmobilier/services/models/properties/property_model.dart';
import 'package:innovimmobilier/services/models/properties/searchs/search_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as httpReq;

class PropertyRepository {
  final ApiClient apiClient;
  late SharedPreferences sharedPreferences;

  PropertyRepository({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> findAll() async {
    return await apiClient.getData(ApiUri.APP_PROPERTIES_URI);
  }

  Future<Response> search(SearchModel searchModel) async {
    return await apiClient.postData(ApiUri.APP_SEARCH_URI, {
      'localisation': searchModel.localisation,
      'typebien': searchModel.typebien,
      'nb_piece': searchModel.nb_piece,
      'date_debut': searchModel.date_debut!.split('-').join('/'),
      'date_fin': searchModel.date_fin!.split('-').join('/'),
    });
  }

  Future<Response> find(int id) async {
    return await apiClient.getData("${ApiUri.APP_PROPERTIES_URI}/$id");
  }

  Future<Response> getUserProperties() async {
    return await apiClient.getData(ApiUri.APP_USER_PROPETIES_LIST_URI);
  }

  Future<httpReq.Response> update(
      PropertyModel propertyModel, File? image) async {
    return await apiClient.editPropertyDataWithFiles(
      "${ApiUri.APP_PROPERTY_EDIT_URI}/${propertyModel.id}",
      propertyModel,
      image,
    );
  }

  Future<Response> editPropertyInfos(
      PropertyModel propertyModel, File? image) async {
    return await apiClient.patchData(
      "${ApiUri.APP_PROPERTIES_URI}/${propertyModel.id}",
      {
        'user_id': propertyModel.user_id,
        'typebien_id': propertyModel.typebien_id,
        'commune_id': propertyModel.commune_id,
        'libelle': propertyModel.libelle,
        'localisation': propertyModel.localisation,
        'map': propertyModel.map,
        'nombre_piece': propertyModel.nombre_piece,
        'prix': propertyModel.prix,
        'description': propertyModel.description,
        'situation': propertyModel.situation,
        'equipement': propertyModel.equipement,
        'condition': propertyModel.condition,
        'charge_incluse': propertyModel.charge_incluse,
      },
    );
  }

  Future<httpReq.Response> addProperty(
      AddPropertyModel addPropertyModel) async {
    return await apiClient.dataPost(
        ApiUri.APP_ADD_PROPERTY_URI, addPropertyModel);
  }

  Future<httpReq.Response> addPicture(dynamic image) async {
    return await apiClient.savePicture(ApiUri.APP_PICTURES_ADD_URI, image);
  }

  Future<httpReq.Response> addNewPicture(dynamic image, int propertyId) async {
    return await apiClient.savePicture(
        '${ApiUri.APP_PICTURES_ADD_URI}/$propertyId', image);
  }

  Future<httpReq.Response> addPictures(
      AddPropertyModel addPropertyModel) async {
    return await apiClient.savePictures(
        ApiUri.APP_PICTURES_ADD_URI, addPropertyModel);
  }

  Future<httpReq.Response> editPicture(dynamic image, int imageId) async {
    return await apiClient.savePicture(
        '${ApiUri.APP_PICTURES_EDIT_URI}/$imageId', image);
  }

  Future<Response> delete(int id) async {
    return await apiClient.deleteData("${ApiUri.APP_PROPERTIES_URI}/$id");
  }

  Future<Response> deletePicture(int imageId) async {
    return await apiClient
        .deleteData("${ApiUri.APP_PICTURES_DELETE_URI}/$imageId");
  }
}
