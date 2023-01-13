// ignore_for_file: non_constant_identifier_names

class RegisterModel {
  String? nom;
  String? prenoms;
  String? email;
  String? password;
  String? password_confirmation;
  String? code;

  RegisterModel({
    this.nom,
    this.prenoms,
    this.email,
    this.password,
    this.password_confirmation,
    this.code,
  });

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      nom: map['nom'],
      prenoms: map['prenoms'],
      email: map['email'],
      password: map['password'],
      password_confirmation: map['password_confirmation'],
      code: map['code'],
    );
  }

  RegisterModel.fromJson(Map<String, dynamic> json) {
    nom = json['nom'];
    prenoms = json['prenoms'];
    email = json['email'];
    password = json['password'];
    password_confirmation = json['password_confirmation'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nom'] = nom;
    data['prenoms'] = prenoms;
    data['email'] = email;
    data['password'] = password;
    data['password_confirmation'] = password_confirmation;
    data['code'] = code;
    return data;
  }
}
