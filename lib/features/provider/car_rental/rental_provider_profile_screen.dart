import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class RentalProviderProfileScreen extends StatelessWidget {
  const RentalProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Fleet Owner Profile', style: AppTextStyles.titleLarge),
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.cyanLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cyan, width: 2),
                    ),
                    child: const Icon(Icons.directions_car, color: AppColors.cyan, size: 36),
                  ),
                  const SizedBox(height: 12),
                  Text('Island Prestige Fleet', style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 2),
                  Text('Licensed Fleet Provider • Nassau', style: AppTextStyles.cyanLabel),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 16),
                      const SizedBox(width: 4),
                      Text('4.96 ★ • 3 luxury vehicles', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _infoTile(Icons.badge_outlined, 'Fleet License', 'FL-8921-BAH (Verified)'),
            _infoTile(Icons.shield_outlined, 'Commercial Insurance', 'Royal Fidelity • Full Fleet'),
            _infoTile(Icons.payment, 'Direct Deposit', 'Scotiabank Bahamas • ••••5512'),
            _infoTile(Icons.location_on_outlined, 'Pickup Hub', 'NAS Airport VIP Parking Lounge'),
            const SizedBox(height: 24),
            GSButton(label: 'Edit Fleet Profile', isSecondary: true, onTap: () {}),
            const SizedBox(height: 12),
            GSButton(
              label: 'Sign Out',
              isSecondary: true,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/choose-account', (_) => false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String val) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.cyan, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 2),
                  Text(val, style: AppTextStyles.titleMedium),
                ],
              ),
            ),
          ],
        ),
      );
}
