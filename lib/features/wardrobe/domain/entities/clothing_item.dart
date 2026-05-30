import 'clothing_category.dart';
import 'laundry_status.dart';

class ClothingItem {
  const ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.season,
    required this.laundryPreference,
    required this.laundryStatus,
    required this.wearCount,
    this.lastWorn,
    this.imageUrl,
  });

  final String id;
  final String name;
  final ClothingCategory category;
  final String color;
  final String season;
  final String laundryPreference;
  final LaundryStatus laundryStatus;
  final int wearCount;
  final DateTime? lastWorn;
  final String? imageUrl;

  ClothingItem copyWith({
    String? id,
    String? name,
    ClothingCategory? category,
    String? color,
    String? season,
    String? laundryPreference,
    LaundryStatus? laundryStatus,
    int? wearCount,
    DateTime? lastWorn,
    String? imageUrl,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      color: color ?? this.color,
      season: season ?? this.season,
      laundryPreference: laundryPreference ?? this.laundryPreference,
      laundryStatus: laundryStatus ?? this.laundryStatus,
      wearCount: wearCount ?? this.wearCount,
      lastWorn: lastWorn ?? this.lastWorn,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
