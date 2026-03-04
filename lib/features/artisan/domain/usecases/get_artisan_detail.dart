import '../entities/artisan_detail.dart';
import '../repositories/artisan_repository.dart';

class GetArtisanDetail {
  final ArtisanRepository repository;

  GetArtisanDetail(this.repository);

  Future<ArtisanDetail> call(String id) {
    return repository.getArtisanDetail(id);
  }
}
