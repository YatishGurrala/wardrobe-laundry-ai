import '../models/clothing_item_model.dart';
import '../../domain/entities/clothing_category.dart';
import '../../domain/entities/laundry_status.dart';

class MockClothingDataSource {
  List<ClothingItemModel> seedItems() {
    return [
      ClothingItemModel(
        id: '1',
        name: 'Black Linen Shirt',
        category: ClothingCategory.tops,
        color: 'Black',
        season: 'All-season',
        laundryPreference: 'Cold wash, hang dry',
        laundryStatus: LaundryStatus.clean,
        wearCount: 5,
        lastWorn: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ClothingItemModel(
        id: '2',
        name: 'Beige Tailored Trousers',
        category: ClothingCategory.bottoms,
        color: 'Beige',
        season: 'Spring',
        laundryPreference: 'Gentle machine wash',
        laundryStatus: LaundryStatus.worn,
        wearCount: 3,
        lastWorn: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ClothingItemModel(
        id: '3',
        name: 'Lavender Overshirt',
        category: ClothingCategory.outerwear,
        color: 'Lavender',
        season: 'Fall',
        laundryPreference: 'Dry clean only',
        laundryStatus: LaundryStatus.inLaundry,
        wearCount: 7,
        lastWorn: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ClothingItemModel(
        id: '4',
        name: 'White Leather Sneakers',
        category: ClothingCategory.shoes,
        color: 'White',
        season: 'All-season',
        laundryPreference: 'Spot clean',
        laundryStatus: LaundryStatus.washed,
        wearCount: 10,
        lastWorn: DateTime.now().subtract(const Duration(days: 4)),
      ),
      ClothingItemModel(
        id: '5',
        name: 'Wool Blend Scarf',
        category: ClothingCategory.accessories,
        color: 'Charcoal',
        season: 'Winter',
        laundryPreference: 'Hand wash',
        laundryStatus: LaundryStatus.clean,
        wearCount: 2,
        lastWorn: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}
