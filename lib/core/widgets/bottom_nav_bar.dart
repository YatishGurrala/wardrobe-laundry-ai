import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      backgroundColor: AppColors.deepSurface.withValues(alpha: 0.95),
      indicatorColor: AppColors.mutedLavender.withValues(alpha: 0.25),
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(
          icon: Icon(Icons.checkroom_outlined),
          label: 'Wardrobe',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          label: 'Add',
        ),
        NavigationDestination(
          icon: Icon(Icons.local_laundry_service_outlined),
          label: 'Laundry',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
