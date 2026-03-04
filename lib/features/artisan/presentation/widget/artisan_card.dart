import 'package:contraktor/features/artisan/domain/entities/artisan.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ArtisanCard extends StatelessWidget {
  final Artisan artisan;
  const ArtisanCard({super.key, required this.artisan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => context.push('/artisan-profile/${artisan.id}'),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(artisan.image),
                    backgroundColor: Colors.grey[200],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: artisan.isAvailable
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          artisan.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '₦${artisan.hourlyRate}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            const Text(
                              '/hr',
                              style: TextStyle(
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
                        artisan.trade,
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
                                  artisan.location,
                                  style: TextStyle(
                                    color: Colors.grey[500],
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
                              '${artisan.rating}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '(${artisan.reviewCount} reviews)',
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
