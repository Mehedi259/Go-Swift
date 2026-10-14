import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

// Primary & Secondary Action Buttons
class GSButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isSecondary;
  final bool isSmall;
  final IconData? icon;
  final bool isLoading;

  const GSButton({
    super.key,
    required this.label,
    this.onTap,
    this.isSecondary = false,
    this.isSmall = false,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading ? null : onTap,
      child: Container(
        height: isSmall ? 44 : 56,
        decoration: BoxDecoration(
          color: isSecondary ? AppColors.cyanPill : AppColors.cyan,
          borderRadius: BorderRadius.circular(28),
          boxShadow: isSecondary
              ? null
              : [
                  BoxShadow(
                    color: AppColors.cyan.withValues(alpha: 0.22),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: isSecondary ? AppColors.cyan : Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.buttonText.copyWith(
                      color: isSecondary ? AppColors.cyan : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, size: 18, color: isSecondary ? AppColors.cyan : Colors.white),
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
          color: color ?? AppColors.cyanPill,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: textColor ?? AppColors.cyan,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 14, color: textColor ?? AppColors.cyan),
            ],
          ],
        ),
      ),
    );
  }
}
