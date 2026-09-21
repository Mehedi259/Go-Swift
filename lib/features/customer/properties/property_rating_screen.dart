import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class PropertyRatingScreen extends StatefulWidget {
  const PropertyRatingScreen({super.key});
  @override State<PropertyRatingScreen> createState() => _PropertyRatingScreenState();
}
class _PropertyRatingScreenState extends State<PropertyRatingScreen> {
  final _cats = ['Cleanliness', 'Location', 'Service', 'Value', 'Amenities'];
  final _ratings = <int>[5, 5, 5, 5, 5];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(height: 16),
        Container(width: 72, height: 72, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle), child: const Icon(Icons.villa, color: AppColors.cyan, size: 36)),
        const SizedBox(height: 16), Text('Rate Your Stay', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
        const SizedBox(height: 4), Text('The Ocean Club Villa  •  Apr 21 – Apr 26', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: 28),
        ..._cats.asMap().entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text(e.value, style: AppTextStyles.titleMedium)),
          Row(children: List.generate(5, (i) => GestureDetector(onTap: () => setState(() => _ratings[e.key] = i + 1), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: Icon(i < _ratings[e.key] ? Icons.star : Icons.star_border, color: AppColors.gold, size: 28))))),
        ]))),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerLeft, child: Text('Your Review', style: AppTextStyles.labelSmall)),
        const SizedBox(height: 8),
        TextFormField(maxLines: 4, style: AppTextStyles.bodyLarge, decoration: const InputDecoration(hintText: 'Describe your stay at The Ocean Club Villa...')),
        const SizedBox(height: 24),
        GSButton(label: 'Submit Review →', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false)),
        const SizedBox(height: 12),
        TextButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false), child: Text('Skip Review', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))),
      ])),
    );
  }
}
