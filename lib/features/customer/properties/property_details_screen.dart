import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Container(height: 240, color: const Color(0xFF1A2B40), child: Stack(children: [
          Center(child: Icon(Icons.villa, color: AppColors.textMuted, size: 64)),
          Positioned(top: 12, left: 12, child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.background.withOpacity(0.85), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))),
          Positioned(top: 12, right: 12, child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.background.withOpacity(0.85), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.favorite_border, color: AppColors.textPrimary, size: 20))),
          Positioned(bottom: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.9), borderRadius: BorderRadius.circular(8)), child: Text('OCEAN CLUB', style: AppTextStyles.labelSmall.copyWith(color: AppColors.background)))),
          Positioned(bottom: 12, right: 12, child: GSRatingRow(rating: 4.98, reviews: 87)),
        ])),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('OCEANFRONT VILLA', style: AppTextStyles.cyanLabel),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text('The Ocean Club Villa', style: AppTextStyles.headlineLarge)), Text('\$1,850/night', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold))]),
          const SizedBox(height: 4),
          Row(children: [const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textSecondary), const SizedBox(width: 4), Text('Paradise Island • 0.2 miles from beach', style: AppTextStyles.bodySmall)]),
          const SizedBox(height: 16),
          Row(children: [_stat('5', 'Bedrooms', Icons.bed_outlined), const SizedBox(width: 12), _stat('6', 'Bathrooms', Icons.bathroom_outlined), const SizedBox(width: 12), _stat('12', 'Max Guests', Icons.people_outline)]),
          const SizedBox(height: 20),
          Text('About This Property', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text('Exquisite oceanfront villa at The Ocean Club, Paradise Island. Features private infinity pool, direct beach access, dedicated butler service, and panoramic views of the Atlantic Ocean. Fully equipped gourmet kitchen, home cinema, and 24/7 concierge.', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 20),
          Text('Amenities', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: ['Private Pool', 'Ocean View', 'Butler Service', 'Private Beach', 'Home Cinema', 'Chef Kitchen', 'Yacht Access', 'Gym & Spa', 'Golf Cart'].map((a) => _amenity(a)).toList()),
          const SizedBox(height: 20),
          Text('Included Services', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          ...[
            {'icon': Icons.cleaning_services_outlined, 'l': 'Daily Housekeeping', 's': 'Professional housekeeping twice daily'},
            {'icon': Icons.room_service_outlined, 'l': 'Butler Service', 's': '24/7 personal butler included'},
            {'icon': Icons.local_parking, 'l': 'Private Parking', 's': 'Secure on-site parking for 4 vehicles'},
          ].map((s) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: Icon(s['icon'] as IconData, color: AppColors.textSecondary, size: 20)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(s['l'] as String, style: AppTextStyles.titleMedium), Text(s['s'] as String, style: AppTextStyles.bodySmall)])]))),
          const SizedBox(height: 20),
          Text('Select Dates', style: AppTextStyles.headlineSmall), const SizedBox(height: 12),
          Row(children: [
            Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Column(children: [Text('Check In', style: AppTextStyles.bodySmall), const SizedBox(height: 4), Text('Apr 21', style: AppTextStyles.titleMedium)]))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: const Icon(Icons.arrow_forward, color: AppColors.textSecondary, size: 20)),
            Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Column(children: [Text('Check Out', style: AppTextStyles.bodySmall), const SizedBox(height: 4), Text('Apr 26', style: AppTextStyles.titleMedium)]))),
          ]),
        ]))),
        Padding(padding: const EdgeInsets.all(20), child: GSButton(label: 'Reserve Property →', onTap: () => Navigator.pushNamed(context, '/customer/properties/booking'))),
      ])),
    );
  }
  Widget _stat(String val, String label, IconData icon) => Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 0.5)), child: Column(children: [Icon(icon, color: AppColors.cyan, size: 18), const SizedBox(height: 4), Text(val, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.cyan)), Text(label, style: AppTextStyles.bodySmall)])));
  Widget _amenity(String label) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.check, size: 12, color: AppColors.cyan), const SizedBox(width: 4), Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))]));
}
