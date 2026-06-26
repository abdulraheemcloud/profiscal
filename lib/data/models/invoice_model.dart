class InvoiceModel {
  final String? id;

  final String invoiceNumber;
  final String clientId;
  final String clientName;

  final DateTime invoiceDate;
  final DateTime dueDate;

  final double amount;
  final double gst;

  final String status; // Paid / Pending

  final String notes;

  InvoiceModel({
    this.id,
    required this.invoiceNumber,
    required this.clientId,
    required this.clientName,
    required this.invoiceDate,
    required this.dueDate,
    required this.amount,
    required this.gst,
    required this.status,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceNumber': invoiceNumber,
      'clientId': clientId,
      'clientName': clientName,
      'invoiceDate': invoiceDate,
      'dueDate': dueDate,
      'amount': amount,
      'gst': gst,
      'status': status,
      'notes': notes,
      'createdAt': DateTime.now(),
    };
  }

  factory InvoiceModel.fromFirestore(
    String id,
    Map<String, dynamic> map,
  ) {
    return InvoiceModel(
      id: id,
      invoiceNumber: map['invoiceNumber'] ?? '',
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      invoiceDate: map['invoiceDate'].toDate(),
      dueDate: map['dueDate'].toDate(),
      amount: (map['amount'] ?? 0).toDouble(),
      gst: (map['gst'] ?? 0).toDouble(),
      status: map['status'] ?? 'Pending',
      notes: map['notes'] ?? '',
    );
  }

  double get gstAmount => amount * gst / 100;

  double get totalAmount => amount + gstAmount;
}