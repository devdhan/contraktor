import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/analytics_remote_datasource.dart';
import '../../data/repositories/analytics_repository_impl.dart';
import '../../domain/entities/analytics_entities.dart';
import '../../domain/usecases/get_analytics.dart';

class AnalyticsState {
  final Analytics? analytics;
  final bool isLoading;
  final String? error;

  const AnalyticsState({this.analytics, this.isLoading = false, this.error});

  AnalyticsState copyWith({
    Analytics? analytics,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AnalyticsState(
      analytics: analytics ?? this.analytics,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

//Notifier
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final GetAnalytics _getAnalytics;

  AnalyticsNotifier({required GetAnalytics getAnalytics})
    : _getAnalytics = getAnalytics,
      super(const AnalyticsState()) {
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final analytics = await _getAnalytics();
      state = state.copyWith(analytics: analytics, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

//Provider
final analyticsRepositoryProvider = Provider((ref) {
  return AnalyticsRepositoryImpl(
    remoteDataSource: AnalyticsRemoteDataSourceImpl(),
  );
});

final analyticsNotifierProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
      final repo = ref.watch(analyticsRepositoryProvider);
      return AnalyticsNotifier(getAnalytics: GetAnalytics(repo));
    });
