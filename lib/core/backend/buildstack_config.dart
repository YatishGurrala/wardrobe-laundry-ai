class BuildstackConfig {
  const BuildstackConfig({
    required this.baseUrl,
    required this.projectKey,
    required this.apiKey,
    required this.ownerId,
  });

  const BuildstackConfig.fromEnvironment()
    : baseUrl = const String.fromEnvironment(
        'BUILDSTACK_BASE_URL',
        defaultValue: 'https://stack.builddeck.io',
      ),
      projectKey = const String.fromEnvironment('BUILDSTACK_PROJECT_KEY'),
      apiKey = const String.fromEnvironment('BUILDSTACK_API_KEY'),
      ownerId = const String.fromEnvironment(
        'BUILDSTACK_OWNER_ID',
        defaultValue: 'wardrobe-local-owner',
      );

  final String baseUrl;
  final String projectKey;
  final String apiKey;
  final String ownerId;

  bool get isConfigured => projectKey.isNotEmpty && apiKey.isNotEmpty;
}
