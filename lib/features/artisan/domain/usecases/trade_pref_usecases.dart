import '../repositories/artisan_repository.dart';

class GetSavedTradePref {
  final ArtisanRepository repository;
  GetSavedTradePref(this.repository);

  Future<String?> call() => repository.getSavedTradePref();
}

class SaveTradePref {
  final ArtisanRepository repository;
  SaveTradePref(this.repository);

  Future<void> call(String trade) => repository.saveTradePref(trade);
}
