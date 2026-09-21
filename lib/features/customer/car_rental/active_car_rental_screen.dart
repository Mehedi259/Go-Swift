import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class ActiveCarRentalScreen extends StatelessWidget {
  const ActiveCarRentalScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Active Rental', style: AppTextStyles.titleLarge)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: AppColors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)), const SizedBox(width: 6), Text('ACTIVE RENTAL • #CR-5821', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green))])),
        const SizedBox(height: 16),
        Text('Cadillac Escalade ESV', style: AppTextStyles.displayMedium),
        Text('BS-942-EX  •  Onyx Black', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan)),
        const SizedBox(height: 20),
        // Stats
        Row(children: [
          Expanded(child: _stat('Days Remaining', '2 of 4', Icons.calendar_today_outlined, AppColors.cyan)),
          const SizedBox(width: 12), Expanded(child: _stat('Return Date', 'Apr 25, 2026', Icons.flag_outlined, AppColors.gold)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _stat('Total Paid', '\$1,140.00', Icons.credit_card, AppColors.green)),
          const SizedBox(width: 12), Expanded(child: _stat('Fuel Level', 'Full', Icons.local_gas_station_outlined, AppColors.cyan)),
        ]),
        const SizedBox(height: 20),
        Text('Vehicle Info', style: AppTextStyles.headlineSmall), const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Column(children: [
            _infoRow('License Plate', 'BS-942-EX'), _infoRow('Color', 'Onyx Black'), _infoRow('Seats', '6 Passengers'), _infoRow('Max Luggage', '6 Bags'), _infoRow('Insurance', 'Comprehensive — Active'),
          ])),
        const SizedBox(height: 20),
        Text('Support', style: AppTextStyles.headlineSmall), const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _actionBtn(Icons.phone_outlined, 'Call Support', AppColors.cyan)),
          const SizedBox(width: 12), Expanded(child: _actionBtn(Icons.message_outlined, 'Message', AppColors.textSecondary)),
          const SizedBox(width: 12), Expanded(child: _actionBtn(Icons.report_problem_outlined, 'Report Issue', AppColors.red)),
        ]),
        const SizedBox(height: 20),
        GSButton(label: 'Extend Rental', isSecondary: true, onTap: () {}),
        const SizedBox(height: 12),
        GSButton(label: 'Return Vehicle →', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false)),
      ])),
    );
  }
  Widget _stat(String label, String value, IconData icon, Color color) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 0.5)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, size: 14, color: color), const SizedBox(width: 6), Text(label, style: AppTextStyles.bodySmall)]), const SizedBox(height: 4), Text(value, style: AppTextStyles.titleMedium.copyWith(color: color))]));
  Widget _infoRow(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: AppTextStyles.bodyMedium), Text(v, style: AppTextStyles.titleMedium)]));
  Widget _actionBtn(IconData icon, String label, Color color) => Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Column(children: [Icon(icon, color: color, size: 22), const SizedBox(height: 4), Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary))]));
}
