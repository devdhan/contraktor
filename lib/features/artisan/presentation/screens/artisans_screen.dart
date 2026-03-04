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

  // Mock data — replace with your provider later
  final List<Map<String, dynamic>> _artisans = [
    {
      "id": "1",
      "name": "Emeka Okafor",
      "trade": "Plumber",
      "location": "Lagos Island, Lagos",
      "rating": 4.8,
      "reviewCount": 124,
      "hourlyRate": 5000,
      "image": "https://randomuser.me/api/portraits/men/1.jpg",
      "isAvailable": true,
      "tags": ["Plumbing", "Pipe Fitting", "Water Heaters"],
    },
    {
      "id": "2",
      "name": "Chidinma Eze",
      "trade": "Electrician",
      "location": "Ikeja, Lagos",
      "rating": 4.9,
      "reviewCount": 89,
      "hourlyRate": 6000,
      "image": "https://randomuser.me/api/portraits/women/2.jpg",
      "isAvailable": true,
      "tags": ["Wiring", "Solar", "Installations"],
    },
    {
      "id": "3",
      "name": "Tunde Adeyemi",
      "trade": "Carpenter",
      "location": "Surulere, Lagos",
      "rating": 4.6,
      "reviewCount": 57,
      "hourlyRate": 4500,
      "image": "https://randomuser.me/api/portraits/men/3.jpg",
      "isAvailable": false,
      "tags": ["Furniture", "Cabinets", "Woodwork"],
    },
    {
      "id": "4",
      "name": "Ngozi Ibe",
      "trade": "Painter",
      "location": "Lekki, Lagos",
      "rating": 4.7,
      "reviewCount": 43,
      "hourlyRate": 3500,
      "image": "https://randomuser.me/api/portraits/women/4.jpg",
      "isAvailable": true,
      "tags": ["Interior", "Exterior", "Wallpaper"],
    },
    {
      "id": "5",
      "name": "Biodun Fashola",
      "trade": "Mason",
      "location": "Yaba, Lagos",
      "rating": 4.5,
      "reviewCount": 72,
      "hourlyRate": 5500,
      "image": "https://randomuser.me/api/portraits/men/5.jpg",
      "isAvailable": true,
      "tags": ["Bricklaying", "Plastering", "Tiling"],
    },
    {
      "id": "6",
      "name": "Amaka Obi",
      "trade": "Welder",
      "location": "Oshodi, Lagos",
      "rating": 4.4,
      "reviewCount": 38,
      "hourlyRate": 6500,
      "image": "https://randomuser.me/api/portraits/women/6.jpg",
      "isAvailable": true,
      "tags": ["Fabrication", "Gates", "Steel"],
    },
    {
      "id": "7",
      "name": "Seun Adesanya",
      "trade": "AC Technician",
      "location": "Victoria Island, Lagos",
      "rating": 4.9,
      "reviewCount": 101,
      "hourlyRate": 7000,
      "image": "https://randomuser.me/api/portraits/men/7.jpg",
      "isAvailable": false,
      "tags": ["AC Repair", "HVAC", "Servicing"],
    },
    {
      "id": "8",
      "name": "Fatima Bello",
      "trade": "Tiler",
      "location": "Abuja, FCT",
      "rating": 4.7,
      "reviewCount": 64,
      "hourlyRate": 5000,
      "image": "https://randomuser.me/api/portraits/women/8.jpg",
      "isAvailable": true,
      "tags": ["Floor Tiles", "Wall Tiles", "Bathroom"],
    },
    {
      "id": "9",
      "name": "Chukwudi Nwosu",
      "trade": "Plumber",
      "location": "Port Harcourt, Rivers",
      "rating": 4.3,
      "reviewCount": 29,
      "hourlyRate": 4000,
      "image": "https://randomuser.me/api/portraits/men/9.jpg",
      "isAvailable": true,
      "tags": ["Emergency Repairs", "Borehole"],
    },
    {
      "id": "10",
      "name": "Rukayat Suleiman",
      "trade": "Electrician",
      "location": "Kano, Kano",
      "rating": 4.6,
      "reviewCount": 47,
      "hourlyRate": 4500,
      "image": "https://randomuser.me/api/portraits/women/10.jpg",
      "isAvailable": true,
      "tags": ["Inverter", "Rewiring", "Maintenance"],
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    return _artisans.where((a) {
      final q = _searchCtrl.text.toLowerCase();
      final matchSearch =
          q.isEmpty ||
          a['name'].toLowerCase().contains(q) ||
          a['trade'].toLowerCase().contains(q);
      final matchTrade =
          _selectedTrade == 'All' || a['trade'] == _selectedTrade;
      final matchLocation =
          _selectedLocation == 'All' ||
          a['location'].contains(_selectedLocation);
      final matchRating = (a['rating'] as double) >= _minRating;
      final matchAvail = !_availableOnly || a['isAvailable'] == true;
      return matchSearch &&
          matchTrade &&
          matchLocation &&
          matchRating &&
          matchAvail;
    }).toList();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Trade
              const Text(
                'Trade',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: trades
                    .map(
                      (t) => ChoiceChip(
                        label: Text(t),
                        selected: _selectedTrade == t,
                        selectedColor: Colors.greenAccent,
                        labelStyle: TextStyle(
                          color: _selectedTrade == t
                              ? Colors.black
                              : Colors.black87,
                          fontSize: 12,
                        ),
                        onSelected: (_) => setSheet(() => _selectedTrade = t),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Location
              const Text(
                'Location',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: locations
                    .map(
                      (l) => ChoiceChip(
                        label: Text(l),
                        selected: _selectedLocation == l,
                        selectedColor: Colors.greenAccent,
                        labelStyle: TextStyle(
                          color: _selectedLocation == l
                              ? Colors.black
                              : Colors.black87,
                          fontSize: 12,
                        ),
                        onSelected: (_) =>
                            setSheet(() => _selectedLocation = l),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Min Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Minimum Rating',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  Row(
                    children: [
                      Text(
                        _minRating.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.black),
                      ),
                      Icon(
                        Icons.star_rounded,
                        size: 20,
                        color: Color(0xFFFBBC04),
                      ),
                    ],
                  ),
                ],
              ),
              Slider(
                value: _minRating,
                min: 0,
                max: 5,
                divisions: 10,
                activeColor: Colors.greenAccent,
                onChanged: (v) => setSheet(() => _minRating = v),
              ),
              const SizedBox(height: 8),

              // Available only
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Available Only',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                value: _availableOnly,
                activeColor: const Color(0xFF22C55E),
                onChanged: (v) => setSheet(() => _availableOnly = v),
              ),
              const SizedBox(height: 8),

              // Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.tune_rounded, color: Colors.grey),
        //     onPressed: _showFilterSheet,
        //   ),
        // ],
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
                      hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: BorderSide(color: Colors.greenAccent),
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
                              onPressed: () =>
                                  setState(() => _searchCtrl.clear()),
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
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _showFilterSheet,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Center(
                        child: Icon(Icons.tune_rounded, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Active filter chips
          if (_selectedTrade != 'All' ||
              _selectedLocation != 'All' ||
              _minRating > 0 ||
              _availableOnly)
            Container(
              height: 40,
              color: Colors.white,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                children: [
                  if (_selectedTrade != 'All')
                    _activeChip(
                      _selectedTrade,
                      () => setState(() => _selectedTrade = 'All'),
                    ),
                  if (_selectedLocation != 'All')
                    _activeChip(
                      _selectedLocation,
                      () => setState(() => _selectedLocation = 'All'),
                    ),
                  if (_minRating > 0)
                    _activeChip(
                      '⭐ ${_minRating.toStringAsFixed(1)}+',
                      () => setState(() => _minRating = 0),
                    ),
                  if (_availableOnly)
                    _activeChip(
                      'Available',
                      () => setState(() => _availableOnly = false),
                    ),
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
                    itemCount: results.length + 1, // +1 for load more
                    itemBuilder: (ctx, i) {
                      if (i == results.length) return _loadMoreButton();
                      return _ArtisanCard(artisan: results[i]);
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

  Widget _loadMoreButton() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Center(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.greenAccent, width: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        onPressed: () {}, // wire up pagination here
        child: const Text('Load More', style: TextStyle(color: Colors.black)),
      ),
    ),
  );
}

class _ArtisanCard extends StatelessWidget {
  final Map<String, dynamic> artisan;
  const _ArtisanCard({required this.artisan});

  @override
  Widget build(BuildContext context) {
    final bool available = artisan['isAvailable'] as bool;
    //final tags = (artisan['tags'] as List).cast<String>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {}, // navigate to profile
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + availability dot
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(artisan['image']),
                    backgroundColor: Colors.grey[200],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: available
                            ? const Color(0xFF22C55E)
                            : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          artisan['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '₦${(artisan['hourlyRate'] as int).toString()}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '/hr',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        artisan['trade'],
                        style: const TextStyle(
                          color: Color(0xFF1B5E20),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  artisan['location'],
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 20,
                              color: Color(0xFFFBBC04),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${artisan['rating']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '(${artisan['reviewCount']} reviews)',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
