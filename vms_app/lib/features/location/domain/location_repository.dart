abstract class LocationRepository {
  Future<void> updateLocationToFirebase(
    double latitude,
    double longitude,
    double routeId,
  );
}
