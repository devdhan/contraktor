import 'package:contraktor/features/artisan/app/providers/artisans_provider.dart';
import 'package:contraktor/features/artisan/presentation/widget/artisan_card.dart';
import 'package:contraktor/features/artisan/presentation/widget/filter_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ArtisansScreen extends ConsumerStatefulWidget {
  const ArtisansScreen({super.key});

  @override
  ConsumerState<ArtisansScreen> createState() => _ArtisansScreenState();
}

class _ArtisansScreenState extends ConsumerState<ArtisansScreen> {
  final _searchCtrl = TextEditingController();
  DateTime _lastSearchTime = DateTime.now();

  final trades = [
    'All',
    'Plumber',
    'Electrician',
    'Carpenter',
    'Painter',
    'Mason',
    'Welder',
    'AC Technician',
    'Tiler',
  ];
  final locations = ['All', 'Lagos', 'Abuja, FCT', 'Port Harcourt', 'Kano'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // 400ms debounce
  void _onSearchChanged(String query) {
    _lastSearchTime = DateTime.now();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (DateTime.now().difference(_lastSearchTime).inMilliseconds >= 400) {
        ref.read(artisansNotifierProvider.notifier).updateSearch(query);
      }
    });
  }

  void _showFilterSheet(ArtisansState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FilterSheet(
        selectedTrade: state.filters.trade ?? 'All',
        selectedLocation: state.filters.location ?? 'All',
        minRating: state.filters.minRating ?? 0.0,
        availableOnly: state.filters.availableOnly ?? false,
        trades: trades,
        locations: locations,
        onApply:
            ({
              required trade,
              required location,
              required minRating,
              required availableOnly,
            }) {
              ref
                  .read(artisansNotifierProvider.notifier)
                  .applyFilters(
                    trade: trade,
                    location: location,
                    minRating: minRating,
                    availableOnly: availableOnly,
                  );
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(artisansNotifierProvider);
    final filters = state.filters;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Explore Artisans',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => context.push('/admin'),
            child: Row(
              children: [
                const Icon(
                  Icons.admin_panel_settings_outlined,
                  color: Colors.greenAccent,
                ),
                const SizedBox(width: 4),
                Text(
                  'Admin Insight',
                  style: TextStyle(color: Colors.black, fontSize: 10),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (state.isOffline)
            Container(
              width: double.infinity,
              color: Colors.orange.shade100,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: const Row(
                children: [
                  Icon(Icons.wifi_off_rounded, size: 16, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'You are offline — showing cached results',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                ],
              ),
            ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search Service or Artisan',
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: const BorderSide(color: Colors.greenAccent),
                      ),
                      prefixIcon: const Icon(
                        CupertinoIcons.search,
                        color: Colors.black,
                      ),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                CupertinoIcons.clear_circled_solid,
                                size: 20,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                _searchCtrl.clear();
                                ref
                                    .read(artisansNotifierProvider.notifier)
                                    .updateSearch('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white10,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showFilterSheet(state),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    child: const Center(
                      child: Icon(Icons.tune_rounded, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if ((filters.trade != null && filters.trade != 'All') ||
              (filters.location != null && filters.location != 'All') ||
              (filters.minRating != null && filters.minRating! > 0) ||
              filters.availableOnly == true)
            Container(
              height: 40,
              color: Colors.white,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                children: [
                  if (filters.trade != null && filters.trade != 'All')
                    _activeChip(
                      filters.trade!,
                      () => ref
                          .read(artisansNotifierProvider.notifier)
                          .applyFilters(trade: 'All'),
                    ),
                  if (filters.location != null && filters.location != 'All')
                    _activeChip(
                      filters.location!,
                      () => ref
                          .read(artisansNotifierProvider.notifier)
                          .applyFilters(location: 'All'),
                    ),
                  if (filters.minRating != null && filters.minRating! > 0)
                    _activeChip(
                      '⭐ ${filters.minRating!.toStringAsFixed(1)}+',
                      () => ref
                          .read(artisansNotifierProvider.notifier)
                          .applyFilters(minRating: 0),
                    ),
                  if (filters.availableOnly == true)
                    _activeChip(
                      'Available',
                      () => ref
                          .read(artisansNotifierProvider.notifier)
                          .applyFilters(availableOnly: false),
                    ),
                ],
              ),
            ),

          if (!state.isLoading)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Text(
                    '${state.artisans.length} artisan${state.artisans.length != 1 ? "s" : ""} found',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),

          Expanded(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.greenAccent),
                  )
                : state.error != null
                ? _errorState(state.error!)
                : state.artisans.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: state.artisans.length,
                    itemBuilder: (ctx, i) {
                      final artisan = state.artisans[i];
                      return ArtisanCard(
                        key: ValueKey(artisan.id),
                        artisan: artisan,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _activeChip(String label, VoidCallback onRemove) => Container(
    margin: const EdgeInsets.only(right: 8),
    child: Chip(
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF1B5E20),
          fontWeight: FontWeight.w500,
        ),
      ),
      deleteIcon: const Icon(Icons.close, size: 14, color: Color(0xFF1B5E20)),
      onDeleted: onRemove,
      backgroundColor: Colors.greenAccent.withOpacity(0.5),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    ),
  );

  Widget _emptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
        const SizedBox(height: 12),
        const Text(
          'None Found',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          'Try adjusting your filters',
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
      ],
    ),
  );

  Widget _errorState(String message) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[300]),
          const SizedBox(height: 12),
          const Text(
            'Something went wrong',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade700,
            ),
            onPressed: () =>
                ref.read(artisansNotifierProvider.notifier).fetchArtisans(),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );
}
