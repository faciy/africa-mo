// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/services/controllers/messages/message_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/favories/favoris_controller.dart';
import 'package:innovimmobilier/services/models/body_model.dart';
import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/models/users/user_model.dart';
import 'package:innovimmobilier/services/models/users/user_response_model.dart';
import 'package:innovimmobilier/services/repository/security/user_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';
import 'package:http/http.dart' as httpReq;

final navigatorKey = GlobalKey<NavigatorState>();

class UserController extends GetxController implements GetxService {
  final UserRepository userRepository;

  UserController({required this.userRepository});
  final navigatorKey = GlobalKey<NavigatorState>();

  UserModel? _userModel = UserModel();
  UserModel? get userModel => _userModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> getUserInfos({bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }
    Response response = await userRepository.getUserInfos();

    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final userResponse = UserResponseModel.fromJson(response.body);
      _userModel = userResponse.user;
      update();
      await Get.find<MessageController>().findAllHote();
      await Get.find<MessageController>().findAllClient();
      await Get.find<FavorisController>()
          .findAll(_userModel!.email!, _userModel!.id!);
      responseModel = ResponseModel(true, userResponse.message);
    } else {
      _userModel = null;
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> logout({bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }
    Response response = await userRepository.logout();
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      userRepository.clearShareData();
      responseModel = ResponseModel(true, "Vous êtes à présent deconnecté.");
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    if (isLoaded) {
      _isLoading = false;
      update();
    }
    return responseModel;
  }

  Future<ResponseModel> editPassword(String confirmPassword, int userId) async {
    _isLoading = true;
    update();
    Response response =
        await userRepository.editPassword(confirmPassword, userId);

    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 204) {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
      update();
    } else {
      responseModel = ResponseModel(false, response.statusText);
      update();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> editUserInfos(UserModel userModel, File? avatar) async {
    _isLoading = true;
    update();
    httpReq.Response response =
        await userRepository.editUserInfos(userModel, avatar);

    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse =
          BodyResponseModel.fromJson(jsonDecode(response.body));
      await getUserInfos();
      responseModel = ResponseModel(bodyResponse.status!,
          "Vos informations ont bien été modifiée avec succès.");
      update();
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
      update();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> delete(int id) async {
    _isLoading = true;
    update();
    Response response = await userRepository.delete(id);

    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      await logout();
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
      update();
    } else {
      final bodyResponse = BodyResponseModel.fromJson(response.body);
      responseModel = ResponseModel(bodyResponse.status!, bodyResponse.message);
      update();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  bool userLoggedIn() {
    return userRepository.userLoggedIn();
  }
}
