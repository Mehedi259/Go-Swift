import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

// Primary Cyan Gradient Button
class GSButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isSecondary;
  final bool isSmall;
  final IconData? icon;

  const GSButton({
    super.key,
    required this.label,
    this.onTap,
    this.isSecondary = false,
    this.isSmall = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isSmall ? 44 : 56,
        decoration: BoxDecoration(
          gradient: isSecondary ? null : AppColors.cyanGradient,
          color: isSecondary ? AppColors.surface : null,
          borderRadius: BorderRadius.circular(28),
          border: isSecondary
              ? Border.all(color: AppColors.border)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: isSecondary
                  ? AppTextStyles.buttonText.copyWith(color: AppColors.textPrimary)
                  : AppTextStyles.buttonText,
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18, color: isSecondary ? AppColors.textPrimary : AppColors.background),
            ],
          ],
        ),
      ),
    );
  }
}

// Small tag/badge button
class GSTagButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;

  const GSTagButton({
    super.key,
    required this.label,
    this.onTap,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: color == null ? AppColors.cyanGradient : null,
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: textColor ?? AppColors.background,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 14, color: textColor ?? AppColors.background),
            ],
          ],
        ),
      ),
    );
  }
}
