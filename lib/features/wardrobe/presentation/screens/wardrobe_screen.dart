import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/clothing_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/clothing_category.dart';
import '../../domain/entities/laundry_status.dart';
import '../viewmodels/wardrobe_view_model.dart';

class WardrobeScreen extends ConsumerWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(wardrobeViewModelProvider);
    final viewModel = ref.read(wardrobeViewModelProvider.notifier);
    final items = ref.watch(filteredWardrobeItemsProvider);

    return ListView(
      children: [
        const SizedBox(height: 20),
        const SectionHeader(
          title: 'Wardrobe',
          subtitle: 'Filter by category and laundry status.',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<ClothingCategory?>(
                initialValue: filters.category,
                dropdownColor: const Color(0xFF1D1F22),
                decoration: const InputDecoration(labelText: 'Category'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('All Categories'),
                  ),
                  ...ClothingCategory.values.map(
                    (cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat.label)),
                  ),
                ],
                onChanged: viewModel.selectCategory,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<LaundryStatus?>(
                initialValue: filters.status,
                dropdownColor: const Color(0xFF1D1F22),
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('All Statuses'),
                  ),
                  ...LaundryStatus.values.map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    ),
                  ),
                ],
                onChanged: viewModel.selectStatus,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: viewModel.toggleLayout,
              icon: Icon(filters.isGrid ? Icons.view_list : Icons.grid_view),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (filters.isGrid)
          GridView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return ClothingCard(
                item: item,
                onTap: () => context.push('/wardrobe/item/${item.id}'),
              );
            },
          )
        else
          Column(
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ClothingCard(
                      item: item,
                      onTap: () => context.push('/wardrobe/item/${item.id}'),
                    ),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
