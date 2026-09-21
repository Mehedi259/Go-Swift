import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class CourierDeliveryStatusScreen extends StatelessWidget {
  const CourierDeliveryStatusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Delivery Status', style: AppTextStyles.titleLarge)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text('PARCEL #CS-3182 • IN TRANSIT', style: AppTextStyles.goldLabel)),
        const SizedBox(height: 16), Text('Your Package is On\nIts Way', style: AppTextStyles.displayMedium),
        const SizedBox(height: 8), Text('Est. Delivery: 4:45 PM  •  12 min remaining', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 20),
        // Map placeholder
        Container(height: 180, decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)), child: const Center(child: Icon(Icons.local_shipping, color: AppColors.cyan, size: 40))),
        const SizedBox(height: 16),
        // Steps
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Column(children: [
            _step('Parcel Picked Up', 'Graycliff Boutique, Downtown Nassau  •  4:00 PM', true),
            _step('En Route', 'Marcus Rolle en route to destination', true),
            _step('Arrived at Destination', 'The Ocean Club, Paradise Island', false),
            _step('Delivered & Signed', 'Chain-of-custody completed', false),
          ])),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle), child: const Icon(Icons.delivery_dining, color: AppColors.cyan, size: 22)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Marcus Rolle', style: AppTextStyles.titleLarge), Text('Bonded Courier  •  4.95 ★', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold))])), Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.phone_outlined, color: AppColors.cyan, size: 20))])),
        const SizedBox(height: 20),
        GSButton(label: 'Parcel Delivered →', onTap: () => Navigator.pushNamed(context, '/customer/courier/rating')),
        const SizedBox(height: 12),
        GSButton(label: 'Return to Hub', isSecondary: true, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false)),
      ])),
    );
  }
  Widget _step(String l, String s, bool done) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Column(children: [Container(width: 24, height: 24, decoration: BoxDecoration(color: done ? AppColors.cyan : AppColors.surface, shape: BoxShape.circle, border: Border.all(color: done ? AppColors.cyan : AppColors.border)), child: Icon(done ? Icons.check : Icons.circle_outlined, size: 12, color: done ? AppColors.background : AppColors.textMuted)), Container(width: 2, height: 20, color: AppColors.border.withOpacity(0.5))]),
    const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: AppTextStyles.titleMedium.copyWith(color: done ? AppColors.textPrimary : AppColors.textMuted)), Text(s, style: AppTextStyles.bodySmall)]))]));
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
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
        const SizedBox(height: 20),
        Container(width: 72, height: 72, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle), child: const Icon(Icons.delivery_dining, color: AppColors.cyan, size: 36)),
        const SizedBox(height: 16), Text('Rate Your Courier', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
        const SizedBox(height: 4), Text('Marcus Rolle  •  Parcel #CS-3182', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => GestureDetector(onTap: () => setState(() => _r = i + 1), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Icon(i < _r ? Icons.star : Icons.star_border, color: AppColors.gold, size: 40))))),
        const SizedBox(height: 20),
        TextFormField(maxLines: 3, style: AppTextStyles.bodyLarge, decoration: const InputDecoration(hintText: 'Comment on delivery experience...')),
        const Spacer(),
        GSButton(label: 'Submit Rating →', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false)),
        const SizedBox(height: 12),
        TextButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false), child: Text('Skip', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))),
      ])),
    );
  }
}
