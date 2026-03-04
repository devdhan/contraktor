import 'package:contraktor/features/admin/presentation/widgets/period_selector.dart';
import 'package:contraktor/features/admin/presentation/widgets/requests_bar_chart.dart';
import 'package:contraktor/features/admin/presentation/widgets/requests_by_trade_list.dart';
import 'package:contraktor/features/admin/presentation/widgets/stat_card.dart';
import 'package:contraktor/features/admin/presentation/widgets/top_artisans_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers/analytics_provider.dart';

class AdminInsights extends ConsumerWidget {
  const AdminInsights({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analyticsNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade700,
        elevation: 0,
        automaticallyImplyLeading: false,
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
            onPressed: () =>
                ref.read(analyticsNotifierProvider.notifier).fetchAnalytics(),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            )
          : state.error != null
          ? _ErrorView(
              error: state.error!,
              onRetry: () =>
                  ref.read(analyticsNotifierProvider.notifier).fetchAnalytics(),
            )
          : _AnalyticsBody(analytics: state.analytics!),
    );
  }
}

// ── Body (only rendered when data is loaded) ──────────────────────────
class _AnalyticsBody extends StatelessWidget {
  final analytics;
  const _AnalyticsBody({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final summary = analytics.summary;

    return RefreshIndicator(
      color: Colors.greenAccent.shade700,
      onRefresh: () async {},
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Period selector ─────────────────────────────────────
          PeriodSelector(
            onChanged: (index, period) {
              // Wire to provider when you add period-based filtering
            },
          ),
          const SizedBox(height: 16),

          // ── Overview ────────────────────────────────────────────
          _label('Overview'),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              StatCard(
                label: 'Total Requests',
                value: '${summary.totalRequests}',
                icon: Icons.handyman_rounded,
                color: Colors.greenAccent.shade700,
              ),
              StatCard(
                label: 'Completed',
                value: '${summary.completedRequests}',
                icon: Icons.check_circle_outline_rounded,
                color: Colors.green.shade600,
              ),
              StatCard(
                label: 'Pending',
                value: '${summary.pendingRequests}',
                icon: Icons.hourglass_empty_rounded,
                color: Colors.orange,
              ),
              StatCard(
                label: 'Avg Rating',
                value: '${summary.averageRating}',
                icon: Icons.star_rounded,
                color: const Color(0xFFFBBC04),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Active artisans + cancelled banner
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
                      '${summary.activeArtisans} / ${summary.totalArtisans}',
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
                      '${summary.cancelledRequests}',
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

          // ── Requests per day chart ──────────────────────────────
          _label('Requests Per Day'),
          const SizedBox(height: 10),
          RequestsBarChart(data: analytics.requestsByDay), // ← reads from JSON
          const SizedBox(height: 20),

          // ── Requests by trade ───────────────────────────────────
          _label('Requests by Trade'),
          const SizedBox(height: 10),
          RequestsByTradeList(
            data: analytics.requestsByTrade,
          ), // ← reads from JSON
          const SizedBox(height: 20),

          // ── Top artisans ────────────────────────────────────────
          _label('Top Artisans'),
          const SizedBox(height: 10),
          TopArtisansList(artisans: analytics.topArtisans), // ← reads from JSON
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );
}

// ── Error view ────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[300]),
            const SizedBox(height: 12),
            const Text(
              'Failed to load insights',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              error,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade700,
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
