abstract class LocationRepository {
  Future<void> updateLocationToFirebase(
    int routeId,
    double latitude,
    double longitude,
  );
}
