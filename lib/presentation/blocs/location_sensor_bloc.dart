import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/sensor_repository.dart';

// Events
abstract class LocationSensorEvent {}
class CheckPermissionsEvent extends LocationSensorEvent {}

// States
abstract class LocationSensorState {}
class LocationSensorInitial extends LocationSensorState {}
class PermissionsGranted extends LocationSensorState {}
class PermissionsDenied extends LocationSensorState {
  final String reason;
  PermissionsDenied(this.reason);
}

// BLoC
class LocationSensorBloc extends Bloc<LocationSensorEvent, LocationSensorState> {
  // ignore: unused_field
  final LocationRepository _locationRepository;
  // ignore: unused_field
  final SensorRepository _sensorRepository;

  LocationSensorBloc({
    required LocationRepository locationRepository,
    required SensorRepository sensorRepository,
  })  : _locationRepository = locationRepository,
        _sensorRepository = sensorRepository,
        super(LocationSensorInitial()) {
    on<CheckPermissionsEvent>(_onCheckPermissions);
  }

  Future<void> _onCheckPermissions(
    CheckPermissionsEvent event,
    Emitter<LocationSensorState> emit,
  ) async {
    // Basic placeholder for permission checking logic using permission_handler
    // Typically you'd check Location, Activity Recognition (for sensors on Android), etc.
    try {
      // simulate check
      await Future.delayed(const Duration(milliseconds: 500));
      emit(PermissionsGranted());
    } catch (e) {
      emit(PermissionsDenied(e.toString()));
    }
  }
}
