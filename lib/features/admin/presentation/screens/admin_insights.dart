import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminInsights extends StatefulWidget {
  const AdminInsights({super.key});

  @override
  State<AdminInsights> createState() => _AdminInsightsState();
}

class _AdminInsightsState extends State<AdminInsights> {
  int _touchedIndex = -1;

  final Map<String, dynamic> analytics = {
    "summary": {
      "totalRequests": 342,
      "completedRequests": 289,
      "pendingRequests": 38,
      "cancelledRequests": 15,
      "totalArtisans": 10,
      "activeArtisans": 8,
      "averageRating": 4.64,
    },
    "requests_by_day": [
      {"day": "Tue", "requests": 28, "completed": 24},
      {"day": "Wed", "requests": 35, "completed": 30},
      {"day": "Thu", "requests": 22, "completed": 18},
      {"day": "Fri", "requests": 41, "completed": 36},
      {"day": "Sat", "requests": 53, "completed": 46},
      {"day": "Sun", "requests": 19, "completed": 15},
      {"day": "Mon", "requests": 47, "completed": 40},
    ],
    "requests_by_trade": [
      {"trade": "Electrician", "count": 91},
      {"trade": "Plumber", "count": 78},
      {"trade": "AC Tech", "count": 62},
      {"trade": "Carpenter", "count": 43},
      {"trade": "Painter", "count": 37},
      {"trade": "Tiler", "count": 31},
    ],
    "top_artisans": [
      {
        "name": "Chidinma Eze",
        "trade": "Electrician",
        "requestCount": 48,
        "rating": 4.9,
        "image": "https://randomuser.me/api/portraits/women/2.jpg",
      },
      {
        "name": "Seun Adesanya",
        "trade": "AC Technician",
        "requestCount": 44,
        "rating": 4.9,
        "image": "https://randomuser.me/api/portraits/men/7.jpg",
      },
      {
        "name": "Emeka Okafor",
        "trade": "Plumber",
        "requestCount": 39,
        "rating": 4.8,
        "image": "https://randomuser.me/api/portraits/men/1.jpg",
      },
      {
        "name": "Ngozi Ibe",
        "trade": "Painter",
        "requestCount": 31,
        "rating": 4.7,
        "image": "https://randomuser.me/api/portraits/women/4.jpg",
      },
      {
        "name": "Fatima Bello",
        "trade": "Tiler",
        "requestCount": 28,
        "rating": 4.7,
        "image": "https://randomuser.me/api/portraits/women/8.jpg",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final summary = analytics['summary'] as Map<String, dynamic>;
    final byDay = (analytics['requests_by_day'] as List)
        .cast<Map<String, dynamic>>();
    final byTrade = (analytics['requests_by_trade'] as List)
        .cast<Map<String, dynamic>>();
    final topArtisans = (analytics['top_artisans'] as List)
        .cast<Map<String, dynamic>>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade700,
        elevation: 0,
        title: const Text(
          'Admin Insights',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.greenAccent.shade700,
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _PeriodSelector(),
            const SizedBox(height: 16),

            _sectionLabel('Overview'),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _StatCard(
                  label: 'Total Requests',
                  value: '${summary['totalRequests']}',
                  icon: Icons.handyman_rounded,
                  color: Colors.greenAccent.shade700,
                ),
                _StatCard(
                  label: 'Completed',
                  value: '${summary['completedRequests']}',
                  icon: Icons.check_circle_outline_rounded,
                  color: Colors.green.shade600,
                ),
                _StatCard(
                  label: 'Pending',
                  value: '${summary['pendingRequests']}',
                  icon: Icons.hourglass_empty_rounded,
                  color: Colors.orange,
                ),
                _StatCard(
                  label: 'Avg Rating',
                  value: '${summary['averageRating']}',
                  icon: Icons.star_rounded,
                  color: const Color(0xFFFBBC04),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade700,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Artisans',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${summary['activeArtisans']} / ${summary['totalArtisans']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Cancelled',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${summary['cancelledRequests']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _sectionLabel('Requests Per Day'),
            const SizedBox(height: 10),
            _ChartCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _legendDot(Colors.greenAccent.shade700),
                      const SizedBox(width: 4),
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      _legendDot(Colors.green.shade300),
                      const SizedBox(width: 4),
                      const Text(
                        'Completed',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 70,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (_) => Colors.black87,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final day = byDay[group.x]['day'];
                              return BarTooltipItem(
                                '$day\n${rod.toY.toInt()}',
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                          touchCallback: (event, response) {
                            setState(() {
                              _touchedIndex =
                                  response?.spot?.touchedBarGroupIndex ?? -1;
                            });
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    byDay[value.toInt()]['day'],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: Colors.grey.shade200,
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: byDay.asMap().entries.map((e) {
                          final i = e.key;
                          final d = e.value;
                          final isTouched = i == _touchedIndex;
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: (d['requests'] as int).toDouble(),
                                color: isTouched
                                    ? Colors.greenAccent.shade700
                                    : Colors.greenAccent.shade700.withOpacity(
                                        0.7,
                                      ),
                                width: 10,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                              BarChartRodData(
                                toY: (d['completed'] as int).toDouble(),
                                color: isTouched
                                    ? Colors.green.shade400
                                    : Colors.green.shade300.withOpacity(0.7),
                                width: 10,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _sectionLabel('Requests by Trade'),
            const SizedBox(height: 10),
            _ChartCard(
              child: Column(
                children: byTrade.map((t) {
                  final max = (byTrade.first['count'] as int).toDouble();
                  final val = (t['count'] as int).toDouble();
                  final pct = val / max;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t['trade'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${t['count']}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.greenAccent.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.greenAccent.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            _sectionLabel('Top Artisans'),
            const SizedBox(height: 10),
            _ChartCard(
              child: Column(
                children: topArtisans.asMap().entries.map((e) {
                  final i = e.key;
                  final a = e.value;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: i == 0
                                  ? const Color(0xFFFBBC04)
                                  : i == 1
                                  ? Colors.grey.shade400
                                  : i == 2
                                  ? Colors.brown.shade300
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: i < 3 ? Colors.white : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(a['image']),
                            backgroundColor: Colors.grey.shade200,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  a['trade'],
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${a['requestCount']} jobs',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 15,
                                    color: Color(0xFFFBBC04),
                                  ),
                                  Text(
                                    '${a['rating']}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (i < topArtisans.length - 1)
                        const Divider(height: 16, indent: 34),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );

  Widget _legendDot(Color color) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _PeriodSelector extends StatefulWidget {
  @override
  State<_PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<_PeriodSelector> {
  int _selected = 0;
  final _options = ['7 Days', '30 Days', '3 Months', 'Year'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: _options.asMap().entries.map((e) {
          final selected = _selected == e.key;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selected = e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.greenAccent.shade700
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  e.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final Widget child;
  const _ChartCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
