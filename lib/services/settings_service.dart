import 'package:cloud_firestore/cloud_firestore.dart';

import '../features/settings/business_model.dart';

class SettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _collection = 'settings';
  static const String _document = 'business';

  /// Save Business Details
  Future<void> saveBusiness(BusinessModel business) async {
    await _firestore
        .collection(_collection)
        .doc(_document)
        .set(
          business.toMap(),
          SetOptions(merge: true),
        );
  }

  /// Get Business Details
  Future<BusinessModel?> getBusiness() async {
    final doc = await _firestore
        .collection(_collection)
        .doc(_document)
        .get();

    if (!doc.exists) {
      return null;
    }

    return BusinessModel.fromFirestore(
      doc.id,
      doc.data()!,
    );
  }

  /// Update Business Details
  Future<void> updateBusiness(BusinessModel business) async {
    await _firestore
        .collection(_collection)
        .doc(_document)
        .update(
          business.toMap(),
        );
  }

  /// Check Business Settings Exists
  Future<bool> hasBusinessSettings() async {
    final doc = await _firestore
        .collection(_collection)
        .doc(_document)
        .get();

    return doc.exists;
  }

  /// Delete Business Settings
  Future<void> deleteBusiness() async {
    await _firestore
        .collection(_collection)
        .doc(_document)
        .delete();
  }
}