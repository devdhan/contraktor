import '../entities/artisan.dart';
import '../entities/artisan_detail.dart';
import '../entities/artisan_filter_params.dart';
import '../entities/service_request.dart';

abstract class ArtisanRepository {
  /// Fetch all artisans, optionally filtered
  Future<List<Artisan>> getArtisans(ArtisanFilterParams params);

  /// Fetch a single artisan's full profile + portfolio
  Future<ArtisanDetail> getArtisanDetail(String id);

  /// Submit a service request
  Future<void> submitServiceRequest(ServiceRequest request);

  /// Get the last saved filter preference (trade)
  Future<String?> getSavedTradePref();

  /// Save the user's trade preference
  Future<void> saveTradePref(String trade);
}
