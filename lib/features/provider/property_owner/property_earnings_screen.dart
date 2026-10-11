import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class PropertyEarningsScreen extends StatelessWidget {
  const PropertyEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Property Earnings', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Revenue This Month', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 6),
                  Text(
                    '\$18,200.00',
                    style: AppTextStyles.price.copyWith(color: AppColors.gold, fontSize: 36),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _s('4', 'Bookings', AppColors.cyan)),
                      const SizedBox(width: 10),
                      Expanded(child: _s('19 nights', 'Booked', AppColors.gold)),
                      const SizedBox(width: 10),
                      Expanded(child: _s('78%', 'Occupancy', AppColors.green)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Booking Revenue Breakdown', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            ...[
              {'id': '#PB-1041', 'property': 'Ocean Club Villa', 'nights': '5 nights', 'amount': '\$10,175.00'},
              {'id': '#PB-1029', 'property': 'Paradise Island Penthouse', 'nights': '4 nights', 'amount': '\$4,800.00'},
              {'id': '#PB-1011', 'property': 'Ocean Club Villa', 'nights': '2 nights', 'amount': '\$3,700.00'},
            ].map((e) => Container(
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
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.cardTouchpoint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.villa_outlined, color: AppColors.cyan, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e['property']!, style: AppTextStyles.titleMedium),
                            const SizedBox(height: 2),
                            Text('${e['id']}  •  ${e['nights']}', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Text(
                        e['amount']!,
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _s(String v, String l, Color color) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(v, style: AppTextStyles.headlineSmall.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 2),
            Text(l, style: AppTextStyles.caption),
          ],
        ),
      );
}

class PropertyOwnerProfileScreen extends StatelessWidget {
  const PropertyOwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Owner Profile', style: AppTextStyles.titleLarge),
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
                    child: const Icon(Icons.villa, color: AppColors.cyan, size: 36),
                  ),
                  const SizedBox(height: 12),
                  Text('Bahamian Sovereign Estates', style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 2),
                  Text('Verified Property Host • Nassau & Paradise Island', style: AppTextStyles.cyanLabel),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 16),
                      const SizedBox(width: 4),
                      Text('4.98 ★ • 3 luxury properties listed', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _infoTile(Icons.verified_outlined, 'Host Status', 'Superhost • Licensed Vacation Rental'),
            _infoTile(Icons.account_balance_outlined, 'Payout Account', 'Commonwealth Bank • ••••7721'),
            _infoTile(Icons.support_agent_outlined, 'Concierge Contact', 'concierge@bahamasovereign.com'),
            _infoTile(Icons.receipt_long_outlined, 'Tax Registration', 'TIN-40192-NP'),
            const SizedBox(height: 24),
            GSButton(label: 'Edit Host Profile', isSecondary: true, onTap: () {}),
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
