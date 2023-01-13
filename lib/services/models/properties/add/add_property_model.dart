// ignore_for_file: non_constant_identifier_names

class AddPropertyModel {
  int? user_id;
  int? typebien_id;
  int? commune_id;
  int? nombre_piece;
  String? libelle;
  String? localisation;
  String? map;
  String? description;
  int? prix;
  bool? isAccept;
  dynamic images;

  AddPropertyModel({
    this.user_id,
    this.typebien_id,
    this.commune_id,
    this.nombre_piece,
    this.libelle,
    this.localisation,
    this.map,
    this.description,
    this.prix,
    this.isAccept,
    this.images,
  });

  factory AddPropertyModel.fromMap(Map<String, dynamic> map) {
    return AddPropertyModel(
      user_id: map['user_id']?.toInt(),
      typebien_id: map['typebien_id']?.toInt(),
      commune_id: map['commune_id']?.toInt(),
      nombre_piece: map['nombre_piece']?.toInt(),
      libelle: map['libelle'] ?? '',
      localisation: map['localisation'] ?? '',
      map: map['map'] ?? '',
      description: map['description'] ?? '',
      prix: map['prix']?.toInt(),
      isAccept: map['isAccept'],
      images: map['image'],
    );
  }

  AddPropertyModel.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    typebien_id = json['typebien_id'];
    commune_id = json['commune_id'];
    nombre_piece = json['nombre_piece'];
    libelle = json['libelle'] ?? '';
    localisation = json['localisation'] ?? '';
    map = json['map'] ?? '';
    description = json['description'] ?? '';
    prix = json['prix'];
    isAccept = json['isAccept'];
    images = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = user_id;
    data['typebien_id'] = typebien_id;
    data['commune_id'] = commune_id;
    data['nombre_piece'] = nombre_piece;
    data['libelle'] = libelle ?? '';
    data['localisation'] = localisation ?? '';
    data['map'] = map ?? '';
    data['description'] = description ?? '';
    data['prix'] = prix;
    data['isAccept'] = isAccept;
    data['image'] = images;
    return data;
  }
}
