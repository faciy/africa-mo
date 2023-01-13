// ignore_for_file: non_constant_identifier_names

class UserModel {
  int? id;
  String? matricule;
  String? adresse;
  String? nom;
  String? prenoms;
  String? profession;
  String? tel;
  String? avatar;
  String? cni;
  int? certify;
  int? status;
  int? valid;
  dynamic favorites;
  String? email;
  String? email_verified_at;
  int? role_id;

  UserModel(
      {this.id,
      this.matricule,
      this.adresse,
      this.nom,
      this.prenoms,
      this.profession,
      this.tel,
      this.avatar,
      this.cni,
      this.certify,
      this.status,
      this.valid,
      this.favorites,
      this.email,
      this.role_id});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt(),
      matricule: map['matricule'] ?? '',
      adresse: map['adresse'] ?? '',
      nom: map['nom'] ?? '',
      prenoms: map['prenoms'] ?? '',
      profession: map['profession'],
      tel: map['tel'] ?? '',
      avatar: map['avatar'] ?? '',
      cni: map['cni'] ?? '',
      certify: map['certify'] ?? '',
      status: map['status'],
      valid: map['valid']?.toInt(),
      favorites: map['favorites'] ?? '',
      email: map['email'],
      role_id: map['role_id'],
    );
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matricule = json['matricule'];
    adresse = json['adresse'];
    nom = json['nom'];
    prenoms = json['prenoms'];
    profession = json['profession'];
    tel = json['tel'];
    avatar = json['avatar'];
    cni = json['cni'];
    certify = json['certify'];
    status = json['status'];
    valid = json['valid'];
    favorites = json['favorites'];
    email = json['email'];
    role_id = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['matricule'] = matricule;
    data['adresse'] = adresse;
    data['nom'] = nom;
    data['prenoms'] = prenoms;
    data['profession'] = profession;
    data['tel'] = tel;
    data['avatar'] = avatar;
    data['cni'] = cni;
    data['certify'] = certify;
    data['status'] = status;
    data['valid'] = valid;
    data['favorites'] = favorites;
    data['email'] = email;
    data['role_id'] = role_id;
    return data;
  }
}
