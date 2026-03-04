import 'package:contraktor/features/artisan/domain/entities/artisan_detail.dart';
import 'package:flutter/material.dart';

class ReviewTile extends StatelessWidget {
  final Review review;
  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.greenAccent.shade100,
            child: Text(
              review.reviewer[0],
              style: TextStyle(
                color: Colors.greenAccent.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.reviewer,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      review.date,
                      style: TextStyle(color: Colors.grey[400], fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: i < review.rating
                          ? const Color(0xFFFBBC04)
                          : Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  review.comment,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
