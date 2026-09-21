import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_app_bar.dart';

class RideBookingScreen extends StatefulWidget {
  const RideBookingScreen({super.key});
  @override State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  int _vehicle = 0;
  final _vehicles = [
    {'name': 'Executive SUV', 'type': 'Cadillac Escalade ESV', 'price': '\$85–\$120', 'eta': '4 min', 'icon': Icons.directions_car, 'badge': 'MOST POPULAR'},
    {'name': 'Luxury Sedan', 'type': 'Mercedes-Benz S-Class', 'price': '\$65–\$90', 'eta': '6 min', 'icon': Icons.directions_car_outlined, 'badge': ''},
    {'name': 'VIP Sprinter', 'type': 'Mercedes-Benz Sprinter', 'price': '\$110–\$160', 'eta': '8 min', 'icon': Icons.airport_shuttle_outlined, 'badge': 'GROUP PREFERRED'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GSAppBar(title: 'Book a Ride', showLogo: true,
        trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppColors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)), const SizedBox(width: 6), Text('LIVE', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green))]))),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Pickup
          Text('PICKUP LOCATION', style: AppTextStyles.labelSmall),
          const SizedBox(height: 8),
          TextFormField(style: AppTextStyles.bodyLarge, decoration: InputDecoration(hintText: 'Lynden Pindling Int\'l Airport (NAS)', prefixIcon: Container(margin: const EdgeInsets.all(12), child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle))))),
          const SizedBox(height: 16),
          Text('DESTINATION', style: AppTextStyles.labelSmall),
          const SizedBox(height: 8),
          TextFormField(style: AppTextStyles.bodyLarge, decoration: InputDecoration(hintText: 'The Ocean Club, Four Seasons', prefixIcon: Container(margin: const EdgeInsets.all(12), child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle))))),
          const SizedBox(height: 8),
          Row(children: [
            _quickDestBtn('Paradise Island'),
            const SizedBox(width: 8), _quickDestBtn('Atlantis Resort'),
            const SizedBox(width: 8), _quickDestBtn('Baha Mar'),
          ]),
          const SizedBox(height: 24),
          Text('Select Your Vehicle', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          ..._vehicles.asMap().entries.map((e) => GestureDetector(onTap: () => setState(() => _vehicle = e.key),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: _vehicle == e.key ? AppColors.cyan : AppColors.border, width: _vehicle == e.key ? 1.5 : 0.5)),
              child: Row(children: [
                Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: Icon(e.value['icon'] as IconData, color: _vehicle == e.key ? AppColors.cyan : AppColors.textSecondary, size: 24)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Text(e.value['name'] as String, style: AppTextStyles.titleLarge), const SizedBox(width: 8),
                    if ((e.value['badge'] as String).isNotEmpty) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.cyan.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                      child: Text(e.value['badge'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan)))]),
                  Text(e.value['type'] as String, style: AppTextStyles.bodySmall),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(e.value['price'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold)), Text('${e.value['eta']} away', style: AppTextStyles.bodySmall)]),
              ])))),
          const SizedBox(height: 16),
          // Ride options
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Ride Schedule', style: AppTextStyles.titleMedium), const Icon(Icons.access_time, color: AppColors.textSecondary, size: 18)]),
              const Divider(color: AppColors.border, height: 20),
              Row(children: [
                Expanded(child: _rideOption('Now', 'Instant dispatch', true)),
                const SizedBox(width: 8), Expanded(child: _rideOption('Reserve', 'Schedule ahead', false)),
              ]),
            ])),
          const SizedBox(height: 24),
          // Summary
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              _summaryRow('Estimated Fare', '\$118.50'),
              const Divider(color: AppColors.border, height: 16),
              _summaryRow('Service Fee', '\$8.50'),
              _summaryRow('Go Swift Concierge', 'Included'),
            ])),
        ]))),
        Padding(padding: const EdgeInsets.all(20), child: GSButton(label: 'Confirm Booking →', onTap: () => Navigator.pushNamed(context, '/customer/ride/waiting'))),
      ]),
    );
  }

  Widget _quickDestBtn(String label) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
    child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)));

  Widget _rideOption(String title, String sub, bool active) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: active ? AppColors.cyan.withOpacity(0.1) : AppColors.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: active ? AppColors.cyan : AppColors.border)),
    child: Column(children: [Text(title, style: AppTextStyles.titleMedium.copyWith(color: active ? AppColors.cyan : AppColors.textPrimary)), Text(sub, style: AppTextStyles.bodySmall)]));

  Widget _summaryRow(String label, String value) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: AppTextStyles.bodyMedium), Text(value, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary))]));
}
