// ignore_for_file: non_constant_identifier_names

class UserModel {
  int? id;
  String? nom;
  String? prenoms;
  int? connected;
  String? tel;
  String? email;
  String? adresse;
  String? avatar;
  int? bien_id;
  String? libelle;
  String? image;

  UserModel(
      {this.id,
      this.nom,
      this.prenoms,
      this.connected,
      this.tel,
      this.email,
      this.adresse,
      this.avatar,
      this.bien_id,
      this.libelle,
      this.image});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt(),
      nom: map['nom'] ?? '',
      prenoms: map['prenoms'] ?? '',
      connected: map['connected'],
      tel: map['tel'] ?? '',
      email: map['email'] ?? '',
      adresse: map['adresse'] ?? '',
      avatar: map['avatar'] ?? '',
      bien_id: map['bien_id']?.toInt(),
      libelle: map['libelle'] ?? '',
      image: map['image'] ?? '',
    );
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenoms = json['prenoms'];
    connected = json['connected'];
    tel = json['tel'];
    email = json['email'];
    adresse = json['adresse'];
    avatar = json['avatar'];
    bien_id = json['bien_id'];
    libelle = json['libelle'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prenoms'] = prenoms;
    data['connected'] = connected;
    data['tel'] = tel;
    data['email'] = email;
    data['adresse'] = adresse;
    data['avatar'] = avatar;
    data['bien_id'] = bien_id;
    data['libelle'] = libelle;
    data['image'] = image;
    return data;
  }
}
