import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'bottom_nav_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.matteBlack, AppColors.deepSurface],
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: child,
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
