import '../../domain/entities/analytics_entities.dart';

class AnalyticsSummaryModel extends AnalyticsSummary {
  const AnalyticsSummaryModel({
    required super.totalRequests,
    required super.completedRequests,
    required super.pendingRequests,
    required super.cancelledRequests,
    required super.totalArtisans,
    required super.activeArtisans,
    required super.averageRating,
  });

  factory AnalyticsSummaryModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummaryModel(
      totalRequests: json['totalRequests'] as int,
      completedRequests: json['completedRequests'] as int,
      pendingRequests: json['pendingRequests'] as int,
      cancelledRequests: json['cancelledRequests'] as int,
      totalArtisans: json['totalArtisans'] as int,
      activeArtisans: json['activeArtisans'] as int,
      averageRating: (json['averageRating'] as num).toDouble(),
    );
  }
}

class RequestByDayModel extends RequestByDay {
  const RequestByDayModel({
    required super.date,
    required super.day,
    required super.requests,
    required super.completed,
    required super.pending,
    required super.cancelled,
  });

  factory RequestByDayModel.fromJson(Map<String, dynamic> json) {
    return RequestByDayModel(
      date: json['date'] as String,
      day: json['day'] as String,
      requests: json['requests'] as int,
      completed: json['completed'] as int,
      pending: json['pending'] as int,
      cancelled: json['cancelled'] as int,
    );
  }
}

class RequestByTradeModel extends RequestByTrade {
  const RequestByTradeModel({required super.trade, required super.count});

  factory RequestByTradeModel.fromJson(Map<String, dynamic> json) {
    return RequestByTradeModel(
      trade: json['trade'] as String,
      count: json['count'] as int,
    );
  }
}

class TopArtisanModel extends TopArtisan {
  const TopArtisanModel({
    required super.id,
    required super.name,
    required super.trade,
    required super.requestCount,
    required super.rating,
    required super.image,
  });

  factory TopArtisanModel.fromJson(Map<String, dynamic> json) {
    return TopArtisanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      trade: json['trade'] as String,
      requestCount: json['requestCount'] as int,
      rating: (json['rating'] as num).toDouble(),
      image: json['image'] as String? ?? '',
    );
  }
}

class AnalyticsModel extends Analytics {
  const AnalyticsModel({
    required super.summary,
    required super.requestsByDay,
    required super.requestsByTrade,
    required super.topArtisans,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    final data = json['analytics'] as Map<String, dynamic>;
    return AnalyticsModel(
      summary: AnalyticsSummaryModel.fromJson(
        data['summary'] as Map<String, dynamic>,
      ),
      requestsByDay: (data['requests_by_day'] as List)
          .map((e) => RequestByDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      requestsByTrade:
          (data['requests_by_trade'] as List)
              .map(
                (e) => RequestByTradeModel.fromJson(e as Map<String, dynamic>),
              )
              .toList()
            ..sort((a, b) => b.count.compareTo(a.count)),
      topArtisans: (data['top_artisans'] as List)
          .map((e) => TopArtisanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
