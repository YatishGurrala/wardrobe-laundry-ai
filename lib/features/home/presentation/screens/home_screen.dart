import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../wardrobe/presentation/providers/clothing_providers.dart';
import '../viewmodels/home_view_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final stats = ref.watch(wardrobeStatsProvider);

    return ListView(
      children: [
        const SizedBox(height: 20),
        const SectionHeader(
          title: 'Wardrobe Laundry AI',
          subtitle: 'Quiet Intelligence for your daily style and care.',
        ),
        const SizedBox(height: 20),
        Text(state.todaysSummary),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Total Items',
                value: '${stats.totalItems}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(title: 'Needs Wash', value: '${stats.needsWash}'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: state.quickActions
              .map((label) => PrimaryButton(label: label, onPressed: () {}))
              .toList(),
        ),
        const SizedBox(height: 20),
        SectionHeader(
          title: 'Items Needing Wash (${state.itemsNeedingWash.length})',
        ),
        const SizedBox(height: 12),
        ...state.itemsNeedingWash.map(
          (item) => ListTile(title: Text(item.name)),
        ),
        const SizedBox(height: 16),
        SectionHeader(title: 'Recently Worn (${state.recentlyWorn.length})'),
        const SizedBox(height: 12),
        ...state.recentlyWorn.map((item) => ListTile(title: Text(item.name))),
        const SizedBox(height: 24),
      ],
    );
  }
}
