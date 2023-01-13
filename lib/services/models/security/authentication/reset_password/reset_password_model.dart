// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

ResetPasswordModel ResetPasswordFromJson(String str) =>
    ResetPasswordModel.fromJson(json.decode(str));

String ResetPasswordModelToJson(ResetPasswordModel data) =>
    json.encode(data.toJson());

class ResetPasswordModel {
  String? email;
  String? code;
  String? password;
  String? password_confirmation;

  ResetPasswordModel(
      {this.email, this.code, this.password, this.password_confirmation});

  ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    code = json['code'];
    password = json['password'];
    password_confirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['code'] = code;
    data['password'] = password;
    data['password_confirmation'] = password_confirmation;
    return data;
  }
}
