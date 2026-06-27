class BusinessModel {
  final String? id;

  final String businessName;
  final String gstNumber;
  final String phone;
  final String email;
  final String address;

  BusinessModel({
    this.id,
    required this.businessName,
    required this.gstNumber,
    required this.phone,
    required this.email,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'gstNumber': gstNumber,
      'phone': phone,
      'email': email,
      'address': address,
      'createdAt': DateTime.now(),
    };
  }

  factory BusinessModel.fromFirestore(
    String id,
    Map<String, dynamic> map,
  ) {
    return BusinessModel(
      id: id,
      businessName: map['businessName'] ?? '',
      gstNumber: map['gstNumber'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
    );
  }

  BusinessModel copyWith({
    String? id,
    String? businessName,
    String? gstNumber,
    String? phone,
    String? email,
    String? address,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      gstNumber: gstNumber ?? this.gstNumber,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }
}