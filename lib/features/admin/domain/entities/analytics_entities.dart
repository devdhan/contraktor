class AnalyticsSummary {
  final int totalRequests;
  final int completedRequests;
  final int pendingRequests;
  final int cancelledRequests;
  final int totalArtisans;
  final int activeArtisans;
  final double averageRating;

  const AnalyticsSummary({
    required this.totalRequests,
    required this.completedRequests,
    required this.pendingRequests,
    required this.cancelledRequests,
    required this.totalArtisans,
    required this.activeArtisans,
    required this.averageRating,
  });
}

class RequestByDay {
  final String date;
  final String day;
  final int requests;
  final int completed;
  final int pending;
  final int cancelled;

  const RequestByDay({
    required this.date,
    required this.day,
    required this.requests,
    required this.completed,
    required this.pending,
    required this.cancelled,
  });
}

class RequestByTrade {
  final String trade;
  final int count;
  const RequestByTrade({required this.trade, required this.count});
}

class TopArtisan {
  final String id;
  final String name;
  final String trade;
  final int requestCount;
  final double rating;
  final String image;

  const TopArtisan({
    required this.id,
    required this.name,
    required this.trade,
    required this.requestCount,
    required this.rating,
    required this.image,
  });
}

class Analytics {
  final AnalyticsSummary summary;
  final List<RequestByDay> requestsByDay;
  final List<RequestByTrade> requestsByTrade;
  final List<TopArtisan> topArtisans;

  const Analytics({
    required this.summary,
    required this.requestsByDay,
    required this.requestsByTrade,
    required this.topArtisans,
  });
}
