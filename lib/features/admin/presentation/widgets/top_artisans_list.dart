import 'package:flutter/material.dart';
import '../../domain/entities/analytics_entities.dart';

class TopArtisansList extends StatelessWidget {
  final List<TopArtisan> artisans;
  const TopArtisansList({super.key, required this.artisans});

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
        children: artisans.asMap().entries.map((e) {
          final i = e.key;
          final a = e.value;

          return Column(
            children: [
              Row(
                children: [
                  // Rank badge
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
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: a.image.isNotEmpty
                        ? NetworkImage(a.image)
                        : null,
                    child: a.image.isEmpty
                        ? Text(
                            a.name[0],
                            style: TextStyle(
                              color: Colors.greenAccent.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          a.trade,
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
                        '${a.requestCount} jobs',
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
                            '${a.rating}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (i < artisans.length - 1)
                const Divider(height: 16, indent: 34),
            ],
          );
        }).toList(),
      ),
    );
  }
}
