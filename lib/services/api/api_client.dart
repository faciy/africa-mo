// ignore_for_file: library_prefixes

import 'dart:async';

import 'package:innovimmobilier/services/models/properties/add/add_property_model.dart';
import 'package:innovimmobilier/services/models/properties/property_model.dart';
import 'package:innovimmobilier/services/models/users/user_model.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as httpReq;

class ApiClient extends GetConnect implements GetxService {
  String token = AppConstants.APP_TOKEN;
  String tokenReset = AppConstants.APP_TOKEN_RESET;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;

  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 60);
    _mainHeaders = {
      'Accept': 'application/json',
      'reset-token': tokenReset,
      'Authorization': 'Bearer $token',
    };
  }

  get http => null;

  void updateHeader(String token) {
    _mainHeaders = {
      'Accept': 'application/json',
      'reset-token': tokenReset,
      'Authorization': 'Bearer $token',
    };
  }

  void updateSessionHeader(String token) {
    _mainHeaders = {'Authorization': 'Bearer $token'};
  }

  void updateResetToken(String token) {
    _mainHeaders = {
      'reset-token': token,
    };
  }

  void emptyHeader() {
    _mainHeaders = {};
  }

  Future<Response> getData(
    String uri, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
  }) async {
    try {
      Response response = await get(
        uri,
        headers: headers ?? _mainHeaders,
        contentType: contentType,
        query: query,
      );
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<httpReq.Response> savePicture(
    String url,
    dynamic image,
  ) async {
    Uri uri = Uri.parse(appBaseUrl + url);
    httpReq.MultipartRequest request = httpReq.MultipartRequest('POST', uri);
    request.headers.addAll(_mainHeaders);
    request.files.add(
      await httpReq.MultipartFile.fromPath(
        'image',
        image.path,
      ),
    );

    var response = await request.send();
    var respBody = await httpReq.Response.fromStream(response);
    return respBody;
  }

  Future<httpReq.Response> savePictures(
    String url,
    AddPropertyModel addPropertyModel,
  ) async {
    Uri uri = Uri.parse(appBaseUrl + url);
    httpReq.MultipartRequest request = httpReq.MultipartRequest('POST', uri);
    request.headers.addAll(_mainHeaders);
    for (var i = 0; i < addPropertyModel.images.length; i++) {
      request.files.add(await httpReq.MultipartFile.fromPath(
          'image', addPropertyModel.images[i].path));
    }

    var response = await request.send();
    var respBody = await httpReq.Response.fromStream(response);
    return respBody;
  }

  Future<httpReq.Response> editPropertyDataWithFiles(
    String url,
    PropertyModel propertyModel,
    dynamic image,
  ) async {
    Uri uri = Uri.parse(appBaseUrl + url);
    httpReq.MultipartRequest request = httpReq.MultipartRequest('POST', uri);
    request.headers.addAll(_mainHeaders);
    request.fields["user_id"] = propertyModel.user_id.toString();
    request.fields["typebien_id"] = propertyModel.typebien_id.toString();
    request.fields["libelle"] = propertyModel.libelle.toString();
    request.fields["localisation"] = propertyModel.localisation.toString();
    request.fields["map"] = propertyModel.map.toString();
    request.fields["nombre_piece"] = propertyModel.nombre_piece.toString();
    request.fields["prix"] = propertyModel.prix.toString();
    request.fields["description"] = propertyModel.description.toString();
    request.fields["situation"] = propertyModel.situation.toString();
    request.fields["equipement"] = propertyModel.equipement.toString();
    request.fields["condition"] = propertyModel.condition.toString();
    request.fields["charge_incluse"] = propertyModel.charge_incluse.toString();

    if (image != null) {
      request.files.add(
        await httpReq.MultipartFile.fromPath(
          'image',
          image.path,
          filename: image.path,
        ),
      );
    }

    var response = await request.send();
    var respBody = await httpReq.Response.fromStream(response);
    return respBody;
  }

  Future<httpReq.Response> editUserDataWithFiles(
    String url,
    UserModel userModel,
    dynamic avatar,
  ) async {
    Uri uri = Uri.parse(appBaseUrl + url);
    httpReq.MultipartRequest request = httpReq.MultipartRequest('POST', uri);
    request.headers.addAll(_mainHeaders);
    request.fields["nom"] = userModel.nom.toString();
    request.fields["prenoms"] = userModel.prenoms.toString();
    request.fields["email"] = userModel.email.toString();
    request.fields["profession"] = userModel.profession.toString();
    request.fields["tel"] = userModel.tel.toString();
    if (avatar != null) {
      request.files.add(
        await httpReq.MultipartFile.fromPath(
          'avatar',
          avatar.path,
          filename: avatar.path,
        ),
      );
    }

    var response = await request.send();
    var respBody = await httpReq.Response.fromStream(response);
    return respBody;
  }

  Future<httpReq.Response> dataPost(
    String url,
    AddPropertyModel addPropertyModel,
  ) async {
    Uri uri = Uri.parse(appBaseUrl + url);
    httpReq.MultipartRequest request = httpReq.MultipartRequest('POST', uri);
    request.headers.addAll(_mainHeaders);
    request.fields["user_id"] = addPropertyModel.user_id.toString();
    request.fields["libelle"] = addPropertyModel.libelle.toString();
    request.fields["localisation"] = addPropertyModel.localisation.toString();
    request.fields["map"] = addPropertyModel.map.toString();
    request.fields["nombre_piece"] = addPropertyModel.nombre_piece.toString();
    request.fields["prix"] = addPropertyModel.prix.toString();
    request.fields["description"] = addPropertyModel.description.toString();
    request.fields["typebien_id"] = addPropertyModel.typebien_id.toString();
    request.fields["commune_id"] = addPropertyModel.commune_id.toString();

    var response = await request.send();
    var respBody = await httpReq.Response.fromStream(response);
    return respBody;
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postDataWithoutHeader(String uri, dynamic body) async {
    try {
      Response response = await post(uri, body);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postDataBearer(String uri, dynamic body) async {
    try {
      Response response = await post(
        uri,
        body,
        headers: _mainHeaders,
      );
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> putData(String uri, dynamic body) async {
    try {
      Response response = await put(uri, body, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> patchData(String uri, dynamic body) async {
    try {
      Response response = await patch(uri, body, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(String uri) async {
    try {
      Response response = await delete(uri, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
