import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vms_app/features/location/domain/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> updateLocationToFirebase(
    double latitude,
    double longitude,
  ) async {
    await _firestore.collection('locations').add({
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
