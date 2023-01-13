import 'package:innovimmobilier/services/models/users/user_model.dart';

class UserResponseModel {
  bool? status;
  String? message;
  UserModel? user;

  UserResponseModel({
    this.status,
    this.message,
    this.user,
  });

  factory UserResponseModel.fromMap(Map<String, dynamic> map) {
    return UserResponseModel(
      status: map['status'],
      message: map['message'],
      user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
    );
  }

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
