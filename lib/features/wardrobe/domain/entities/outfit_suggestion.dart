class OutfitSuggestion {
  const OutfitSuggestion({
    required this.title,
    required this.itemIds,
    required this.reason,
  });

  final String title;
  final List<String> itemIds;
  final String reason;
}
