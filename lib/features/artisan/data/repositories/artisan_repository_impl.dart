import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/artisan.dart';
import '../../domain/entities/artisan_detail.dart';
import '../../domain/entities/artisan_filter_params.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/repositories/artisan_repository.dart';
import '../datasources/artisan_local_datasource.dart';
import '../datasources/artisan_remote_datasource.dart';
import '../models/service_request_model.dart';

class ArtisanRepositoryImpl implements ArtisanRepository {
  final ArtisanRemoteDataSource remoteDataSource;
  final ArtisanLocalDataSource localDataSource;
  final Connectivity connectivity;

  ArtisanRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  Future<bool> get _isOnline async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<List<Artisan>> getArtisans(ArtisanFilterParams params) async {
    List<Artisan> artisans;

    if (await _isOnline) {
      final models = await remoteDataSource.getArtisans();
      await localDataSource.cacheArtisans(models);
      artisans = models;
    } else {
      final hasCached = await localDataSource.hasCachedArtisans();
      if (hasCached) {
        artisans = await localDataSource.getCachedArtisans();
      } else {
        throw Exception('No internet connection and no cached data available.');
      }
    }

    return _applyFilters(artisans, params);
  }

  List<Artisan> _applyFilters(
    List<Artisan> artisans,
    ArtisanFilterParams params,
  ) {
    return artisans.where((a) {
      final q = (params.query ?? '').toLowerCase().trim();

      final matchSearch =
          q.isEmpty ||
          a.name.toLowerCase().contains(q) ||
          a.trade.toLowerCase().contains(q);

      final matchTrade =
          params.trade == null ||
          params.trade == 'All' ||
          a.trade == params.trade;

      final matchLocation =
          params.location == null ||
          params.location == 'All' ||
          a.location.contains(params.location!);

      final matchRating =
          params.minRating == null || a.rating >= params.minRating!;

      final matchAvail = params.availableOnly != true || a.isAvailable;

      return matchSearch &&
          matchTrade &&
          matchLocation &&
          matchRating &&
          matchAvail;
    }).toList();
  }

  @override
  Future<ArtisanDetail> getArtisanDetail(String id) async {
    try {
      return await remoteDataSource.getArtisanDetail(id);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> submitServiceRequest(ServiceRequest request) async {
    final model = ServiceRequestModel.fromEntity(request);
    await remoteDataSource.submitServiceRequest(model);
  }

  @override
  Future<String?> getSavedTradePref() {
    return localDataSource.getSavedTradePref();
  }

  @override
  Future<void> saveTradePref(String trade) {
    return localDataSource.saveTradePref(trade);
  }
}
