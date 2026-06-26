import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/client_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add Client
  Future<void> addClient(ClientModel client) async {
    await _firestore.collection('clients').add(client.toMap());
  }

  /// Get All Clients
  Stream<List<ClientModel>> getClients() {
    return _firestore
        .collection('clients')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ClientModel.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  /// Update Client
  Future<void> updateClient(ClientModel client) async {
    await _firestore
        .collection('clients')
        .doc(client.id)
        .update(client.toMap());
  }

  /// Delete Client
  Future<void> deleteClient(String id) async {
    await _firestore
        .collection('clients')
        .doc(id)
        .delete();
  }
}