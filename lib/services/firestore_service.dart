import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addReport({
    required String description,
    required String imageUrl,
    required double latitude,
    required double longitude,
    required String userId,
  }) async {
    try {
      await _db.collection('reports').add({
        'description': description,
        'imageUrl': imageUrl,
        'location': GeoPoint(latitude, longitude),
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
      });
    } catch (e) {
      print('Error adding report: $e');
      rethrow;
    }
  }
}
