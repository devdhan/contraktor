import '../../domain/entities/artisan.dart';

class ArtisanModel extends Artisan {
  const ArtisanModel({
    required super.id,
    required super.name,
    required super.trade,
    required super.location,
    required super.rating,
    required super.reviewCount,
    required super.hourlyRate,
    required super.currency,
    required super.image,
    required super.bio,
    required super.isAvailable,
    required super.tags,
  });

  factory ArtisanModel.fromJson(Map<String, dynamic> json) {
    return ArtisanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      trade: json['trade'] as String,
      location: json['location'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      hourlyRate: json['hourlyRate'] as int,
      currency: json['currency'] as String,
      image: json['image'] as String,
      bio: json['bio'] as String,
      isAvailable: json['isAvailable'] as bool,
      tags: List<String>.from(json['tags'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'trade': trade,
      'location': location,
      'rating': rating,
      'reviewCount': reviewCount,
      'hourlyRate': hourlyRate,
      'currency': currency,
      'image': image,
      'bio': bio,
      'isAvailable': isAvailable,
      'tags': tags,
    };
  }
}
