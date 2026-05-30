import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/laundry_status_chip.dart';
import '../../../../core/widgets/primary_button.dart';
import '../viewmodels/clothing_detail_view_model.dart';

class ClothingDetailScreen extends ConsumerWidget {
  const ClothingDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(clothingItemByIdProvider(itemId));
    final viewModel = ref.read(clothingDetailViewModelProvider);

    if (item == null) {
      return const Center(child: Text('Item not found'));
    }

    return ListView(
      children: [
        const SizedBox(height: 20),
        Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white10,
                ),
                child: const Icon(Icons.checkroom, size: 48),
              ),
              const SizedBox(height: 16),
              Text('Wear Count: ${item.wearCount}'),
              const SizedBox(height: 6),
              Text(
                'Last Worn: ${item.lastWorn == null ? 'Never' : DateFormat.yMMMd().format(item.lastWorn!)}',
              ),
              const SizedBox(height: 10),
              LaundryStatusChip(status: item.laundryStatus),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Mark as Worn',
                onPressed: () => viewModel.markAsWorn(item.id),
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                label: 'Move to Laundry',
                onPressed: () => viewModel.moveToLaundry(item.id),
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                label: 'Mark as Washed',
                onPressed: () => viewModel.markAsWashed(item.id),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
