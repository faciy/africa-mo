class TaxeModel {
  int? id;
  String? libelle;
  String? description;
  double? valeur;
  dynamic status;
  dynamic valid;

  TaxeModel({
    this.id,
    this.libelle,
    this.description,
    this.valeur,
    this.status,
    this.valid,
  });

  static List<TaxeModel> taxes = [];

  factory TaxeModel.fromMap(Map<String, dynamic> map) {
    return TaxeModel(
      id: map['id']?.toInt(),
      libelle: map['libelle'],
      description: map['description'],
      valeur: map['valeur'],
      status: map['status'],
      valid: map['valid'],
    );
  }

  TaxeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    description = json['description'];
    valeur = json['valeur'];
    status = json['status'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['description'] = description;
    data['valeur'] = valeur;
    data['status'] = status;
    data['valid'] = valid;
    return data;
  }
}
