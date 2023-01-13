class TypeModel {
  int? id;
  String? libelle;
  String? image;
  dynamic status;
  dynamic valid;

  TypeModel({
    this.id,
    this.libelle,
    this.image,
    this.status,
    this.valid,
  });

  static List<TypeModel> types = [];

  factory TypeModel.fromMap(Map<String, dynamic> map) {
    return TypeModel(
      id: map['id']?.toInt(),
      libelle: map['libelle'],
      image: map['image'],
      status: map['status'],
      valid: map['valid'],
    );
  }

  TypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    image = json['image'];
    status = json['status'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['image'] = image;
    data['status'] = status;
    data['valid'] = valid;
    return data;
  }
}
