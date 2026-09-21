import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

// Reusable service card
class GSServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String badge;
  final String description;
  final String subtitle;
  final IconData subtitleIcon;
  final String buttonLabel;
  final Color badgeColor;
  final VoidCallback? onTap;

  const GSServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.badge,
    required this.description,
    required this.subtitle,
    required this.subtitleIcon,
    required this.buttonLabel,
    this.badgeColor = AppColors.cyan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.cyan, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Text(title, style: AppTextStyles.headlineSmall),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: badgeColor.withOpacity(0.3)),
                      ),
                      child: Text(badge, style: AppTextStyles.labelSmall.copyWith(color: badgeColor)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(description, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(subtitleIcon, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(child: Text(subtitle, style: AppTextStyles.bodySmall)),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: AppColors.cyanGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(buttonLabel, style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.background,
                        fontWeight: FontWeight.w700,
                      )),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, size: 14, color: AppColors.background),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Info row with icon
class GSInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;

  const GSInfoRow({super.key, required this.icon, required this.text, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: iconColor ?? AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

// Section header
class GSSectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  const GSSectionHeader({super.key, required this.title, this.trailing, this.onTrailingTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headlineSmall),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(trailing!, style: AppTextStyles.cyanLabel),
          ),
      ],
    );
  }
}

// Status badge
class GSStatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const GSStatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

// Rating stars row
class GSRatingRow extends StatelessWidget {
  final double rating;
  final int reviews;

  const GSRatingRow({super.key, required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: 14, color: AppColors.gold),
        const SizedBox(width: 4),
        Text('$rating', style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold)),
        const SizedBox(width: 4),
        Text('($reviews+)', style: AppTextStyles.bodySmall),
      ],
    );
  }
}
