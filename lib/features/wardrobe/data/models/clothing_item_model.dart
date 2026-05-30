import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/clothing_category.dart';
import '../../domain/entities/laundry_status.dart';

class ClothingItemModel extends ClothingItem {
  const ClothingItemModel({
    required super.id,
    required super.name,
    required super.category,
    required super.color,
    required super.season,
    required super.laundryPreference,
    required super.laundryStatus,
    required super.wearCount,
    super.lastWorn,
    super.imageUrl,
  });

  factory ClothingItemModel.fromJson(Map<String, dynamic> json) {
    return ClothingItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: ClothingCategory.values.byName(json['category'] as String),
      color: json['color'] as String,
      season: json['season'] as String,
      laundryPreference: json['laundryPreference'] as String,
      laundryStatus: LaundryStatus.values.byName(
        json['laundryStatus'] as String,
      ),
      wearCount: json['wearCount'] as int,
      lastWorn: json['lastWorn'] == null
          ? null
          : DateTime.parse(json['lastWorn'] as String),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'color': color,
      'season': season,
      'laundryPreference': laundryPreference,
      'laundryStatus': laundryStatus.name,
      'wearCount': wearCount,
      'lastWorn': lastWorn?.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}
