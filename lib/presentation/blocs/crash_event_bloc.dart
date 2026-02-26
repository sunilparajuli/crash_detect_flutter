import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/detect_crash_use_case.dart';
import '../../domain/use_cases/generate_crash_report_use_case.dart';
import '../../domain/use_cases/notify_emergency_contacts_use_case.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/entities/crash_event.dart';

// Events
abstract class CrashEventBlocEvent {}

class StartCrashMonitoringEvent extends CrashEventBlocEvent {}
class StopCrashMonitoringEvent extends CrashEventBlocEvent {}

// States
abstract class CrashEventBlocState {}

class CrashMonitoringInitial extends CrashEventBlocState {}
class CrashMonitoringInProgress extends CrashEventBlocState {}
class CrashDetected extends CrashEventBlocState {
  final CrashEvent crash;
  final String report;
  CrashDetected({required this.crash, required this.report});
}
class CrashMonitoringError extends CrashEventBlocState {
  final String error;
  CrashMonitoringError({required this.error});
}

// BLoC
class CrashEventBloc extends Bloc<CrashEventBlocEvent, CrashEventBlocState> {
  final DetectCrashUseCase _detectCrashUseCase;
  final GenerateCrashReportUseCase _generateCrashReportUseCase;
  final NotifyEmergencyContactsUseCase _notifyEmergencyUseCase;
  final SensorRepository _sensorRepository;
  final LocationRepository _locationRepository;

  StreamSubscription? _crashSubscription;

  CrashEventBloc({
    required DetectCrashUseCase detectCrashUseCase,
    required GenerateCrashReportUseCase generateCrashReportUseCase,
    required NotifyEmergencyContactsUseCase notifyEmergencyContactsUseCase,
    required SensorRepository sensorRepository,
    required LocationRepository locationRepository,
  })  : _detectCrashUseCase = detectCrashUseCase,
        _generateCrashReportUseCase = generateCrashReportUseCase,
        _notifyEmergencyUseCase = notifyEmergencyContactsUseCase,
        _sensorRepository = sensorRepository,
        _locationRepository = locationRepository,
        super(CrashMonitoringInitial()) {
    on<StartCrashMonitoringEvent>(_onStartMonitoring);
    on<StopCrashMonitoringEvent>(_onStopMonitoring);
  }

  Future<void> _onStartMonitoring(
    StartCrashMonitoringEvent event,
    Emitter<CrashEventBlocState> emit,
  ) async {
    emit(CrashMonitoringInProgress());

    try {
      await _sensorRepository.startMonitoring();
      final sensorStream = _sensorRepository.getSensorStream();
      final locationStream = _locationRepository.getLocationStream();

      // Assuming _detectCrashUseCase.execute returns a Future that resolves
      // when a crash is detected from the streams.
      final crash = await _detectCrashUseCase.execute(
        sensorStream: sensorStream,
        locationStream: locationStream,
      );

      if (crash != null) {
        final report = await _generateCrashReportUseCase.execute(crash);
        await _notifyEmergencyUseCase.execute(crash);
        emit(CrashDetected(crash: crash, report: report));
      }
    } catch (e) {
      emit(CrashMonitoringError(error: e.toString()));
    }
  }

  Future<void> _onStopMonitoring(
    StopCrashMonitoringEvent event,
    Emitter<CrashEventBlocState> emit,
  ) async {
    await _sensorRepository.stopMonitoring();
    emit(CrashMonitoringInitial());
  }

  @override
  Future<void> close() {
    _sensorRepository.stopMonitoring();
    _crashSubscription?.cancel();
    return super.close();
  }
}
