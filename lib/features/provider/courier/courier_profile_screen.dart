import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class CourierProfileScreen extends StatelessWidget {
  final bool embedded;
  const CourierProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.card,
              border: Border(bottom: BorderSide(color: AppColors.border)),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              children: [
                if (embedded)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Profile', style: AppTextStyles.headlineLarge),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Icon(Icons.settings_outlined, color: AppColors.textSecondary, size: 20),
                      ),
                    ],
                  ),
                if (embedded) const SizedBox(height: 20),
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppColors.cyanLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cyan, width: 2.5),
                  ),
                  child: const Icon(Icons.delivery_dining, color: AppColors.cyan, size: 44),
                ),
                const SizedBox(height: 12),
                Text('Marcus Rolle', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 2),
                Text('Bonded Courier • #BC-182', style: AppTextStyles.cyanLabel),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 16),
                    const SizedBox(width: 4),
                    Text('4.92 rating  •  2,450 deliveries', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _statPill('2,450', 'Deliveries')),
                    const SizedBox(width: 10),
                    Expanded(child: _statPill('\$12,400', 'Earned')),
                    const SizedBox(width: 10),
                    Expanded(child: _statPill('4.92 ★', 'Rating')),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Courier Details', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 14),
                _infoTile(Icons.shield_outlined, 'Bonded Status', 'Active  •  Insured up to \$50,000'),
                _infoTile(Icons.directions_bike, 'Vehicle', 'Yamaha NMAX 155  •  BS-124-MC'),
                _infoTile(Icons.payment, 'Payout Account', 'Bank of Bahamas  •  ••••8921'),
                _infoTile(Icons.location_on_outlined, 'Service Zone', 'Nassau  •  Paradise Island'),
                const SizedBox(height: 24),
                GSButton(label: 'Edit Profile', isSecondary: true, onTap: () {}),
                const SizedBox(height: 12),
                GSButton(
                  label: 'Sign Out',
                  isSecondary: true,
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/choose-account', (_) => false),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );

    return embedded
        ? content
        : Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
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
              title: Text('Courier Profile', style: AppTextStyles.titleLarge),
              centerTitle: false,
            ),
            body: content,
          );
  }

  Widget _statPill(String v, String l) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(v, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 2),
            Text(l, style: AppTextStyles.bodySmall),
          ],
        ),
      );

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
