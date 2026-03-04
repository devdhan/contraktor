import 'package:flutter/material.dart';

class PeriodSelector extends StatefulWidget {
  final void Function(int index, String period)? onChanged;
  const PeriodSelector({super.key, this.onChanged});

  @override
  State<PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
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
              onTap: () {
                setState(() => _selected = e.key);
                widget.onChanged?.call(e.key, e.value);
              },
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
