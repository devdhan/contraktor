import 'package:contraktor/features/artisan/app/providers/artisans_provider.dart';
import 'package:contraktor/features/artisan/app/providers/profile_provider.dart';
import 'package:contraktor/features/artisan/domain/entities/artisan.dart';
import 'package:contraktor/features/artisan/domain/entities/artisan_detail.dart';
import 'package:contraktor/features/artisan/domain/entities/service_request.dart';
import 'package:contraktor/features/artisan/presentation/widget/portfolio_card.dart';
import 'package:contraktor/features/artisan/presentation/widget/request_service_form.dart';
import 'package:contraktor/features/artisan/presentation/widget/review_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtisanProfileScreen extends ConsumerWidget {
  final String artisanId;
  const ArtisanProfileScreen({super.key, required this.artisanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider(artisanId));

    final artisansState = ref.watch(artisansNotifierProvider);
    final Artisan? artisan =
        artisansState.artisans.where((a) => a.id == artisanId).isNotEmpty
        ? artisansState.artisans.firstWhere((a) => a.id == artisanId)
        : null;

    if (artisan == null && profileState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.greenAccent),
        ),
      );
    }

    if (artisan == null && profileState.error != null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.greenAccent.shade700),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(profileState.error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(profileNotifierProvider(artisanId).notifier)
                    .loadProfile(artisanId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final a = artisan!;
    final detail = profileState.detail;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Colors.greenAccent.shade700,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.bookmark_border_rounded,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.greenAccent.shade700,
                      Colors.green.shade400,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(a.image),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: a.isAvailable
                                    ? const Color(0xFF22C55E)
                                    : Colors.grey,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        a.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _pill(
                            a.trade,
                            Colors.white.withOpacity(0.2),
                            Colors.white,
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.location_on,
                            size: 20,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            a.location,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      _statItem(
                        '${a.rating}',
                        'Rating',
                        Icons.star_rounded,
                        const Color(0xFFFBBC04),
                      ),
                      _dividerV(),
                      _statItem(
                        '${a.reviewCount}',
                        'Reviews',
                        Icons.reviews_outlined,
                        Colors.greenAccent.shade700,
                      ),
                      _dividerV(),
                      _statItem(
                        '₦${a.hourlyRate}/hr',
                        'Rate',
                        Icons.payments_outlined,
                        const Color(0xFF22C55E),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('About'),
                      const SizedBox(height: 10),
                      Text(
                        a.bio,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: a.tags
                            .map(
                              (t) => _pill(
                                t,
                                Colors.greenAccent.shade100,
                                Colors.greenAccent.shade700,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                if (profileState.isLoading && detail == null)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                      ),
                    ),
                  )
                else if (detail != null) ...[
                  _AvailabilitySection(
                    artisan: a,
                    availability: detail.availability,
                  ),
                  const SizedBox(height: 8),
                  _PortfolioSection(portfolio: detail.portfolio),
                  const SizedBox(height: 8),
                  _ReviewsSection(reviews: detail.reviews),
                ],

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            label: const Text(
              'Request Service',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () => _showRequestForm(context, ref, artisanId),
          ),
        ),
      ),
    );
  }

  void _showRequestForm(BuildContext context, WidgetRef ref, String id) {
    showCupertinoSheet(
      context: context,
      builder: (_) => Material(
        child: RequestServiceForm(
          artisanId: id,
          onSubmit: (title, description, address, date, urgency) async {
            await ref
                .read(profileNotifierProvider(id).notifier)
                .submitRequest(
                  ServiceRequest(
                    artisanId: id,
                    serviceTitle: title,
                    description: description,
                    address: address,
                    preferredDate: date,
                    urgencyLevel: urgency,
                  ),
                );
          },
        ),
      ),
    );
  }

  static Widget _sectionCard({required Widget child}) => Container(
    width: double.infinity,
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    child: child,
  );

  static Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );

  static Widget _statItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) => Expanded(
    child: Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
      ],
    ),
  );

  static Widget _dividerV() =>
      Container(width: 1, height: 40, color: Colors.grey[200]);

  static Widget _pill(String text, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
      style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600),
    ),
  );
}

class _AvailabilitySection extends StatelessWidget {
  final Artisan artisan;
  final Availability availability;
  const _AvailabilitySection({
    required this.artisan,
    required this.availability,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Availability',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: artisan.isAvailable
                      ? const Color(0xFF22C55E)
                      : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                artisan.isAvailable
                    ? 'Currently Available'
                    : 'Currently Unavailable',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: artisan.isAvailable
                      ? const Color(0xFF22C55E)
                      : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _row(
            Icons.access_time_rounded,
            'Working Hours',
            availability.workingHours,
          ),
          const SizedBox(height: 6),
          _row(
            Icons.calendar_today_rounded,
            'Next Available',
            availability.nextAvailableDate,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: availability.workingDays
                .map(
                  (d) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.shade100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      d.substring(0, 3),
                      style: TextStyle(
                        color: Colors.greenAccent.shade700,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => Row(
    children: [
      Icon(icon, size: 20, color: Colors.greenAccent.shade700),
      const SizedBox(width: 5),
      Text(
        '$label: ',
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      Text(value, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
    ],
  );
}

class _PortfolioSection extends StatelessWidget {
  final List<PortfolioItem> portfolio;
  const _PortfolioSection({required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portfolio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: portfolio.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => PortfolioCard(item: portfolio[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  final List<Review> reviews;
  const _ReviewsSection({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          ...reviews.map((r) => ReviewTile(review: r)),
        ],
      ),
    );
  }
}
