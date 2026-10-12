import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/widgets/gs_button.dart';

class ActiveCarRentalScreen extends StatelessWidget {
  final CarRentalBookingModel? booking;
  const ActiveCarRentalScreen({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final CarRentalBookingModel? activeBooking = booking ?? (args is CarRentalBookingModel ? args : null);

    final bookingCode = activeBooking != null ? (activeBooking.bookingNumber ?? '#CR-${activeBooking.id}') : '#CR-RENTAL';
    final vehicleTitle = activeBooking?.vehicleName ?? 'Prestige Fleet Vehicle';
    final vehiclePlate = activeBooking?.licensePlate ?? 'Assigned at Handover';
    final returnDate = activeBooking?.endDate.isNotEmpty == true ? activeBooking!.endDate.split('T').first : 'Scheduled';
    final totalFare = activeBooking?.totalPrice != null
        ? '\$${activeBooking!.totalPrice.toStringAsFixed(2)}'
        : '\$0.00';

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
        title: Text('Active Rental', style: AppTextStyles.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('ACTIVE RENTAL • $bookingCode', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(vehicleTitle, style: AppTextStyles.displayMedium),
            const SizedBox(height: 2),
            Text(vehiclePlate, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            // Stats
            Row(
              children: [
                Expanded(child: _stat('Rental Period', '${activeBooking?.totalDays ?? 1} Days', Icons.calendar_today_outlined, AppColors.primaryTeal)),
                const SizedBox(width: 12),
                Expanded(child: _stat('Return Date', returnDate, Icons.flag_outlined, const Color(0xFF8A5300))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _stat('Total Paid', totalFare, Icons.credit_card, AppColors.green)),
                const SizedBox(width: 12),
                Expanded(child: _stat('Fuel Level', 'Full', Icons.local_gas_station_outlined, AppColors.primaryTeal)),
              ],
            ),
            const SizedBox(height: 20),
            Text('Vehicle Info', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  _infoRow('License Plate', vehiclePlate),
                  _infoRow('Category', 'Luxury Sovereign SUV'),
                  _infoRow('Seats', '6 Passengers'),
                  _infoRow('Max Luggage', '6 Bags'),
                  _infoRow('Insurance', 'Comprehensive — Active'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Support', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _actionBtn(Icons.phone_outlined, 'Call Support', AppColors.primaryTeal)),
                const SizedBox(width: 12),
                Expanded(child: _actionBtn(Icons.message_outlined, 'Message', AppColors.textSecondary)),
                const SizedBox(width: 12),
                Expanded(child: _actionBtn(Icons.report_problem_outlined, 'Report Issue', AppColors.red)),
              ],
            ),
            const SizedBox(height: 24),
            GSButton(label: 'Extend Rental', isSecondary: true, onTap: () {}),
            const SizedBox(height: 12),
            GSButton(
              label: 'Return Vehicle & Rate Experience →',
              onTap: () => Navigator.pushNamed(context, '/customer/car-rental/rating', arguments: activeBooking),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon, Color color) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.cardShadow,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
        const SizedBox(height: 6),
        Text(value, style: AppTextStyles.titleMedium.copyWith(color: color, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  Widget _infoRow(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: AppTextStyles.bodyMedium),
        Text(v, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary)),
      ],
    ),
  );

  Widget _actionBtn(IconData icon, String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.cardShadow,
    ),
    child: Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
