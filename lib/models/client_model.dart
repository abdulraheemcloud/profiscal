class ClientModel {
  final String? id;

  final String businessName;
  final String clientName;
  final String mobile;
  final String email;
  final String gstNumber;
  final String address;
  final double monthlyFee;

  ClientModel({
    this.id,
    required this.businessName,
    required this.clientName,
    required this.mobile,
    required this.email,
    required this.gstNumber,
    required this.address,
    required this.monthlyFee,
  });

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'clientName': clientName,
      'mobile': mobile,
      'email': email,
      'gstNumber': gstNumber,
      'address': address,
      'monthlyFee': monthlyFee,
      'createdAt': DateTime.now(),
    };
  }

  factory ClientModel.fromFirestore(
    String id,
    Map<String, dynamic> map,
  ) {
    return ClientModel(
      id: id,
      businessName: map['businessName'] ?? '',
      clientName: map['clientName'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      gstNumber: map['gstNumber'] ?? '',
      address: map['address'] ?? '',
      monthlyFee: (map['monthlyFee'] ?? 0).toDouble(),
    );
  }
}