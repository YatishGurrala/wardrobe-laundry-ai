import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../wardrobe/presentation/providers/clothing_providers.dart';
import '../viewmodels/profile_settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(wardrobeStatsProvider);
    final isDarkMode = ref.watch(darkModeProvider);
    final notifications = ref.watch(notificationsProvider);

    return ListView(
      children: [
        const SizedBox(height: 20),
        const SectionHeader(
          title: 'Style Identity Passport',
          subtitle: 'Serene Intelligence profile and wardrobe preferences.',
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
      ],
    );
  }
}
