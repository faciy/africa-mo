// ignore_for_file: non_constant_identifier_names

class PropertyModel {
  int? id;
  int? user_id;
  int? typebien_id;
  int? commune_id;
  int? nombre_piece;
  int? prix;
  int? status;
  int? valid;
  String? matricule;
  String? libelle;
  String? image;
  String? description;
  String? situation;
  String? equipement;
  String? condition;
  String? charge_incluse;
  String? localisation;
  String? created_at;
  String? updated_at;

  PropertyModel({
    this.id,
    this.user_id,
    this.typebien_id,
    this.commune_id = 1,
    this.nombre_piece,
    this.matricule,
    this.libelle,
    this.image,
    this.description,
    this.situation,
    this.equipement,
    this.condition,
    this.charge_incluse,
    this.prix,
    this.status,
    this.valid,
    this.localisation,
    this.created_at,
    this.updated_at,
  });

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
      id: map['id'],
      user_id: map['user_id'],
      typebien_id: map['typebien_id'],
      commune_id: map['commune_id'] ?? 1,
      nombre_piece: map['nombre_piece'] ?? 0,
      matricule: map['matricule'] ?? '',
      libelle: map['libelle'] ?? '',
      image: map['image'],
      description: map['description'] ?? '',
      situation: map['situation'] ?? '',
      equipement: map['equipement'] ?? '',
      condition: map['condition'] ?? '',
      charge_incluse: map['charge_incluse'] ?? '',
      prix: map['prix'],
      status: map['status'],
      valid: map['valid'],
      localisation: map['localisation'] ?? '',
      created_at: map['created_at'],
      updated_at: map['updated_at'],
    );
  }

  PropertyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user_id = json['user_id'];
    typebien_id = json['typebien_id'];
    commune_id = json['commune_id'] ?? 1;
    nombre_piece = json['nombre_piece'] ?? 0;
    matricule = json['matricule'] ?? '';
    libelle = json['libelle'] ?? '';
    image = json['image'];
    description = json['description'] ?? '';
    situation = json['situation'] ?? '';
    equipement = json['equipement'] ?? '';
    condition = json['condition'] ?? '';
    charge_incluse = json['charge_incluse'] ?? '';
    prix = json['prix'];
    status = json['status'];
    valid = json['valid'];
    localisation = json['localisation'] ?? '';
    created_at = json['created_at'];
    updated_at = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = user_id;
    data['typebien_id'] = typebien_id;
    data['commune_id'] = commune_id ?? 1;
    data['nombre_piece'] = nombre_piece ?? 0;
    data['matricule'] = matricule ?? '';
    data['libelle'] = libelle ?? '';
    data['image'] = image;
    data['description'] = description ?? '';
    data['situation'] = situation ?? '';
    data['equipement'] = equipement ?? '';
    data['condition'] = condition ?? '';
    data['charge_incluse'] = charge_incluse ?? '';
    data['prix'] = prix;
    data['status'] = status;
    data['valid'] = valid;
    data['localisation'] = localisation ?? '';
    data['created_at'] = created_at;
    data['updated_at'] = updated_at;
    return data;
  }
}
