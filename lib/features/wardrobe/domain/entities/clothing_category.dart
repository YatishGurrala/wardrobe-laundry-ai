enum ClothingCategory {
  tops,
  bottoms,
  outerwear,
  shoes,
  accessories;

  String get label => switch (this) {
    ClothingCategory.tops => 'Tops',
    ClothingCategory.bottoms => 'Bottoms',
    ClothingCategory.outerwear => 'Outerwear',
    ClothingCategory.shoes => 'Shoes',
    ClothingCategory.accessories => 'Accessories',
  };
}
