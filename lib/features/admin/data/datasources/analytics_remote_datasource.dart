import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/analytics_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<AnalyticsModel> getAnalytics();
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  @override
  Future<AnalyticsModel> getAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final jsonString = await rootBundle.loadString(
      'assets/mock_data/analytics.json',
    );
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return AnalyticsModel.fromJson(jsonMap);
  }
}
