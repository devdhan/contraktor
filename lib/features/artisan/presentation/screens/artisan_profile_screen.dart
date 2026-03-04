import 'package:contraktor/features/artisan/presentation/widget/portfolio_card.dart';
import 'package:contraktor/features/artisan/presentation/widget/request_service_form.dart';
import 'package:contraktor/features/artisan/presentation/widget/review_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArtisanProfileScreen extends StatefulWidget {
  final String artisanId;
  const ArtisanProfileScreen({super.key, required this.artisanId});

  @override
  State<ArtisanProfileScreen> createState() => _ArtisanProfileScreenState();
}

class _ArtisanProfileScreenState extends State<ArtisanProfileScreen> {
  // Replace with provider later
  final Map<String, dynamic> artisan = {
    "id": "1",
    "name": "Emeka Okafor",
    "trade": "Plumber",
    "location": "Lagos Island, Lagos",
    "rating": 4.8,
    "reviewCount": 124,
    "hourlyRate": 5000,
    "currency": "NGN",
    "image": "https://randomuser.me/api/portraits/men/1.jpg",
    "bio":
        "Master plumber with 12 years of experience in residential and commercial plumbing installations, repairs, and maintenance.",
    "isAvailable": true,
    "tags": ["Plumbing", "Pipe Fitting", "Water Heaters", "Drainage"],
    "availability": {
      "workingHours": "8:00 AM - 6:00 PM",
      "workingDays": [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
      ],
      "nextAvailableDate": "2026-03-04",
    },
    "portfolio": [
      {
        "id": "p1",
        "title": "Kitchen Pipe Overhaul",
        "description": "Full kitchen plumbing overhaul for a 3-bedroom flat.",
        "image":
            "https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=400",
        "completedDate": "2025-11-10",
      },
      {
        "id": "p2",
        "title": "Bathroom Fitting",
        "description":
            "Complete bathroom fittings including WC, shower, and sink.",
        "image":
            "https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=400",
        "completedDate": "2025-12-03",
      },
      {
        "id": "p3",
        "title": "Drainage System Repair",
        "description":
            "Repaired blocked drainage across a commercial property.",
        "image":
            "https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=400",
        "completedDate": "2026-01-15",
      },
    ],
    "reviews": [
      {
        "reviewer": "Adaeze M.",
        "rating": 5,
        "comment": "Emeka was prompt, professional and tidy. Highly recommend!",
        "date": "2026-02-10",
      },
      {
        "reviewer": "Kola B.",
        "rating": 5,
        "comment": "Fixed our burst pipe same day. Lifesaver!",
        "date": "2026-01-28",
      },
      {
        "reviewer": "Mrs Okoro",
        "rating": 4,
        "comment": "Good work but arrived a bit late.",
        "date": "2026-01-05",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final bool available = artisan['isAvailable'] as bool;
    final tags = (artisan['tags'] as List).cast<String>();
    final portfolio = (artisan['portfolio'] as List)
        .cast<Map<String, dynamic>>();
    final reviews = (artisan['reviews'] as List).cast<Map<String, dynamic>>();
    final availability = artisan['availability'] as Map<String, dynamic>;
    final workingDays = (availability['workingDays'] as List).cast<String>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────────────
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
                              backgroundImage: NetworkImage(artisan['image']),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: available
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
                        artisan['name'],
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
                            artisan['trade'],
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
                            artisan['location'],
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
                // ── Stats ────────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      _statItem(
                        '${artisan['rating']}',
                        'Rating',
                        Icons.star_rounded,
                        const Color(0xFFFBBC04),
                      ),
                      _dividerV(),
                      _statItem(
                        '${artisan['reviewCount']}',
                        'Reviews',
                        Icons.reviews_outlined,
                        Colors.greenAccent.shade700,
                      ),
                      _dividerV(),
                      _statItem(
                        '₦${artisan['hourlyRate']}/hr',
                        'Rate',
                        Icons.payments_outlined,
                        const Color(0xFF22C55E),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // ── About ────────────────────────────────────────
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('About'),
                      const SizedBox(height: 10),
                      Text(
                        artisan['bio'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: tags
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

                // ── Availability ─────────────────────────────────
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Availability'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: available
                                  ? const Color(0xFF22C55E)
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            available
                                ? 'Currently Available'
                                : 'Currently Unavailable',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: available
                                  ? const Color(0xFF22C55E)
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _availRow(
                        Icons.access_time_rounded,
                        'Working Hours',
                        availability['workingHours'],
                      ),
                      const SizedBox(height: 6),
                      _availRow(
                        Icons.calendar_today_rounded,
                        'Next Available',
                        availability['nextAvailableDate'],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: workingDays
                            .map(
                              (d) => _pill(
                                d.substring(0, 3),
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

                // ── Portfolio ────────────────────────────────────
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Portfolio'),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: portfolio.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, i) =>
                              PortfolioCard(item: portfolio[i]), // ← extracted
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // ── Reviews ──────────────────────────────────────
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Reviews'),
                      const SizedBox(height: 4),
                      ...reviews.map(
                        (r) => ReviewTile(review: r),
                      ), // ← extracted
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      // ── Request Service button ────────────────────────────────
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
            onPressed: () => _showRequestForm(context),
          ),
        ),
      ),
    );
  }

  void _showRequestForm(BuildContext context) {
    showCupertinoSheet(
      context: context,
      builder: (_) =>
          const Material(child: RequestServiceForm()), // ← extracted
    );
  }

  Widget _sectionCard({required Widget child}) => Container(
    width: double.infinity,
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    child: child,
  );

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );

  Widget _statItem(String value, String label, IconData icon, Color color) =>
      Expanded(
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ],
        ),
      );

  Widget _dividerV() =>
      Container(width: 1, height: 40, color: Colors.grey[200]);

  Widget _availRow(IconData icon, String label, String value) => Row(
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

  Widget _pill(String text, Color bg, Color fg) => Container(
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
