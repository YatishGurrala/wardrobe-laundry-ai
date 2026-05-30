import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../wardrobe/domain/entities/laundry_status.dart';
import '../../../wardrobe/presentation/providers/clothing_providers.dart';

class LaundryScreen extends ConsumerWidget {
  const LaundryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = ref.watch(laundryItemsProvider);

    Widget buildStatus(LaundryStatus status) {
      final items = grouped[status] ?? [];
      return GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${status.label} (${items.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(item.name),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        const SizedBox(height: 20),
        const SectionHeader(
          title: 'Laundry',
          subtitle: 'Track every item from clean to washed.',
        ),
        const SizedBox(height: 16),
        buildStatus(LaundryStatus.clean),
        const SizedBox(height: 12),
        buildStatus(LaundryStatus.worn),
        const SizedBox(height: 12),
        buildStatus(LaundryStatus.inLaundry),
        const SizedBox(height: 12),
        buildStatus(LaundryStatus.washed),
        const SizedBox(height: 16),
        const GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Smart Reminders'),
              SizedBox(height: 8),
              Text(
                '• Wash worn items tonight to keep your weekly rotation ready.',
              ),
              Text('• Air-dry delicate fabrics to preserve color and fit.'),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
