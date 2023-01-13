// ignore_for_file: non_constant_identifier_names

class BodyResponseModel<T> {
  dynamic status;
  String? type;
  String? token;
  int? id;
  String? register_token;
  String? reset_token;
  String? message;

  BodyResponseModel({
    this.status,
    this.type,
    this.token,
    this.id,
    this.register_token,
    this.reset_token,
    this.message,
  });

  factory BodyResponseModel.fromJson(Map<String, dynamic> json) {
    return BodyResponseModel<T>(
      status: json['status'],
      type: json['type'],
      token: json['token'],
      id: json['id'],
      register_token: json['register_token'],
      reset_token: json['reset_token'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'type': type,
      'token': token,
      'id': id,
      'register_token': register_token,
      'message': message,
    };
  }
}
