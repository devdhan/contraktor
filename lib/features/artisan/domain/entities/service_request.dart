class ServiceRequest {
  final String artisanId;
  final String serviceTitle;
  final String description;
  final String address;
  final String preferredDate;
  final String urgencyLevel;

  const ServiceRequest({
    required this.artisanId,
    required this.serviceTitle,
    required this.description,
    required this.address,
    required this.preferredDate,
    required this.urgencyLevel,
  });
}
