import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/invoice_model.dart';

class InvoiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add Invoice
  Future<void> addInvoice(InvoiceModel invoice) async {
    await _firestore
        .collection('invoices')
        .add(invoice.toMap());
  }

  /// Get All Invoices
  Stream<List<InvoiceModel>> getInvoices() {
    return _firestore
        .collection('invoices')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return InvoiceModel.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  /// Update Invoice
  Future<void> updateInvoice(InvoiceModel invoice) async {
    await _firestore
        .collection('invoices')
        .doc(invoice.id)
        .update(invoice.toMap());
  }

  /// Delete Invoice
  Future<void> deleteInvoice(String id) async {
    await _firestore
        .collection('invoices')
        .doc(id)
        .delete();
  }

  /// Get Single Invoice
  Future<InvoiceModel?> getInvoice(String id) async {
    final doc = await _firestore
        .collection('invoices')
        .doc(id)
        .get();

    if (!doc.exists) return null;

    return InvoiceModel.fromFirestore(
      doc.id,
      doc.data()!,
    );
  }
}