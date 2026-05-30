import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wardrobe/domain/entities/clothing_item.dart';
import '../../../wardrobe/presentation/providers/clothing_providers.dart';

final clothingItemByIdProvider = Provider.family<ClothingItem?, String>((
  ref,
  id,
) {
  final items = ref.watch(clothingItemsProvider);
  for (final item in items) {
    if (item.id == id) {
      return item;
    }
  }
  return null;
});

class ClothingDetailViewModel {
  ClothingDetailViewModel(this._ref);

  final Ref _ref;

  Future<void> markAsWorn(String id) =>
      _ref.read(clothingItemsProvider.notifier).markAsWorn(id);

  Future<void> moveToLaundry(String id) =>
      _ref.read(clothingItemsProvider.notifier).moveToLaundry(id);

  Future<void> markAsWashed(String id) =>
      _ref.read(clothingItemsProvider.notifier).markAsWashed(id);
}

final clothingDetailViewModelProvider = Provider<ClothingDetailViewModel>(
  (ref) => ClothingDetailViewModel(ref),
);
