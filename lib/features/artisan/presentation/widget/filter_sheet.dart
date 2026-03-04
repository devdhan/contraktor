import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final String selectedTrade;
  final String selectedLocation;
  final double minRating;
  final bool availableOnly;
  final List<String> trades;
  final List<String> locations;
  final void Function({
    required String trade,
    required String location,
    required double minRating,
    required bool availableOnly,
  })
  onApply;

  const FilterSheet({
    super.key,
    required this.selectedTrade,
    required this.selectedLocation,
    required this.minRating,
    required this.availableOnly,
    required this.trades,
    required this.locations,
    required this.onApply,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String _trade;
  late String _location;
  late double _minRating;
  late bool _availableOnly;

  @override
  void initState() {
    super.initState();
    _trade = widget.selectedTrade;
    _location = widget.selectedLocation;
    _minRating = widget.minRating;
    _availableOnly = widget.availableOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const Center(
            child: Text(
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
            children: widget.trades
                .map(
                  (t) => ChoiceChip(
                    label: Text(t),
                    selected: _trade == t,
                    selectedColor: Colors.greenAccent,
                    labelStyle: TextStyle(
                      color: _trade == t ? Colors.black : Colors.black87,
                      fontSize: 12,
                    ),
                    onSelected: (_) => setState(() => _trade = t),
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
            children: widget.locations
                .map(
                  (l) => ChoiceChip(
                    label: Text(l),
                    selected: _location == l,
                    selectedColor: Colors.greenAccent,
                    labelStyle: TextStyle(
                      color: _location == l ? Colors.black : Colors.black87,
                      fontSize: 12,
                    ),
                    onSelected: (_) => setState(() => _location = l),
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
                  const Icon(
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
            onChanged: (v) => setState(() => _minRating = v),
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
            onChanged: (v) => setState(() => _availableOnly = v),
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
                widget.onApply(
                  trade: _trade,
                  location: _location,
                  minRating: _minRating,
                  availableOnly: _availableOnly,
                );
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
    );
  }
}
