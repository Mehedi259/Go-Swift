import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class VehicleListingsScreen extends StatelessWidget {
  const VehicleListingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final vehicles = [
      {'name': 'Cadillac Escalade ESV', 'plate': 'BS-942-EX', 'status': 'Active Rental', 'rate': '\$285/day', 'color': AppColors.green},
      {'name': 'Range Rover Sport', 'plate': 'BS-441-YZ', 'status': 'Available', 'rate': '\$245/day', 'color': AppColors.cyan},
      {'name': 'Lamborghini Urus', 'plate': 'BS-009-LM', 'status': 'Maintenance', 'rate': '\$850/day', 'color': AppColors.gold},
    ];
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('My Fleet', style: AppTextStyles.titleLarge),
        actions: [Padding(padding: const EdgeInsets.only(right: 16), child: GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(gradient: AppColors.cyanGradient, borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.add, color: AppColors.background, size: 16), const SizedBox(width: 4), Text('Add Vehicle', style: AppTextStyles.labelMedium.copyWith(color: AppColors.background))]))))]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          Expanded(child: _stat('3', 'Total Vehicles', AppColors.cyan)), const SizedBox(width: 12),
          Expanded(child: _stat('1', 'Active Rentals', AppColors.green)), const SizedBox(width: 12),
          Expanded(child: _stat('\$4,200', 'This Month', AppColors.gold)),
        ])),
        Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: vehicles.length, itemBuilder: (c, i) {
          final v = vehicles[i];
          return Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              Container(height: 100, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), gradient: LinearGradient(colors: [Color(0xFF1A2B40), Color(0xFF0A1520)])), child: Center(child: Icon(Icons.directions_car, color: AppColors.textMuted, size: 40))),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v['name'] as String, style: AppTextStyles.headlineSmall), Text(v['plate'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan))])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [GSStatusBadge(label: v['status'] as String, color: v['color'] as Color), const SizedBox(height: 4), Text(v['rate'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold))]),
              ]),
              const SizedBox(height: 12),
              Row(children: [Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/provider/rental/bookings'), child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)), child: Center(child: Text('View Bookings', style: AppTextStyles.titleMedium))))), const SizedBox(width: 12), Expanded(child: GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(gradient: AppColors.cyanGradient, borderRadius: BorderRadius.circular(10)), child: Center(child: Text('Edit Vehicle', style: AppTextStyles.buttonText)))))]),
            ]));
        })),
      ]),
    );
  }
  Widget _stat(String v, String l, Color color) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 0.5)), child: Column(children: [Text(v, style: AppTextStyles.headlineSmall.copyWith(color: color)), Text(l, style: AppTextStyles.caption)]));
}
