import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class RentalBookingManagementScreen extends StatelessWidget {
  const RentalBookingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = [
      {'id': '#CR-5821', 'renter': 'Alexander Vance', 'vehicle': 'Cadillac Escalade ESV', 'dates': 'Apr 21 – Apr 25', 'total': '\$1,140.00', 'status': 'Active', 'color': AppColors.green},
      {'id': '#CR-5800', 'renter': 'Victoria Stubbs', 'vehicle': 'Range Rover Sport', 'dates': 'Apr 28 – May 2', 'total': '\$980.00', 'status': 'Upcoming', 'color': AppColors.cyan},
      {'id': '#CR-5756', 'renter': 'Marcus Thompson', 'vehicle': 'Cadillac Escalade ESV', 'dates': 'Apr 10 – Apr 14', 'total': '\$1,140.00', 'status': 'Completed', 'color': AppColors.textSecondary},
    ];

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
        title: Text('Booking Management', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: bookings.map((b) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(b['id'] as String, style: AppTextStyles.cyanLabel),
                      GSStatusBadge(label: b['status'] as String, color: b['color'] as Color),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: AppColors.cyan),
                      const SizedBox(width: 8),
                      Text(b['renter'] as String, style: AppTextStyles.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.directions_car, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(b['vehicle'] as String, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(b['dates'] as String, style: AppTextStyles.bodySmall),
                      const Spacer(),
                      Text(
                        b['total'] as String,
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (b['status'] == 'Active') ...[
                    const SizedBox(height: 14),
                    GSButton(
                      label: 'Manage Active Rental →',
                      onTap: () => Navigator.pushNamed(context, '/provider/rental/active'),
                    ),
                  ],
                ],
              ),
            )).toList(),
      ),
    );
  }
}
