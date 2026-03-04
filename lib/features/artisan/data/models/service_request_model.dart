import '../../domain/entities/service_request.dart';

class ServiceRequestModel extends ServiceRequest {
  const ServiceRequestModel({
    required super.artisanId,
    required super.serviceTitle,
    required super.description,
    required super.address,
    required super.preferredDate,
    required super.urgencyLevel,
  });

  factory ServiceRequestModel.fromEntity(ServiceRequest entity) {
    return ServiceRequestModel(
      artisanId: entity.artisanId,
      serviceTitle: entity.serviceTitle,
      description: entity.description,
      address: entity.address,
      preferredDate: entity.preferredDate,
      urgencyLevel: entity.urgencyLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artisanId': artisanId,
      'serviceTitle': serviceTitle,
      'description': description,
      'address': address,
      'preferredDate': preferredDate,
      'urgencyLevel': urgencyLevel,
    };
  }
}
