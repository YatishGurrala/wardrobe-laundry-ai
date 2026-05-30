import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/laundry_status.dart';
import '../../domain/repositories/clothing_repository.dart';
import '../datasources/mock_clothing_data_source.dart';

class MockClothingRepository implements ClothingRepository {
  MockClothingRepository(MockClothingDataSource dataSource)
    : _items = List<ClothingItem>.from(dataSource.seedItems());

  final List<ClothingItem> _items;

  @override
  Future<void> addItem(ClothingItem item) async {
    _items.insert(0, item);
  }

  @override
  Future<ClothingItem?> getItemById(String id) async {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<List<ClothingItem>> getItems() async {
    return List<ClothingItem>.unmodifiable(_items);
  }

  @override
  Future<void> updateItem(ClothingItem item) async {
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> updateLaundryStatus({
    required String itemId,
    required LaundryStatus status,
    DateTime? lastWorn,
    int? wearCount,
  }) async {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index == -1) {
      return;
    }

    final updated = _items[index].copyWith(
      laundryStatus: status,
      lastWorn: lastWorn,
      wearCount: wearCount,
    );
    _items[index] = updated;
  }
}
