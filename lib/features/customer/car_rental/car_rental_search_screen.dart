import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class CarRentalSearchScreen extends StatelessWidget {
  const CarRentalSearchScreen({super.key});
  final _cars = const [
    {'name': 'Cadillac Escalade ESV', 'type': 'LUXURY SUV', 'price': '\$285/day', 'badge': 'MOST BOOKED', 'seats': 6, 'bags': 6},
    {'name': 'Range Rover Sport', 'type': 'LUXURY SUV', 'price': '\$245/day', 'badge': 'ISLAND FAVORITE', 'seats': 5, 'bags': 4},
    {'name': 'Lamborghini Urus', 'type': 'EXOTIC SUV', 'price': '\$850/day', 'badge': 'VIP SELECTION', 'seats': 4, 'bags': 3},
    {'name': 'Mercedes S-Class', 'type': 'EXECUTIVE SEDAN', 'price': '\$195/day', 'badge': '', 'seats': 4, 'bags': 3},
    {'name': 'Ferrari 488 Spider', 'type': 'EXOTIC CONVERTIBLE', 'price': '\$1,200/day', 'badge': 'EXOTIC', 'seats': 2, 'bags': 1},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Row(children: [Text('GO ', style: AppTextStyles.titleLarge.copyWith(color: Colors.white)), Text('SWIFT', style: AppTextStyles.titleLarge.copyWith(color: AppColors.cyan)), const SizedBox(width: 8), Text('Car Rental', style: AppTextStyles.titleLarge)])),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 8),
          Text('PRIVATE FLEET MANAGEMENT', style: AppTextStyles.cyanLabel),
          const SizedBox(height: 4),
          Text('Reserve Your Vehicle', style: AppTextStyles.displayMedium),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextFormField(style: AppTextStyles.bodyMedium, decoration: const InputDecoration(hintText: 'Pick-up Location', prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 18), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
            const SizedBox(width: 8),
            Container(width: 44, height: 44, decoration: BoxDecoration(gradient: AppColors.cyanGradient, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.search, color: AppColors.background, size: 20)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _dateField('Pick-up Date', 'April 21, 2026')),
            const SizedBox(width: 8),
            Expanded(child: _dateField('Return Date', 'April 25, 2026')),
          ]),
        ])),
        Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: _cars.length, itemBuilder: (c, i) => _CarCard(car: _cars[i]))),
      ]),
    );
  }

  Widget _dateField(String label, String val) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: AppTextStyles.caption), Text(val, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))]));
}

class _CarCard extends StatelessWidget {
  final Map<String, dynamic> car;
  const _CarCard({required this.car});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/car-rental/vehicle'),
      child: Container(margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
        child: Column(children: [
          Container(height: 120, decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)), gradient: LinearGradient(colors: [Color(0xFF1A2B40), Color(0xFF0A1520)])),
            child: Stack(children: [
              Center(child: Icon(Icons.directions_car, color: AppColors.textMuted, size: 48)),
              if ((car['badge'] as String).isNotEmpty) Positioned(top: 10, left: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.8), borderRadius: BorderRadius.circular(8)), child: Text(car['badge'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold)))),
              Positioned(top: 10, right: 10, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.background.withOpacity(0.8), shape: BoxShape.circle), child: const Icon(Icons.favorite_border, color: AppColors.textPrimary, size: 16))),
            ])),
          Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(car['name'] as String, style: AppTextStyles.headlineSmall), Text(car['type'] as String, style: AppTextStyles.cyanLabel)])),
              Text(car['price'] as String, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold)),
            ]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.people_outline, size: 14, color: AppColors.textSecondary), const SizedBox(width: 4), Text('${car['seats']} seats', style: AppTextStyles.bodySmall), const SizedBox(width: 12), const Icon(Icons.luggage, size: 14, color: AppColors.textSecondary), const SizedBox(width: 4), Text('${car['bags']} bags', style: AppTextStyles.bodySmall), const Spacer(), const Icon(Icons.star, size: 14, color: AppColors.gold), const SizedBox(width: 4), Text('4.97', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold))]),
          ])),
        ])));
  }
}
