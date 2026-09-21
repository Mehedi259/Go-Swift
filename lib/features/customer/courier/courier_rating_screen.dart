import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

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
