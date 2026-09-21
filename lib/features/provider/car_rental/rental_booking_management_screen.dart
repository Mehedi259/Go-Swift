import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class RentalBookingManagementScreen extends StatelessWidget {
  const RentalBookingManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Booking Management', style: AppTextStyles.titleLarge)),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        ...[
          {'id': '#CR-5821', 'renter': 'Alexander Vance', 'vehicle': 'Cadillac Escalade ESV', 'dates': 'Apr 21 – Apr 25', 'total': '\$1,140.00', 'status': 'Active', 'color': AppColors.green},
          {'id': '#CR-5800', 'renter': 'Victoria Stubbs', 'vehicle': 'Range Rover Sport', 'dates': 'Apr 28 – May 2', 'total': '\$980.00', 'status': 'Upcoming', 'color': AppColors.cyan},
          {'id': '#CR-5756', 'renter': 'Marcus Thompson', 'vehicle': 'Cadillac Escalade ESV', 'dates': 'Apr 10 – Apr 14', 'total': '\$1,140.00', 'status': 'Completed', 'color': AppColors.textMuted},
        ].map((b) => Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(b['id'] as String, style: AppTextStyles.cyanLabel), GSStatusBadge(label: b['status'] as String, color: b['color'] as Color)]),
            const SizedBox(height: 10),
            Row(children: [const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text(b['renter'] as String, style: AppTextStyles.titleMedium)]),
            Row(children: [const Icon(Icons.directions_car, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text(b['vehicle'] as String, style: AppTextStyles.bodySmall)]),
            Row(children: [const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text(b['dates'] as String, style: AppTextStyles.bodySmall), const Spacer(), Text(b['total'] as String, style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold))]),
            if (b['status'] == 'Active') ...[const SizedBox(height: 10), GSButton(label: 'Manage Active Rental →', onTap: () => Navigator.pushNamed(context, '/provider/rental/active'))],
          ]))),
      ]),
    );
  }
}

