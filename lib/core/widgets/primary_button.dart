import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.softWhite,
        foregroundColor: AppColors.matteBlack,
        minimumSize: const Size.fromHeight(48),
      ),
      child: Text(label),
    );
  }
}
