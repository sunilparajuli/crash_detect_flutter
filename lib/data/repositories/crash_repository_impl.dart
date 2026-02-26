import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/crash_event.dart';
import '../../domain/repositories/crash_repository.dart';
import '../data_sources/crash_local_data_source.dart';
import '../data_sources/crash_remote_data_source.dart';

class CrashRepositoryImpl implements CrashRepository {
  final CrashLocalDataSource _localDataSource;
  final CrashRemoteDataSource _remoteDataSource;
  final Connectivity _connectivity;

  CrashRepositoryImpl({
    required CrashLocalDataSource localDataSource,
    required CrashRemoteDataSource remoteDataSource,
    required Connectivity connectivity,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _connectivity = connectivity;

  @override
  Future<void> saveCrash(CrashEvent crash) async {
    // Always save locally first
    await _localDataSource.cacheCrash(crash);

    // Sync to backend if online
    final connectivityResults = await _connectivity.checkConnectivity();
    if (connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.wifi)) {
      try {
        await _remoteDataSource.syncCrashReport(crash);
      } catch (e) {
        // Ignored, it's saved locally and will be synced later
      }
    }
  }

  @override
  Future<List<CrashEvent>> getCrashHistory() async {
    return await _localDataSource.getCrashHistory();
  }

  @override
  Future<void> syncWithBackend(CrashEvent crash) async {
    await _remoteDataSource.syncCrashReport(crash);
  }
}
