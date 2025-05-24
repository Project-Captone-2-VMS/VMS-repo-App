import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vms_app/features/location/domain/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> updateLocationToFirebase(
    double routeId,
    double latitude,
    double longitude,
  ) async {
    await _firestore.collection('$routeId').add({
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
