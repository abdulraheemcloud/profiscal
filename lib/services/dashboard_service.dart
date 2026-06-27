import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Total Clients
  Future<int> getTotalClients() async {
    final snapshot = await _firestore.collection('clients').get();
    return snapshot.docs.length;
  }

  /// Total Invoices
  Future<int> getTotalInvoices() async {
    final snapshot = await _firestore.collection('invoices').get();
    return snapshot.docs.length;
  }

  /// Total Revenue
  Future<double> getTotalRevenue() async {
    final snapshot = await _firestore.collection('invoices').get();

    double total = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      total += (data['amount'] ?? 0).toDouble();
    }

    return total;
  }

  /// Paid Amount
  Future<double> getPaidAmount() async {
    final snapshot = await _firestore
        .collection('invoices')
        .where('status', isEqualTo: 'Paid')
        .get();

    double total = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      total += (data['amount'] ?? 0).toDouble();
    }

    return total;
  }

  /// Pending Amount
  Future<double> getPendingAmount() async {
    final snapshot = await _firestore
        .collection('invoices')
        .where('status', isEqualTo: 'Pending')
        .get();

    double total = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      total += (data['amount'] ?? 0).toDouble();
    }

    return total;
  }
}