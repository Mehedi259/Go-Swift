import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/courier_model.dart';
import '../../../core/widgets/gs_button.dart';

class CourierDeliveryStatusScreen extends StatelessWidget {
  const CourierDeliveryStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final CourierDeliveryModel? delivery = args is CourierDeliveryModel ? args : null;
    final trackingCode = delivery?.trackingNumber ?? (delivery != null ? '#CS-${delivery.id}' : '#CS-3182');
    final statusText = (delivery?.status ?? 'IN TRANSIT').toUpperCase();

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Text('Delivery Status', style: AppTextStyles.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.badgeGold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'PARCEL $trackingCode • $statusText',
                style: AppTextStyles.goldLabel.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text('Your Package is On\nIts Way', style: AppTextStyles.displayMedium),
            const SizedBox(height: 8),
            Text('Est. Delivery: 4:45 PM • 12 min remaining', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 20),
            // Map container
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Stack(
                children: [
                  Center(child: Icon(Icons.local_shipping, color: AppColors.primaryTeal.withValues(alpha: 0.5), size: 48)),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Text('LIVE GPS COURIER DISPATCH', style: AppTextStyles.caption.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Steps
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  _step('Parcel Picked Up', 'Graycliff Boutique, Downtown Nassau • 4:00 PM', true),
                  _step('En Route', 'Marcus Rolle en route to destination', true),
                  _step('Arrived at Destination', 'The Ocean Club, Paradise Island', false),
                  _step('Delivered & Signed', 'Chain-of-custody completed', false),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.badgeTeal, shape: BoxShape.circle),
                    child: const Icon(Icons.delivery_dining, color: AppColors.primaryTeal, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Marcus Rolle', style: AppTextStyles.titleLarge),
                        Text('Bonded Courier • 4.95 ★', style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.cardTouchpoint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.phone_outlined, color: AppColors.primaryTeal, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GSButton(label: 'Parcel Delivered →', onTap: () => Navigator.pushNamed(context, '/customer/courier/rating', arguments: delivery)),
            const SizedBox(height: 12),
            GSButton(
              label: 'Return to Hub',
              isSecondary: true,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _step(String l, String s, bool done) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: done ? AppColors.primaryTeal : AppColors.cardTouchpoint,
                shape: BoxShape.circle,
                border: Border.all(color: done ? AppColors.primaryTeal : AppColors.border),
              ),
              child: Icon(done ? Icons.check : Icons.circle_outlined, size: 12, color: done ? Colors.white : AppColors.textMuted),
            ),
            Container(width: 2, height: 22, color: done ? AppColors.primaryTeal.withValues(alpha: 0.4) : AppColors.border),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l, style: AppTextStyles.titleMedium.copyWith(color: done ? AppColors.textPrimary : AppColors.textMuted, fontWeight: done ? FontWeight.bold : FontWeight.normal)),
              Text(s, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    ),
  );
}

class CourierRatingScreen extends StatefulWidget {
  const CourierRatingScreen({super.key});
  @override State<CourierRatingScreen> createState() => _CourierRatingScreenState();
}

class _CourierRatingScreenState extends State<CourierRatingScreen> {
  int _r = 5;

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryTeal, width: 2),
                boxShadow: AppColors.softShadow,
              ),
              child: const Icon(Icons.delivery_dining, color: AppColors.primaryTeal, size: 38),
            ),
            const SizedBox(height: 16),
            Text('Rate Your Courier', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('Marcus Rolle • Parcel #CS-3182', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => GestureDetector(
                onTap: () => setState(() => _r = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(i < _r ? Icons.star : Icons.star_border, color: AppColors.gold, size: 40),
                ),
              )),
            ),
            const SizedBox(height: 24),
            TextFormField(
              maxLines: 3,
              style: AppTextStyles.bodyLarge,
              decoration: const InputDecoration(hintText: 'Comment on delivery experience...'),
            ),
            const Spacer(),
            GSButton(label: 'Submit Rating →', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false),
              child: Text('Skip', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
