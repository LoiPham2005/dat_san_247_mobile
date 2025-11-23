import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/features/my_booking/data/models/amenities.dart';

class VenueAmenitiesCard extends StatelessWidget {
  final List<Amenities> amenities;

  const VenueAmenitiesCard({
    super.key,
    required this.amenities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.sports_soccer,
                  color: Colors.purple[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Tiện ích",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: amenities.map((amenity) {
              final isAvailable = amenity.available == true;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isAvailable ? Colors.green[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isAvailable ? Colors.green[200]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAvailable ? Icons.check_circle : Icons.cancel,
                      color: isAvailable ? Colors.green[600] : Colors.grey[500],
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      amenity.name ?? "",
                      style: TextStyle(
                        color: isAvailable ? Colors.green[700] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}