import '../entities/artisan.dart';
import '../entities/artisan_filter_params.dart';
import '../repositories/artisan_repository.dart';

class GetArtisans {
  final ArtisanRepository repository;

  GetArtisans(this.repository);

  Future<List<Artisan>> call(ArtisanFilterParams params) {
    return repository.getArtisans(params);
  }
}
