import 'package:flutter/material.dart';

import '../../features/wardrobe/domain/entities/clothing_item.dart';
import 'glass_card.dart';
import 'laundry_status_chip.dart';

class ClothingCard extends StatelessWidget {
  const ClothingCard({super.key, required this.item, this.onTap});

  final ClothingItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2B2D31), Color(0xFF1A1C1F)],
                ),
              ),
              child: const Center(child: Icon(Icons.image_outlined, size: 32)),
            ),
            const SizedBox(height: 12),
            Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              item.category.label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            LaundryStatusChip(status: item.laundryStatus),
          ],
        ),
      ),
    );
  }
}
