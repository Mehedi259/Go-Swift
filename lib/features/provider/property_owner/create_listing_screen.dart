import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class CreateListingScreen extends StatelessWidget {
  const CreateListingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Create New Listing', style: AppTextStyles.titleLarge)),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Photo upload
          Text('PROPERTY PHOTOS', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          Container(height: 120, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.add_photo_alternate_outlined, color: AppColors.textSecondary, size: 32), const SizedBox(height: 8), Text('Upload Photos', style: AppTextStyles.bodyMedium)])),
          const SizedBox(height: 20),
          _field('Property Name', Icons.villa_outlined, 'e.g. Ocean Club Villa #4'),
          const SizedBox(height: 16),
          _field('Property Type', Icons.home_outlined, 'e.g. Oceanfront Villa / Penthouse'),
          const SizedBox(height: 16),
          _field('Location / Address', Icons.location_on_outlined, 'e.g. One Ocean Drive, Paradise Island'),
          const SizedBox(height: 16),
          _field('Nightly Rate (BSD)', Icons.attach_money, 'e.g. 1850'),
          const SizedBox(height: 16),
          Row(children: [Expanded(child: _field('Bedrooms', Icons.bed_outlined, '5')), const SizedBox(width: 12), Expanded(child: _field('Bathrooms', Icons.bathroom_outlined, '6')), const SizedBox(width: 12), Expanded(child: _field('Max Guests', Icons.people_outline, '12'))]),
          const SizedBox(height: 16),
          Text('DESCRIPTION', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          TextFormField(maxLines: 4, style: AppTextStyles.bodyMedium, decoration: const InputDecoration(hintText: 'Describe your property, amenities, and unique features...')),
          const SizedBox(height: 16),
          Text('AMENITIES', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: ['Private Pool', 'Ocean View', 'Butler Service', 'Private Beach', 'Gym & Spa', 'Yacht Access', 'Home Cinema', 'Golf Cart'].map((a) => GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)), child: Text(a, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))))).toList()),
        ]))),
        Padding(padding: const EdgeInsets.all(20), child: GSButton(label: 'Create Listing →', onTap: () => Navigator.pop(context))),
      ]),
    );
  }
  Widget _field(String label, IconData icon, String hint) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label.toUpperCase(), style: AppTextStyles.labelSmall), const SizedBox(height: 8), TextFormField(style: AppTextStyles.bodyLarge, decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20)))]);
}
