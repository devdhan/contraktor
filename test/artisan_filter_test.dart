import 'package:flutter_test/flutter_test.dart';
import 'package:contraktor/features/artisan/domain/entities/artisan.dart';
import 'package:contraktor/features/artisan/domain/entities/artisan_filter_params.dart';
import 'package:contraktor/features/admin/data/models/analytics_model.dart';

List<Artisan> applyFilters(List<Artisan> artisans, ArtisanFilterParams params) {
  return artisans.where((a) {
    final q = (params.query ?? '').toLowerCase().trim();
    final matchSearch =
        q.isEmpty ||
        a.name.toLowerCase().contains(q) ||
        a.trade.toLowerCase().contains(q);
    final matchTrade =
        params.trade == null ||
        params.trade == 'All' ||
        a.trade == params.trade;
    final matchLocation =
        params.location == null ||
        params.location == 'All' ||
        a.location.contains(params.location!);
    final matchRating =
        params.minRating == null || a.rating >= params.minRating!;
    final matchAvail = params.availableOnly != true || a.isAvailable;
    return matchSearch &&
        matchTrade &&
        matchLocation &&
        matchRating &&
        matchAvail;
  }).toList();
}

Artisan makeArtisan({
  String id = '1',
  String name = 'Test User',
  String trade = 'Plumber',
  String location = 'Lagos',
  double rating = 4.5,
  bool isAvailable = true,
}) {
  return Artisan(
    id: id,
    name: name,
    trade: trade,
    location: location,
    rating: rating,
    reviewCount: 10,
    hourlyRate: 5000,
    currency: 'NGN',
    image: 'https://example.com/img.jpg',
    bio: 'Test bio',
    isAvailable: isAvailable,
    tags: ['Tag1'],
  );
}

void main() {
  group('ArtisanFilter - search', () {
    final artisans = [
      makeArtisan(id: '1', name: 'Emeka Okafor', trade: 'Plumber'),
      makeArtisan(id: '2', name: 'Chidinma Eze', trade: 'Electrician'),
      makeArtisan(id: '3', name: 'Tunde Adeyemi', trade: 'Carpenter'),
    ];

    test('empty query returns all artisans', () {
      final result = applyFilters(artisans, const ArtisanFilterParams());
      expect(result.length, 3);
    });

    test('query matches by name (case-insensitive)', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(query: 'emeka'),
      );
      expect(result.length, 1);
      expect(result.first.name, 'Emeka Okafor');
    });

    test('query matches by trade', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(query: 'electrician'),
      );
      expect(result.length, 1);
      expect(result.first.trade, 'Electrician');
    });

    test('query with no match returns empty list', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(query: 'xyznotfound'),
      );
      expect(result.isEmpty, true);
    });
  });

  group('ArtisanFilter - trade filter', () {
    final artisans = [
      makeArtisan(id: '1', trade: 'Plumber'),
      makeArtisan(id: '2', trade: 'Electrician'),
      makeArtisan(id: '3', trade: 'Plumber'),
    ];

    test('"All" trade returns all artisans', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(trade: 'All'),
      );
      expect(result.length, 3);
    });

    test('specific trade filters correctly', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(trade: 'Plumber'),
      );
      expect(result.length, 2);
      expect(result.every((a) => a.trade == 'Plumber'), true);
    });

    test('trade with no match returns empty', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(trade: 'Welder'),
      );
      expect(result.isEmpty, true);
    });
  });

  group('ArtisanFilter - rating filter', () {
    final artisans = [
      makeArtisan(id: '1', rating: 4.9),
      makeArtisan(id: '2', rating: 4.3),
      makeArtisan(id: '3', rating: 3.8),
    ];

    test('minRating 4.5 returns only artisans at or above 4.5', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(minRating: 4.5),
      );
      expect(result.length, 1);
      expect(result.first.rating, 4.9);
    });

    test('minRating 0 returns all artisans', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(minRating: 0),
      );
      expect(result.length, 3);
    });
  });

  group('ArtisanFilter - availability filter', () {
    final artisans = [
      makeArtisan(id: '1', isAvailable: true),
      makeArtisan(id: '2', isAvailable: false),
      makeArtisan(id: '3', isAvailable: true),
    ];

    test('availableOnly=true returns only available artisans', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(availableOnly: true),
      );
      expect(result.length, 2);
      expect(result.every((a) => a.isAvailable), true);
    });

    test('availableOnly=false returns all artisans', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(availableOnly: false),
      );
      expect(result.length, 3);
    });
  });

  group('ArtisanFilter - combined filters', () {
    final artisans = [
      makeArtisan(
        id: '1',
        trade: 'Plumber',
        location: 'Lagos',
        rating: 4.8,
        isAvailable: true,
      ),
      makeArtisan(
        id: '2',
        trade: 'Plumber',
        location: 'Abuja',
        rating: 4.2,
        isAvailable: false,
      ),
      makeArtisan(
        id: '3',
        trade: 'Electrician',
        location: 'Lagos',
        rating: 4.9,
        isAvailable: true,
      ),
    ];

    test('trade + location + available filters work together', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(
          trade: 'Plumber',
          location: 'Lagos',
          availableOnly: true,
        ),
      );
      expect(result.length, 1);
      expect(result.first.id, '1');
    });

    test('rating + available filters work together', () {
      final result = applyFilters(
        artisans,
        const ArtisanFilterParams(minRating: 4.5, availableOnly: true),
      );
      expect(result.length, 2);
      expect(result.every((a) => a.rating >= 4.5 && a.isAvailable), true);
    });
  });

  group('ArtisanFilterParams.copyWith', () {
    test('copyWith updates only specified fields', () {
      const original = ArtisanFilterParams(
        query: 'plumber',
        trade: 'Plumber',
        minRating: 4.0,
      );
      final updated = original.copyWith(trade: 'Electrician');

      expect(updated.query, 'plumber');
      expect(updated.trade, 'Electrician');
      expect(updated.minRating, 4.0);
    });
  });

  group('AnalyticsModel.fromJson', () {
    const sampleJson = {
      'analytics': {
        'summary': {
          'totalRequests': 342,
          'completedRequests': 289,
          'pendingRequests': 38,
          'cancelledRequests': 15,
          'totalArtisans': 10,
          'activeArtisans': 8,
          'averageRating': 4.64,
        },
        'requests_by_day': [
          {
            'date': '2026-03-01',
            'day': 'Sat',
            'requests': 53,
            'completed': 46,
            'pending': 5,
            'cancelled': 2,
          },
        ],
        'requests_by_trade': [
          {'trade': 'Plumber', 'count': 78},
          {'trade': 'Electrician', 'count': 91},
        ],
        'top_artisans': [
          {
            'id': '2',
            'name': 'Chidinma Eze',
            'trade': 'Electrician',
            'requestCount': 48,
            'rating': 4.9,
            'image': 'https://randomuser.me/api/portraits/women/2.jpg',
          },
        ],
      },
    };

    test('parses summary correctly', () {
      final model = AnalyticsModel.fromJson(sampleJson);
      expect(model.summary.totalRequests, 342);
      expect(model.summary.completedRequests, 289);
      expect(model.summary.averageRating, 4.64);
    });

    test('parses requests_by_day correctly', () {
      final model = AnalyticsModel.fromJson(sampleJson);
      expect(model.requestsByDay.length, 1);
      expect(model.requestsByDay.first.day, 'Sat');
      expect(model.requestsByDay.first.requests, 53);
    });

    test('sorts requests_by_trade descending by count', () {
      final model = AnalyticsModel.fromJson(sampleJson);

      expect(model.requestsByTrade.first.trade, 'Electrician');
      expect(model.requestsByTrade.last.trade, 'Plumber');
    });

    test('parses top_artisans with image', () {
      final model = AnalyticsModel.fromJson(sampleJson);
      expect(model.topArtisans.first.name, 'Chidinma Eze');
      expect(model.topArtisans.first.image.isNotEmpty, true);
    });

    test('handles missing image field gracefully', () {
      final jsonWithNoImage = {
        'analytics': {
          ...sampleJson['analytics'] as Map,
          'top_artisans': [
            {
              'id': '1',
              'name': 'Test',
              'trade': 'Plumber',
              'requestCount': 10,
              'rating': 4.5,
            },
          ],
        },
      };
      final model = AnalyticsModel.fromJson(jsonWithNoImage);
      expect(model.topArtisans.first.image, '');
    });
  });
}
