import '../../domain/entities/analytics_entities.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_remote_datasource.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Analytics> getAnalytics() async {
    try {
      return await remoteDataSource.getAnalytics();
    } catch (e) {
      rethrow;
    }
  }
}
