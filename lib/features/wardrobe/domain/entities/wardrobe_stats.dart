class WardrobeStats {
  const WardrobeStats({
    required this.totalItems,
    required this.needsWash,
    required this.recentlyWorn,
    required this.cleanItems,
  });

  final int totalItems;
  final int needsWash;
  final int recentlyWorn;
  final int cleanItems;
}
