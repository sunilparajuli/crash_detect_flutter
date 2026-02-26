import '../entities/crash_event.dart';
import '../repositories/crash_repository.dart';

class NotifyEmergencyContactsUseCase {
  final CrashRepository _crashRepository;

  NotifyEmergencyContactsUseCase({
    required CrashRepository crashRepository,
  }) : _crashRepository = crashRepository;

  Future<void> execute(CrashEvent crash) async {
    // 1. Send in-app notification (handled by presentation layer usually, or a NotificationService)
    // 2. Call emergency contacts (SMS/Phone) - Integration with platform channels or plugins
    // 3. Sync to backend
    await _crashRepository.saveCrash(crash);
    
    // 4. Optional: Auto-call logic depending on severity
  }
}
