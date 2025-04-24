import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vms_app/features/location/domain/location_repository.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository locationRepository;
  Timer? _timer;

  LocationCubit(this.locationRepository) : super(LocationInitial());

  Future<void> startSendingLocation() async {
    try {
      emit(LocationSending());

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationError("Location service is disabled."));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        emit(LocationError("Permission denied."));
        return;
      }

      _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
        try {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          await locationRepository.updateLocationToFirebase(
            position.latitude,
            position.longitude,
          );

          emit(LocationSent());
        } catch (e) {
          emit(LocationError("Failed to get or send location: $e"));
        }
      });
    } catch (e) {
      emit(LocationError("Error starting location updates: $e"));
    }
  }

  void stopSendingLocation() {
    _timer?.cancel();
    emit(LocationStopped());
  }
}
