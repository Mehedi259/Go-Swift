import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class BookingRequestsScreen extends StatelessWidget {
  const BookingRequestsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final requests = [
      {'id': '#PB-1041', 'guest': 'Alexander Vance', 'property': 'Ocean Club Villa', 'dates': 'Apr 21 – Apr 26', 'nights': '5 nights', 'total': '\$10,175.00', 'status': 'Pending'},
      {'id': '#PB-1038', 'guest': 'Sarah Williams', 'property': 'Paradise Island Penthouse', 'dates': 'May 3 – May 7', 'nights': '4 nights', 'total': '\$4,800.00', 'status': 'Pending'},
    ];
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Booking Requests', style: AppTextStyles.titleLarge)),
      body: ListView.builder(padding: const EdgeInsets.all(20), itemCount: requests.length, itemBuilder: (c, i) {
        final r = requests[i];
        return Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(r['id']!, style: AppTextStyles.cyanLabel), GSStatusBadge(label: r['status']!, color: AppColors.gold)]),
            const SizedBox(height: 12),
            Row(children: [const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text(r['guest']!, style: AppTextStyles.titleMedium)]),
            Row(children: [const Icon(Icons.villa_outlined, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text(r['property']!, style: AppTextStyles.bodySmall)]),
            Row(children: [const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text('${r['dates']}  •  ${r['nights']}', style: AppTextStyles.bodySmall)]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total:', style: AppTextStyles.bodyMedium), Text(r['total']!, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold))]),
            const SizedBox(height: 12),
            Row(children: [Expanded(child: GSButton(label: 'Decline', isSecondary: true, onTap: () {})), const SizedBox(width: 12), Expanded(flex: 2, child: GSButton(label: 'Accept Booking →', onTap: () {}))]),
          ]));
      }),
    );
  }
}
