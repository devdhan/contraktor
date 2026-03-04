import '../entities/service_request.dart';
import '../repositories/artisan_repository.dart';

class SubmitServiceRequest {
  final ArtisanRepository repository;

  SubmitServiceRequest(this.repository);

  Future<void> call(ServiceRequest request) {
    return repository.submitServiceRequest(request);
  }
}
