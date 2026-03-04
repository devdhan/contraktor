import 'package:contraktor/features/artisan/data/repositories/artisan_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/artisan.dart';
import '../../domain/entities/artisan_detail.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/usecases/get_artisan_detail.dart';
import '../../domain/usecases/submit_service_request.dart';
import 'artisans_provider.dart';

class ProfileState {
  final Artisan? artisan;
  final ArtisanDetail? detail;
  final bool isLoading;
  final String? error;
  final bool isSubmitting;
  final bool submitSuccess;
  final String? submitError;

  const ProfileState({
    this.artisan,
    this.detail,
    this.isLoading = false,
    this.error,
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.submitError,
  });

  ProfileState copyWith({
    Artisan? artisan,
    ArtisanDetail? detail,
    bool? isLoading,
    String? error,
    bool? isSubmitting,
    bool? submitSuccess,
    String? submitError,
    bool clearError = false,
    bool clearSubmitError = false,
  }) {
    return ProfileState(
      artisan: artisan ?? this.artisan,
      detail: detail ?? this.detail,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      submitError: clearSubmitError ? null : submitError ?? this.submitError,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetArtisanDetail _getArtisanDetail;
  final SubmitServiceRequest _submitServiceRequest;

  ProfileNotifier({
    required GetArtisanDetail getArtisanDetail,
    required SubmitServiceRequest submitServiceRequest,
  }) : _getArtisanDetail = getArtisanDetail,
       _submitServiceRequest = submitServiceRequest,
       super(const ProfileState());

  Future<void> loadProfile(String artisanId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final detail = await _getArtisanDetail(artisanId);
      state = state.copyWith(detail: detail, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitRequest(ServiceRequest request) async {
    state = state.copyWith(
      isSubmitting: true,
      clearSubmitError: true,
      submitSuccess: false,
    );
    try {
      await _submitServiceRequest(request);
      state = state.copyWith(isSubmitting: false, submitSuccess: true);
    } on Exception catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.toString());
    }
  }

  void resetSubmitState() {
    state = state.copyWith(submitSuccess: false, clearSubmitError: true);
  }
}

final profileNotifierProvider =
    StateNotifierProvider.family<ProfileNotifier, ProfileState, String>((
      ref,
      artisanId,
    ) {
      final repoAsync = ref.watch(artisanRepositoryProvider);

      final notifier = repoAsync.when(
        data: (repo) => ProfileNotifier(
          getArtisanDetail: GetArtisanDetail(repo),
          submitServiceRequest: SubmitServiceRequest(repo),
        ),
        loading: () => ProfileNotifier(
          getArtisanDetail: GetArtisanDetail(_EmptyRepo()),
          submitServiceRequest: SubmitServiceRequest(_EmptyRepo()),
        ),
        error: (e, _) => throw e,
      );

      // Auto-load on first access
      notifier.loadProfile(artisanId);
      return notifier;
    });

class _EmptyRepo implements ArtisanRepositoryImpl {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
