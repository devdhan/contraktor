import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/analytics_entities.dart';

class RequestsBarChart extends StatefulWidget {
  final List<RequestByDay> data;
  const RequestsBarChart({super.key, required this.data});

  @override
  State<RequestsBarChart> createState() => _RequestsBarChartState();
}

class _RequestsBarChartState extends State<RequestsBarChart> {
  int _touchedIndex = -1;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Legend
          Row(
            children: [
              _dot(Colors.greenAccent.shade700),
              const SizedBox(width: 4),
              const Text(
                'Total',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              _dot(Colors.green.shade300),
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
                    getTooltipItem: (group, _, rod, __) {
                      final day = widget.data[group.x].day;
                      return BarTooltipItem(
                        '$day\n${rod.toY.toInt()}',
                        const TextStyle(color: Colors.white, fontSize: 12),
                      );
                    },
                  ),
                  touchCallback: (_, response) {
                    setState(
                      () => _touchedIndex =
                          response?.spot?.touchedBarGroupIndex ?? -1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) => Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          widget.data[value.toInt()].day,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, _) => Text(
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
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: widget.data.asMap().entries.map((e) {
                  final touched = e.key == _touchedIndex;
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.requests.toDouble(),
                        color: touched
                            ? Colors.greenAccent.shade700
                            : Colors.greenAccent.shade700.withOpacity(0.7),
                        width: 10,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: e.value.completed.toDouble(),
                        color: touched
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
    );
  }

  Widget _dot(Color color) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
