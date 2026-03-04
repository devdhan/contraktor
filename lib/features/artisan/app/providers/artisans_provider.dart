import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../data/datasources/artisan_local_datasource.dart';
import '../../data/datasources/artisan_remote_datasource.dart';
import '../../data/repositories/artisan_repository_impl.dart';
import '../../domain/entities/artisan.dart';
import '../../domain/entities/artisan_detail.dart';
import '../../domain/entities/artisan_filter_params.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/repositories/artisan_repository.dart';
import '../../domain/usecases/get_artisans.dart';
import '../../domain/usecases/trade_pref_usecases.dart';

class ArtisansState {
  final List<Artisan> artisans;
  final bool isLoading;
  final String? error;
  final bool isOffline;
  final ArtisanFilterParams filters;

  const ArtisansState({
    this.artisans = const [],
    this.isLoading = false,
    this.error,
    this.isOffline = false,
    this.filters = const ArtisanFilterParams(),
  });

  ArtisansState copyWith({
    List<Artisan>? artisans,
    bool? isLoading,
    String? error,
    bool? isOffline,
    ArtisanFilterParams? filters,
    bool clearError = false,
  }) {
    return ArtisansState(
      artisans: artisans ?? this.artisans,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isOffline: isOffline ?? this.isOffline,
      filters: filters ?? this.filters,
    );
  }
}

//Provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

final artisanRepositoryProvider = FutureProvider((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return ArtisanRepositoryImpl(
    remoteDataSource: ArtisanRemoteDataSourceImpl(),
    localDataSource: ArtisanLocalDataSourceImpl(prefs: prefs),
    connectivity: Connectivity(),
  );
});

//Notifier
class ArtisansNotifier extends StateNotifier<ArtisansState> {
  final GetArtisans _getArtisans;
  final GetSavedTradePref _getSavedTradePref;
  final SaveTradePref _saveTradePref;

  ArtisansNotifier({
    required GetArtisans getArtisans,
    required GetSavedTradePref getSavedTradePref,
    required SaveTradePref saveTradePref,
  }) : _getArtisans = getArtisans,
       _getSavedTradePref = getSavedTradePref,
       _saveTradePref = saveTradePref,
       super(const ArtisansState()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final savedTrade = await _getSavedTradePref();
      if (savedTrade != null && savedTrade != 'All') {
        state = state.copyWith(
          filters: state.filters.copyWith(trade: savedTrade),
        );
      }
    } catch (_) {
      // Non-fatal — skip restoring preference
    }
    await fetchArtisans();
  }

  Future<void> fetchArtisans() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final artisans = await _getArtisans(state.filters);
      state = state.copyWith(
        artisans: artisans,
        isLoading: false,
        isOffline: false,
      );
    } on Exception catch (e) {
      final message = e.toString();
      final isOffline = message.contains('No internet');
      state = state.copyWith(
        isLoading: false,
        error: isOffline ? null : message,
        isOffline: isOffline,
      );
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(filters: state.filters.copyWith(query: query));
    fetchArtisans();
  }

  Future<void> applyFilters({
    String? trade,
    String? location,
    double? minRating,
    bool? availableOnly,
  }) async {
    if (trade != null) await _saveTradePref(trade);
    state = state.copyWith(
      filters: ArtisanFilterParams(
        query: state.filters.query,
        trade: trade,
        location: location,
        minRating: minRating,
        availableOnly: availableOnly,
      ),
    );
    await fetchArtisans();
  }

  void clearFilters() {
    state = state.copyWith(filters: const ArtisanFilterParams());
    fetchArtisans();
  }
}

final artisansNotifierProvider =
    StateNotifierProvider<ArtisansNotifier, ArtisansState>((ref) {
      final repoAsync = ref.watch(artisanRepositoryProvider);

      return repoAsync.when(
        data: (repo) => ArtisansNotifier(
          getArtisans: GetArtisans(repo),
          getSavedTradePref: GetSavedTradePref(repo),
          saveTradePref: SaveTradePref(repo),
        ),
        loading: () => ArtisansNotifier(
          getArtisans: GetArtisans(_SafeLoadingRepo()),
          getSavedTradePref: GetSavedTradePref(_SafeLoadingRepo()),
          saveTradePref: SaveTradePref(_SafeLoadingRepo()),
        ),
        error: (e, _) => throw e,
      );
    });

class _SafeLoadingRepo implements ArtisanRepository {
  @override
  Future<List<Artisan>> getArtisans(ArtisanFilterParams params) async => [];

  @override
  Future<ArtisanDetail> getArtisanDetail(String id) async =>
      throw Exception('Repository not ready');

  @override
  Future<void> submitServiceRequest(ServiceRequest request) async {}

  @override
  Future<String?> getSavedTradePref() async => null;

  @override
  Future<void> saveTradePref(String trade) async {}
}
