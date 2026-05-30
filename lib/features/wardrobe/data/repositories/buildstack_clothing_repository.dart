import '../../../../core/backend/buildstack_api_client.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/laundry_status.dart';
import '../../domain/repositories/clothing_repository.dart';
import '../models/clothing_item_model.dart';

class BuildstackClothingRepository implements ClothingRepository {
  BuildstackClothingRepository(
    this._apiClient, {
    required String ownerId,
    this.collection = 'wardrobe_items',
  }) : _ownerId = ownerId;

  final BuildstackApiClient _apiClient;
  final String collection;
  final String _ownerId;
  final Map<String, String> _recordIdByItemId = <String, String>{};

  @override
  Future<void> addItem(ClothingItem item) async {
    final payload = await _apiClient.createRecord(
      collection: collection,
      ownerId: _ownerId,
      data: _toModel(item).toJson(),
    );

    final record = _extractRecord(payload);
    final recordId = _readRecordId(record);
    if (recordId != null && recordId.isNotEmpty) {
      _recordIdByItemId[item.id] = recordId;
    }
  }

  @override
  Future<ClothingItem?> getItemById(String id) async {
    final items = await getItems();
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<List<ClothingItem>> getItems() async {
    final records = await _apiClient.listRecords(
      collection: collection,
      ownerId: _ownerId,
    );

    final items = <ClothingItem>[];
    for (final record in records) {
      final recordId = _readRecordId(record);
      final data = _extractItemData(record, fallbackId: recordId);
      if (data == null) {
        continue;
      }

      try {
        final model = ClothingItemModel.fromJson(data);
        items.add(model);
        if (recordId != null && recordId.isNotEmpty) {
          _recordIdByItemId[model.id] = recordId;
        }
      } catch (_) {
        continue;
      }
    }

    return items;
  }

  @override
  Future<void> updateItem(ClothingItem item) async {
    final existingRecordId = await _resolveRecordId(item.id);
    if (existingRecordId == null || existingRecordId.isEmpty) {
      await addItem(item);
      return;
    }

    await _apiClient.updateRecord(
      recordId: existingRecordId,
      collection: collection,
      ownerId: _ownerId,
      data: _toModel(item).toJson(),
    );
  }

  @override
  Future<void> updateLaundryStatus({
    required String itemId,
    required LaundryStatus status,
    DateTime? lastWorn,
    int? wearCount,
  }) async {
    final existing = await getItemById(itemId);
    if (existing == null) {
      return;
    }

    final updated = existing.copyWith(
      laundryStatus: status,
      lastWorn: lastWorn,
      wearCount: wearCount,
    );

    await updateItem(updated);
  }

  ClothingItemModel _toModel(ClothingItem item) {
    return ClothingItemModel(
      id: item.id,
      name: item.name,
      category: item.category,
      color: item.color,
      season: item.season,
      laundryPreference: item.laundryPreference,
      laundryStatus: item.laundryStatus,
      wearCount: item.wearCount,
      lastWorn: item.lastWorn,
      imageUrl: item.imageUrl,
    );
  }

  Future<String?> _resolveRecordId(String itemId) async {
    final mapped = _recordIdByItemId[itemId];
    if (mapped != null && mapped.isNotEmpty) {
      return mapped;
    }

    await getItems();
    return _recordIdByItemId[itemId];
  }

  Map<String, dynamic> _extractRecord(Map<String, dynamic> payload) {
    final data = payload['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return payload;
  }

  String? _readRecordId(Map<String, dynamic> record) {
    final id = record['id'] ?? record['recordId'];
    if (id == null) {
      return null;
    }
    return id.toString();
  }

  Map<String, dynamic>? _extractItemData(
    Map<String, dynamic> record, {
    String? fallbackId,
  }) {
    final rawData = record['data'];
    Map<String, dynamic>? data;

    if (rawData is Map<String, dynamic>) {
      data = Map<String, dynamic>.from(rawData);
    } else if (rawData is Map) {
      data = Map<String, dynamic>.from(rawData);
    } else if (record.containsKey('name')) {
      data = Map<String, dynamic>.from(record);
    }

    if (data == null) {
      return null;
    }

    final parsedId = data['id'];
    if (parsedId == null || parsedId.toString().isEmpty) {
      data['id'] =
          fallbackId ?? DateTime.now().millisecondsSinceEpoch.toString();
    }

    return data;
  }
}
