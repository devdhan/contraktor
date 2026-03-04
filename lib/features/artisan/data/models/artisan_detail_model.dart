import '../../domain/entities/artisan_detail.dart';

class PortfolioItemModel extends PortfolioItem {
  const PortfolioItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.image,
    required super.completedDate,
  });

  factory PortfolioItemModel.fromJson(Map<String, dynamic> json) {
    return PortfolioItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      completedDate: json['completedDate'] as String,
    );
  }
}

class ReviewModel extends Review {
  const ReviewModel({
    required super.reviewer,
    required super.rating,
    required super.comment,
    required super.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewer: json['reviewer'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      date: json['date'] as String,
    );
  }
}

class AvailabilityModel extends Availability {
  const AvailabilityModel({
    required super.isAvailable,
    required super.nextAvailableDate,
    required super.workingHours,
    required super.workingDays,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      isAvailable: json['isAvailable'] as bool,
      nextAvailableDate: json['nextAvailableDate'] as String,
      workingHours: json['workingHours'] as String,
      workingDays: List<String>.from(json['workingDays'] as List),
    );
  }
}

class ArtisanDetailModel extends ArtisanDetail {
  const ArtisanDetailModel({
    required super.id,
    required super.portfolio,
    required super.availability,
    required super.reviews,
  });

  factory ArtisanDetailModel.fromJson(Map<String, dynamic> json) {
    return ArtisanDetailModel(
      id: json['id'] as String,
      portfolio: (json['portfolio'] as List)
          .map((e) => PortfolioItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      availability: AvailabilityModel.fromJson(
        json['availability'] as Map<String, dynamic>,
      ),
      reviews: (json['reviews'] as List)
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
