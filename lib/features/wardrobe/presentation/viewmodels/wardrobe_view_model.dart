import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/clothing_category.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/laundry_status.dart';
import '../providers/clothing_providers.dart';

class WardrobeFilterState {
  const WardrobeFilterState({this.category, this.status, this.isGrid = true});

  final ClothingCategory? category;
  final LaundryStatus? status;
  final bool isGrid;

  WardrobeFilterState copyWith({
    ClothingCategory? category,
    LaundryStatus? status,
    bool? isGrid,
    bool clearCategory = false,
    bool clearStatus = false,
  }) {
    return WardrobeFilterState(
      category: clearCategory ? null : (category ?? this.category),
      status: clearStatus ? null : (status ?? this.status),
      isGrid: isGrid ?? this.isGrid,
    );
  }
}

class WardrobeViewModel extends StateNotifier<WardrobeFilterState> {
  WardrobeViewModel() : super(const WardrobeFilterState());

  void selectCategory(ClothingCategory? category) {
    state = category == null
        ? state.copyWith(clearCategory: true)
        : state.copyWith(category: category);
  }

  void selectStatus(LaundryStatus? status) {
    state = status == null
        ? state.copyWith(clearStatus: true)
        : state.copyWith(status: status);
  }

  void toggleLayout() {
    state = state.copyWith(isGrid: !state.isGrid);
  }
}

final wardrobeViewModelProvider =
    StateNotifierProvider<WardrobeViewModel, WardrobeFilterState>(
      (ref) => WardrobeViewModel(),
    );

final filteredWardrobeItemsProvider = Provider<List<ClothingItem>>((ref) {
  final filters = ref.watch(wardrobeViewModelProvider);
  final items = ref.watch(clothingItemsProvider);

  return items.where((item) {
    final categoryMatch =
        filters.category == null || item.category == filters.category;
    final statusMatch =
        filters.status == null || item.laundryStatus == filters.status;
    return categoryMatch && statusMatch;
  }).toList();
});
