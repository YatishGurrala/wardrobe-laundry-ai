import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/profile/presentation/viewmodels/profile_settings_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class WardrobeLaundryAiApp extends ConsumerWidget {
  const WardrobeLaundryAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final isDarkMode = ref.watch(darkModeProvider);

    return MaterialApp.router(
      title: 'Wardrobe Laundry AI',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
