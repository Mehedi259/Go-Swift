import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class RideRatingScreen extends StatefulWidget {
  const RideRatingScreen({super.key});
  @override State<RideRatingScreen> createState() => _RideRatingScreenState();
}

class _RideRatingScreenState extends State<RideRatingScreen> {
  int _rating = 5;
  final _tags = ['On Time', 'Professional', 'Safe Driver', 'Excellent Vehicle', 'Polite & Courteous', 'VIP Experience'];
  final _selected = <int>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(width: 72, height: 72, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: AppColors.border)), child: const Icon(Icons.person, color: AppColors.cyan, size: 36)),
        const SizedBox(height: 16),
        Text('Rate Your Chauffeur', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text('Captain Terrence Rolle • Trip #SW-8492', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: 28),
        // Stars
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => GestureDetector(
          onTap: () => setState(() => _rating = i + 1),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Icon(i < _rating ? Icons.star : Icons.star_border, color: AppColors.gold, size: 40))))),
        const SizedBox(height: 8),
        Text(_rating == 5 ? 'Outstanding' : _rating == 4 ? 'Very Good' : _rating == 3 ? 'Good' : _rating == 2 ? 'Fair' : 'Poor', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold)),
        const SizedBox(height: 24),
        // Tags
        Align(alignment: Alignment.centerLeft, child: Text('What made it great?', style: AppTextStyles.titleLarge)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: _tags.asMap().entries.map((e) => GestureDetector(onTap: () => setState(() => _selected.contains(e.key) ? _selected.remove(e.key) : _selected.add(e.key)),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: _selected.contains(e.key) ? AppColors.cyan.withOpacity(0.15) : AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: _selected.contains(e.key) ? AppColors.cyan : AppColors.border)),
            child: Text(e.value, style: AppTextStyles.bodySmall.copyWith(color: _selected.contains(e.key) ? AppColors.cyan : AppColors.textPrimary))))).toList()),
        const SizedBox(height: 20),
        // Comment
        Align(alignment: Alignment.centerLeft, child: Text('Additional Comments', style: AppTextStyles.labelSmall)),
        const SizedBox(height: 8),
        TextFormField(maxLines: 3, style: AppTextStyles.bodyLarge, decoration: const InputDecoration(hintText: 'Share your experience with Captain Terrence...')),
        const SizedBox(height: 24),
        GSButton(label: 'Submit Rating →', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false)),
        const SizedBox(height: 16),
        TextButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false), child: Text('Skip Rating', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))),
      ])),
    );
  }
}
