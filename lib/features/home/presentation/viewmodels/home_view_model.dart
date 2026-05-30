import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wardrobe/domain/entities/clothing_item.dart';
import '../../../wardrobe/domain/entities/laundry_status.dart';
import '../../../wardrobe/presentation/providers/clothing_providers.dart';

class HomeDashboardState {
  const HomeDashboardState({
    required this.todaysSummary,
    required this.itemsNeedingWash,
    required this.recentlyWorn,
    required this.quickActions,
  });

  final String todaysSummary;
  final List<ClothingItem> itemsNeedingWash;
  final List<ClothingItem> recentlyWorn;
  final List<String> quickActions;
}

final homeViewModelProvider = Provider<HomeDashboardState>((ref) {
  final items = ref.watch(clothingItemsProvider);
  final needingWash = items
      .where((item) => item.laundryStatus == LaundryStatus.worn)
      .take(4)
      .toList();
  final recentlyWorn = items.where((item) => item.lastWorn != null).toList()
    ..sort((a, b) => b.lastWorn!.compareTo(a.lastWorn!));

  return HomeDashboardState(
    todaysSummary:
        'You have ${items.length} curated wardrobe items ready to style.',
    itemsNeedingWash: needingWash,
    recentlyWorn: recentlyWorn.take(4).toList(),
    quickActions: const [
      'Build outfit',
      'Add item',
      'Plan laundry',
      'Review profile',
    ],
  );
});
