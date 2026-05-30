import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/mock_clothing_data_source.dart';
import '../../data/repositories/mock_clothing_repository.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/laundry_status.dart';
import '../../domain/entities/wardrobe_stats.dart';
import '../../domain/repositories/clothing_repository.dart';
import '../../domain/usecases/add_clothing_item_use_case.dart';
import '../../domain/usecases/get_clothing_items_use_case.dart';
import '../../domain/usecases/update_laundry_status_use_case.dart';

final mockClothingDataSourceProvider = Provider<MockClothingDataSource>(
  (ref) => MockClothingDataSource(),
);

final clothingRepositoryProvider = Provider<ClothingRepository>(
  (ref) => MockClothingRepository(ref.watch(mockClothingDataSourceProvider)),
);

final getClothingItemsUseCaseProvider = Provider<GetClothingItemsUseCase>(
  (ref) => GetClothingItemsUseCase(ref.watch(clothingRepositoryProvider)),
);

final addClothingItemUseCaseProvider = Provider<AddClothingItemUseCase>(
  (ref) => AddClothingItemUseCase(ref.watch(clothingRepositoryProvider)),
);

final updateLaundryStatusUseCaseProvider = Provider<UpdateLaundryStatusUseCase>(
  (ref) => UpdateLaundryStatusUseCase(ref.watch(clothingRepositoryProvider)),
);

class ClothingItemsNotifier extends StateNotifier<List<ClothingItem>> {
  ClothingItemsNotifier(
    this._getItems,
    this._addItem,
    this._updateLaundryStatus,
  ) : super(const []) {
    _load();
  }

  final GetClothingItemsUseCase _getItems;
  final AddClothingItemUseCase _addItem;
  final UpdateLaundryStatusUseCase _updateLaundryStatus;

  Future<void> _load() async {
    state = await _getItems();
  }

  Future<void> addItem(ClothingItem item) async {
    await _addItem(item);
    await _load();
  }

  Future<void> markAsWorn(String itemId) async {
    final existing = state.firstWhere((item) => item.id == itemId);
    await _updateLaundryStatus(
      itemId: itemId,
      status: LaundryStatus.worn,
      lastWorn: DateTime.now(),
      wearCount: existing.wearCount + 1,
    );
    await _load();
  }

  Future<void> moveToLaundry(String itemId) async {
    await _updateLaundryStatus(itemId: itemId, status: LaundryStatus.inLaundry);
    await _load();
  }

  Future<void> markAsWashed(String itemId) async {
    await _updateLaundryStatus(itemId: itemId, status: LaundryStatus.washed);
    await _load();
  }

  Future<void> markAsClean(String itemId) async {
    await _updateLaundryStatus(itemId: itemId, status: LaundryStatus.clean);
    await _load();
  }
}

final clothingItemsProvider =
    StateNotifierProvider<ClothingItemsNotifier, List<ClothingItem>>(
      (ref) => ClothingItemsNotifier(
        ref.watch(getClothingItemsUseCaseProvider),
        ref.watch(addClothingItemUseCaseProvider),
        ref.watch(updateLaundryStatusUseCaseProvider),
      ),
    );

final wardrobeStatsProvider = Provider<WardrobeStats>((ref) {
  final items = ref.watch(clothingItemsProvider);
  final needsWash = items
      .where((item) => item.laundryStatus == LaundryStatus.worn)
      .length;
  final recent = items.where((item) {
    if (item.lastWorn == null) {
      return false;
    }
    return DateTime.now().difference(item.lastWorn!).inDays <= 7;
  }).length;
  final clean = items
      .where((item) => item.laundryStatus == LaundryStatus.clean)
      .length;

  return WardrobeStats(
    totalItems: items.length,
    needsWash: needsWash,
    recentlyWorn: recent,
    cleanItems: clean,
  );
});

final laundryItemsProvider = Provider<Map<LaundryStatus, List<ClothingItem>>>((
  ref,
) {
  final items = ref.watch(clothingItemsProvider);
  return {
    LaundryStatus.clean: items
        .where((item) => item.laundryStatus == LaundryStatus.clean)
        .toList(),
    LaundryStatus.worn: items
        .where((item) => item.laundryStatus == LaundryStatus.worn)
        .toList(),
    LaundryStatus.inLaundry: items
        .where((item) => item.laundryStatus == LaundryStatus.inLaundry)
        .toList(),
    LaundryStatus.washed: items
        .where((item) => item.laundryStatus == LaundryStatus.washed)
        .toList(),
  };
});
