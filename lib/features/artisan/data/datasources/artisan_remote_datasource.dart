import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/artisan_model.dart';
import '../models/artisan_detail_model.dart';
import '../models/service_request_model.dart';

abstract class ArtisanRemoteDataSource {
  Future<List<ArtisanModel>> getArtisans();
  Future<ArtisanDetailModel> getArtisanDetail(String id);
  Future<void> submitServiceRequest(ServiceRequestModel request);
}

class ArtisanRemoteDataSourceImpl implements ArtisanRemoteDataSource {
  @override
  Future<List<ArtisanModel>> getArtisans() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final jsonString = await rootBundle.loadString(
      'assets/mock_data/artisans.json',
    );
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    final artisansList = jsonMap['artisans'] as List;

    return artisansList
        .map((e) => ArtisanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ArtisanDetailModel> getArtisanDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final jsonString = await rootBundle.loadString(
      'assets/mock_data/artisan_detail.json',
    );
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    final detailsList = jsonMap['artisan_details'] as List;

    final detailJson = detailsList.firstWhere(
      (e) => (e as Map<String, dynamic>)['id'] == id,
      orElse: () => throw Exception('Artisan detail not found for id: $id'),
    );

    // Merge isAvailable from artisan_detail availability block
    return ArtisanDetailModel.fromJson(detailJson as Map<String, dynamic>);
  }

  @override
  Future<void> submitServiceRequest(ServiceRequestModel request) async {
    // Simulate POST request
    await Future.delayed(const Duration(seconds: 1));
    // In production: replace with http.post(url, body: request.toJson())
  }
}
