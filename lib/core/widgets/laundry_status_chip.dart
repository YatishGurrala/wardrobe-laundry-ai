import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../features/wardrobe/domain/entities/laundry_status.dart';

class LaundryStatusChip extends StatelessWidget {
  const LaundryStatusChip({super.key, required this.status});

  final LaundryStatus status;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status.label),
      backgroundColor: _background(status),
      side: BorderSide.none,
      labelStyle: const TextStyle(color: AppColors.softWhite),
      visualDensity: VisualDensity.compact,
    );
  }

  Color _background(LaundryStatus status) {
    return switch (status) {
      LaundryStatus.clean => Colors.green.withValues(alpha: 0.35),
      LaundryStatus.worn => AppColors.warmBeige.withValues(alpha: 0.35),
      LaundryStatus.inLaundry => Colors.orange.withValues(alpha: 0.35),
      LaundryStatus.washed => AppColors.accentBlue.withValues(alpha: 0.35),
    };
  }
}
