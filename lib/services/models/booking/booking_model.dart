class BookingModel {
  String? startSejour;
  String? endSejour;
  int? nbreSejour;
  int? propertyId;
  int? userId;
  String? propertyName;
  int? propertyPrice;
  dynamic total;

  BookingModel({
    this.startSejour,
    this.endSejour,
    this.nbreSejour,
    this.propertyName,
    this.propertyId,
    this.userId,
    this.propertyPrice,
    this.total,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      startSejour: map['startSejour'],
      endSejour: map['endSejour'],
      nbreSejour: map['nbreSejour'],
      propertyId: map['propertyId'],
      propertyName: map['propertyName'],
      userId: map['userId'],
      propertyPrice: map['propertyPrice'],
      total: map['total'],
    );
  }

  BookingModel.fromJson(Map<String, dynamic> json) {
    startSejour = json['startSejour'];
    endSejour = json['endSejour'];
    nbreSejour = json['nbreSejour'];
    propertyName = json['propertyName'];
    propertyId = json['propertyId'];
    userId = json['userId'];
    propertyPrice = json['propertyPrice'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startSejour'] = startSejour;
    data['endSejour'] = endSejour;
    data['nbreSejour'] = nbreSejour;
    data['propertyName'] = propertyName;
    data['propertyId'] = propertyId;
    data['userId'] = userId;
    data['propertyPrice'] = propertyPrice;
    data['total'] = total;
    return data;
  }
}
