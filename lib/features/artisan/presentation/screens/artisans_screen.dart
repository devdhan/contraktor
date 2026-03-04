import 'package:contraktor/features/artisan/presentation/widget/artisan_card.dart';
import 'package:contraktor/features/artisan/presentation/widget/filter_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArtisansScreen extends StatefulWidget {
  const ArtisansScreen({super.key});

  @override
  State<ArtisansScreen> createState() => _ArtisansScreenState();
}

class _ArtisansScreenState extends State<ArtisansScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedTrade = 'All';
  String _selectedLocation = 'All';
  double _minRating = 0.0;
  bool _availableOnly = false;

  final trades = [
    'All', 'Plumber', 'Electrician', 'Carpenter',
    'Painter', 'Mason', 'Welder', 'AC Technician', 'Tiler',
  ];
  final locations = ['All', 'Lagos', 'Abuja, FCT', 'Port Harcourt', 'Kano'];

  // Replace with provider later
  final List<Map<String, dynamic>> _artisans = [
    { "id": "1", "name": "Emeka Okafor", "trade": "Plumber", "location": "Lagos Island, Lagos", "rating": 4.8, "reviewCount": 124, "hourlyRate": 5000, "image": "https://randomuser.me/api/portraits/men/1.jpg", "isAvailable": true, "tags": ["Plumbing", "Pipe Fitting", "Water Heaters"] },
    { "id": "2", "name": "Chidinma Eze", "trade": "Electrician", "location": "Ikeja, Lagos", "rating": 4.9, "reviewCount": 89, "hourlyRate": 6000, "image": "https://randomuser.me/api/portraits/women/2.jpg", "isAvailable": true, "tags": ["Wiring", "Solar", "Installations"] },
    { "id": "3", "name": "Tunde Adeyemi", "trade": "Carpenter", "location": "Surulere, Lagos", "rating": 4.6, "reviewCount": 57, "hourlyRate": 4500, "image": "https://randomuser.me/api/portraits/men/3.jpg", "isAvailable": false, "tags": ["Furniture", "Cabinets", "Woodwork"] },
    { "id": "4", "name": "Ngozi Ibe", "trade": "Painter", "location": "Lekki, Lagos", "rating": 4.7, "reviewCount": 43, "hourlyRate": 3500, "image": "https://randomuser.me/api/portraits/women/4.jpg", "isAvailable": true, "tags": ["Interior", "Exterior", "Wallpaper"] },
    { "id": "5", "name": "Biodun Fashola", "trade": "Mason", "location": "Yaba, Lagos", "rating": 4.5, "reviewCount": 72, "hourlyRate": 5500, "image": "https://randomuser.me/api/portraits/men/5.jpg", "isAvailable": true, "tags": ["Bricklaying", "Plastering", "Tiling"] },
    { "id": "6", "name": "Amaka Obi", "trade": "Welder", "location": "Oshodi, Lagos", "rating": 4.4, "reviewCount": 38, "hourlyRate": 6500, "image": "https://randomuser.me/api/portraits/women/6.jpg", "isAvailable": true, "tags": ["Fabrication", "Gates", "Steel"] },
    { "id": "7", "name": "Seun Adesanya", "trade": "AC Technician", "location": "Victoria Island, Lagos", "rating": 4.9, "reviewCount": 101, "hourlyRate": 7000, "image": "https://randomuser.me/api/portraits/men/7.jpg", "isAvailable": false, "tags": ["AC Repair", "HVAC", "Servicing"] },
    { "id": "8", "name": "Fatima Bello", "trade": "Tiler", "location": "Abuja, FCT", "rating": 4.7, "reviewCount": 64, "hourlyRate": 5000, "image": "https://randomuser.me/api/portraits/women/8.jpg", "isAvailable": true, "tags": ["Floor Tiles", "Wall Tiles", "Bathroom"] },
    { "id": "9", "name": "Chukwudi Nwosu", "trade": "Plumber", "location": "Port Harcourt, Rivers", "rating": 4.3, "reviewCount": 29, "hourlyRate": 4000, "image": "https://randomuser.me/api/portraits/men/9.jpg", "isAvailable": true, "tags": ["Emergency Repairs", "Borehole"] },
    { "id": "10", "name": "Rukayat Suleiman", "trade": "Electrician", "location": "Kano, Kano", "rating": 4.6, "reviewCount": 47, "hourlyRate": 4500, "image": "https://randomuser.me/api/portraits/women/10.jpg", "isAvailable": true, "tags": ["Inverter", "Rewiring", "Maintenance"] },
  ];

  List<Map<String, dynamic>> get _filtered {
    return _artisans.where((a) {
      final q = _searchCtrl.text.toLowerCase();
      final matchSearch = q.isEmpty ||
          a['name'].toLowerCase().contains(q) ||
          a['trade'].toLowerCase().contains(q);
      final matchTrade = _selectedTrade == 'All' || a['trade'] == _selectedTrade;
      final matchLocation = _selectedLocation == 'All' || a['location'].contains(_selectedLocation);
      final matchRating = (a['rating'] as double) >= _minRating;
      final matchAvail = !_availableOnly || a['isAvailable'] == true;
      return matchSearch && matchTrade && matchLocation && matchRating && matchAvail;
    }).toList();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FilterSheet(
        selectedTrade: _selectedTrade,
        selectedLocation: _selectedLocation,
        minRating: _minRating,
        availableOnly: _availableOnly,
        trades: trades,
        locations: locations,
        onApply: ({
          required trade,
          required location,
          required minRating,
          required availableOnly,
        }) {
          setState(() {
            _selectedTrade = trade;
            _selectedLocation = location;
            _minRating = minRating;
            _availableOnly = availableOnly;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

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
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search Service or Artisan',
                      hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: const BorderSide(color: Colors.greenAccent),
                      ),
                      prefixIcon: const Icon(CupertinoIcons.search, color: Colors.black),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(CupertinoIcons.clear_circled_solid, size: 20, color: Colors.black),
                              onPressed: () => setState(() => _searchCtrl.clear()),
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white10,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _showFilterSheet,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: const Center(
                      child: Icon(Icons.tune_rounded, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Active filter chips
          if (_selectedTrade != 'All' || _selectedLocation != 'All' || _minRating > 0 || _availableOnly)
            Container(
              height: 40,
              color: Colors.white,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                children: [
                  if (_selectedTrade != 'All') _activeChip(_selectedTrade, () => setState(() => _selectedTrade = 'All')),
                  if (_selectedLocation != 'All') _activeChip(_selectedLocation, () => setState(() => _selectedLocation = 'All')),
                  if (_minRating > 0) _activeChip('⭐ ${_minRating.toStringAsFixed(1)}+', () => setState(() => _minRating = 0)),
                  if (_availableOnly) _activeChip('Available', () => setState(() => _availableOnly = false)),
                ],
              ),
            ),

          // Results count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${results.length} artisan${results.length != 1 ? "s" : ""} found',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: results.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: results.length + 1,
                    itemBuilder: (ctx, i) {
                      if (i == results.length) return _loadMoreButton();
                      return ArtisanCard(artisan: results[i]); // ← extracted widget
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
          label: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF1B5E20), fontWeight: FontWeight.w500)),
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
            const Text('None Found', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 4),
            Text('Try adjusting your filters', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ],
        ),
      );

  Widget _loadMoreButton() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.greenAccent, width: 3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () {},
            child: const Text('Load More', style: TextStyle(color: Colors.black)),
          ),
        ),
      );
}