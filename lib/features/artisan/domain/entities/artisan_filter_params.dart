class ArtisanFilterParams {
  final String? query;
  final String? trade;
  final String? location;
  final double? minRating;
  final bool? availableOnly;

  const ArtisanFilterParams({
    this.query,
    this.trade,
    this.location,
    this.minRating,
    this.availableOnly,
  });

  ArtisanFilterParams copyWith({
    String? query,
    String? trade,
    String? location,
    double? minRating,
    bool? availableOnly,
  }) {
    return ArtisanFilterParams(
      query: query ?? this.query,
      trade: trade ?? this.trade,
      location: location ?? this.location,
      minRating: minRating ?? this.minRating,
      availableOnly: availableOnly ?? this.availableOnly,
    );
  }
}
