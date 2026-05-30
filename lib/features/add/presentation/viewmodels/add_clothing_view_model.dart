import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wardrobe/domain/entities/clothing_category.dart';
import '../../../wardrobe/domain/entities/clothing_item.dart';
import '../../../wardrobe/domain/entities/laundry_status.dart';
import '../../../wardrobe/presentation/providers/clothing_providers.dart';

class AddClothingViewModel {
  AddClothingViewModel(this._ref);

  final Ref _ref;

  Future<void> saveItem({
    required String name,
    required ClothingCategory category,
    required String color,
    required String season,
    required String laundryPreference,
  }) async {
    final item = ClothingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      color: color,
      season: season,
      laundryPreference: laundryPreference,
      laundryStatus: LaundryStatus.clean,
      wearCount: 0,
      lastWorn: null,
    );

    await _ref.read(clothingItemsProvider.notifier).addItem(item);
  }
}

final addClothingViewModelProvider = Provider<AddClothingViewModel>(
  (ref) => AddClothingViewModel(ref),
);
