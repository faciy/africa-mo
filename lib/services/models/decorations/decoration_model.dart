// ignore_for_file: non_constant_identifier_names

class DecorationModel {
  int? id;
  String? nom;
  String? prenoms;
  String? email;
  String? numero;
  String? residence;
  String? created_at;
  String? updated_at;

  DecorationModel({
    this.id,
    this.nom,
    this.prenoms,
    this.email,
    this.numero,
    this.residence,
    this.created_at,
    this.updated_at,
  });

  factory DecorationModel.fromMap(Map<String, dynamic> map) {
    return DecorationModel(
      id: map['id'],
      nom: map['nom'],
      prenoms: map['prenoms'],
      email: map['email'],
      numero: map['numero'],
      residence: map['residence'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
    );
  }

  DecorationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenoms = json['prenoms'];
    email = json['email'];
    numero = json['numero'];
    residence = json['residence'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prenoms'] = prenoms;
    data['email'] = email;
    data['numero'] = numero;
    data['residence'] = residence;
    data['created_at'] = created_at;
    data['updated_at'] = updated_at;
    return data;
  }
}
