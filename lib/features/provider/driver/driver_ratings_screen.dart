import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class DriverRatingsScreen extends StatelessWidget {
  final bool embedded;
  const DriverRatingsScreen({super.key, this.embedded = false});
  @override
  Widget build(BuildContext context) {
    final reviews = [
      {'name': 'Alexander Vance', 'stars': 5, 'comment': 'Exceptional service. Captain Rolle was punctual and professional.', 'date': 'Apr 20'},
      {'name': 'Victoria Stubbs', 'stars': 5, 'comment': 'Best ride experience on the island. Highly recommended!', 'date': 'Apr 18'},
      {'name': 'Marcus Thompson', 'stars': 5, 'comment': 'Pristine vehicle, seamless airport pickup. 10/10.', 'date': 'Apr 16'},
      {'name': 'Sarah Williams', 'stars': 4, 'comment': 'Very good experience. Clean car and helpful driver.', 'date': 'Apr 14'},
    ];
    final content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (embedded) Text('My Ratings', style: AppTextStyles.headlineLarge),
        const SizedBox(height: 16),
        // Summary card
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0A2030), Color(0xFF0D1117)]), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Overall Rating', style: AppTextStyles.bodyMedium), const SizedBox(height: 8), Text('4.98', style: AppTextStyles.price.copyWith(fontSize: 40, color: AppColors.gold)), Row(children: List.generate(5, (i) => const Icon(Icons.star, color: AppColors.gold, size: 18))), const SizedBox(height: 4), Text('620 total reviews', style: AppTextStyles.bodySmall)]),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_bar('5★', 0.94), _bar('4★', 0.04), _bar('3★', 0.01), _bar('2★', 0.01), _bar('1★', 0.00)]),
          ])),
      ])),
      const SizedBox(height: 20),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('Recent Reviews', style: AppTextStyles.headlineSmall)),
      const SizedBox(height: 12),
      Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: reviews.length, itemBuilder: (c, i) {
        final r = reviews[i];
        return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Container(width: 36, height: 36, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle), child: const Icon(Icons.person, color: AppColors.background, size: 18)), const SizedBox(width: 10), Expanded(child: Text(r['name'] as String, style: AppTextStyles.titleMedium)), Text(r['date'] as String, style: AppTextStyles.bodySmall)]),
            const SizedBox(height: 8),
            Row(children: List.generate(r['stars'] as int, (_) => const Icon(Icons.star, color: AppColors.gold, size: 14))),
            const SizedBox(height: 6),
            Text(r['comment'] as String, style: AppTextStyles.bodyMedium),
          ]));
      })),
    ]);
    return embedded ? content : Scaffold(appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))), title: Text('My Ratings', style: AppTextStyles.titleLarge)), body: SafeArea(child: content));
  }
  Widget _bar(String l, double pct) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [Text(l, style: AppTextStyles.caption), const SizedBox(width: 6), Container(width: 80, height: 6, decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: AppColors.surface), child: FractionallySizedBox(widthFactor: pct, alignment: Alignment.centerLeft, child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: AppColors.gold))))]));
}
