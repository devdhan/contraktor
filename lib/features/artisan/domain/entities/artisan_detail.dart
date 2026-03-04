class PortfolioItem {
  final String id;
  final String title;
  final String description;
  final String image;
  final String completedDate;

  const PortfolioItem({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.completedDate,
  });
}

class Review {
  final String reviewer;
  final int rating;
  final String comment;
  final String date;

  const Review({
    required this.reviewer,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class Availability {
  final bool isAvailable;
  final String nextAvailableDate;
  final String workingHours;
  final List<String> workingDays;

  const Availability({
    required this.isAvailable,
    required this.nextAvailableDate,
    required this.workingHours,
    required this.workingDays,
  });
}

class ArtisanDetail {
  final String id;
  final List<PortfolioItem> portfolio;
  final Availability availability;
  final List<Review> reviews;

  const ArtisanDetail({
    required this.id,
    required this.portfolio,
    required this.availability,
    required this.reviews,
  });
}
