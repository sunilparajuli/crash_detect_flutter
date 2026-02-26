import '../entities/context_metadata.dart';

abstract class LocationRepository {
  Stream<GpsCoordinates> getLocationStream();
  Future<ContextMetadata> fetchContextData(GpsCoordinates loc);
}
