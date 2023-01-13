class CommuneModel {
  int? id;
  String? libelle;
  dynamic status;
  dynamic valid;

  CommuneModel({
    this.id,
    this.libelle,
    this.status,
    this.valid,
  });

  static List<CommuneModel> communes = [];

  factory CommuneModel.fromMap(Map<String, dynamic> map) {
    return CommuneModel(
      id: map['id']?.toInt(),
      libelle: map['libelle'],
      status: map['status'],
      valid: map['valid'],
    );
  }

  CommuneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    status = json['status'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['status'] = status;
    data['valid'] = valid;
    return data;
  }
}
