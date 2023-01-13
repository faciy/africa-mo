// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

ResetPasswordModel resetPasswordModelFromJson(String str) =>
    ResetPasswordModel.fromJson(json.decode(str));

String resetPasswordModelToJson(ResetPasswordModel data) =>
    json.encode(data.toJson());

class ResetPasswordModel {
  String? phone;
  String? current_password;
  String? password;
  String? password_confirmation;

  ResetPasswordModel(
      {this.phone,
      this.current_password,
      this.password,
      this.password_confirmation});

  ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    current_password = json['current_password'];
    password = json['password'];
    password_confirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['current_password'] = current_password;
    data['password'] = password;
    data['password_confirmation'] = password_confirmation;
    return data;
  }
}
