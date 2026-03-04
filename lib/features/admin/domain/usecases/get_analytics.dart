import '../entities/analytics_entities.dart';
import '../repositories/analytics_repository.dart';

class GetAnalytics {
  final AnalyticsRepository repository;
  GetAnalytics(this.repository);

  Future<Analytics> call() => repository.getAnalytics();
}
