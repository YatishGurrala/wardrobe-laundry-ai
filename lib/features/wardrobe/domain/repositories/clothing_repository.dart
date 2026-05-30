import '../entities/clothing_item.dart';
import '../entities/laundry_status.dart';

abstract class ClothingRepository {
  Future<List<ClothingItem>> getItems();
  Future<ClothingItem?> getItemById(String id);
  Future<void> addItem(ClothingItem item);
  Future<void> updateItem(ClothingItem item);
  Future<void> updateLaundryStatus({
    required String itemId,
    required LaundryStatus status,
    DateTime? lastWorn,
    int? wearCount,
  });
}
