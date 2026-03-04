import 'package:contraktor/features/admin/domain/entities/analytics_entities.dart';

abstract class AnalyticsRepository {
  Future<Analytics> getAnalytics();
}
