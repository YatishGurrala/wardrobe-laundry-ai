import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../wardrobe/presentation/providers/clothing_providers.dart';
import '../viewmodels/profile_settings_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _showAdminDebugPanel = false;

  static const String _adminDebugEmail = 'yatishkotlin@gmail.com';
  static const String _currentUserEmail = String.fromEnvironment(
    'CURRENT_USER_EMAIL',
  );
  static const String _releaseChannel = String.fromEnvironment(
    'APP_RELEASE_CHANNEL',
    defaultValue: 'prod',
  );

  bool get _isPreviewOrStaging {
    final channel = _releaseChannel.trim().toLowerCase();
    return channel == 'main' || channel == 'preview' || channel == 'staging';
  }

  bool get _isAuthorizedAdmin {
    final admin = _adminDebugEmail.trim().toLowerCase();
    final current = _currentUserEmail.trim().toLowerCase();
    return admin.isNotEmpty && current.isNotEmpty && admin == current;
  }

  void _toggleAdminDebugPanel() {
    if (!kDebugMode || !_isPreviewOrStaging || !_isAuthorizedAdmin) {
      if (kDebugMode && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isPreviewOrStaging
                  ? 'Debug panel is restricted to admin access.'
                  : 'Debug panel is disabled for this release channel.',
            ),
          ),
        );
      }
      return;
    }

    setState(() {
      _showAdminDebugPanel = !_showAdminDebugPanel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(wardrobeStatsProvider);
    final isDarkMode = ref.watch(darkModeProvider);
    final notifications = ref.watch(notificationsProvider);
    final showDebugPanel =
        kDebugMode &&
        _isPreviewOrStaging &&
        _isAuthorizedAdmin &&
        _showAdminDebugPanel;
    final backendStatus = showDebugPanel
        ? ref.watch(backendDebugStatusProvider)
        : null;

    return ListView(
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onLongPress: _toggleAdminDebugPanel,
          child: const SectionHeader(
            title: 'Style Identity Passport',
            subtitle: 'Serene Intelligence profile and wardrobe preferences.',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(title: 'Total', value: '${stats.totalItems}'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(title: 'Clean', value: '${stats.cleanItems}'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              SwitchListTile(
                value: isDarkMode,
                onChanged: (value) =>
                    ref.read(darkModeProvider.notifier).state = value,
                title: const Text('Dark mode'),
                subtitle: const Text(
                  'Keep premium low-glare experience enabled',
                ),
              ),
              SwitchListTile(
                value: notifications,
                onChanged: (value) =>
                    ref.read(notificationsProvider.notifier).state = value,
                title: const Text('Notifications'),
                subtitle: const Text('Laundry and outfit reminders'),
              ),
              const ListTile(
                title: Text('Preferences'),
                subtitle: Text('Inter typography, glass cards, 24px gutters'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (showDebugPanel) ...[
          const SectionHeader(
            title: 'Admin Debug Panel',
            subtitle: 'Buildstack backend mode and connectivity status.',
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: backendStatus!.when(
              data: (status) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        status.isConnected
                            ? Icons.cloud_done_rounded
                            : Icons.cloud_off_rounded,
                        color: status.isConnected
                            ? Colors.greenAccent.shade400
                            : Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status.mode == BackendMode.buildstack
                            ? 'Mode: Buildstack'
                            : 'Mode: Mock',
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          ref.invalidate(backendDebugStatusProvider);
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Connected: ${status.isConnected ? 'Yes' : 'No'}'),
                  Text('Configured: ${status.isConfigured ? 'Yes' : 'No'}'),
                  Text(
                    'Base URL: ${status.baseUrl}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Project Key: ${status.projectKey.isEmpty ? 'Not set' : status.projectKey}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Owner ID: ${status.ownerId}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (status.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Last error: ${status.errorMessage}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debug panel failed: $error',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      ref.invalidate(backendDebugStatusProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}
