abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationSending extends LocationState {}

class LocationSent extends LocationState {}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}

class LocationStopped extends LocationState {}
