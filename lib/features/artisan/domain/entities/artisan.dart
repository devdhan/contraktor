class Artisan {
  final String id;
  final String name;
  final String trade;
  final String location;
  final double rating;
  final int reviewCount;
  final int hourlyRate;
  final String currency;
  final String image;
  final String bio;
  final bool isAvailable;
  final List<String> tags;

  const Artisan({
    required this.id,
    required this.name,
    required this.trade,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.hourlyRate,
    required this.currency,
    required this.image,
    required this.bio,
    required this.isAvailable,
    required this.tags,
  });
}
