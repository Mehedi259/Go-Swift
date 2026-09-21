import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class PropertiesSearchScreen extends StatelessWidget {
  const PropertiesSearchScreen({super.key});
  final _properties = const [
    {'name': 'The Ocean Club Villa', 'type': 'OCEANFRONT VILLA', 'location': 'Paradise Island • 0.2 miles from beach', 'price': '\$1,850/night', 'rating': 4.98, 'reviews': 87, 'badge': 'OCEAN CLUB', 'beds': 5, 'baths': 6},
    {'name': 'Atlantis Royal Suite', 'type': 'RESORT PENTHOUSE', 'location': 'Atlantis Paradise Island • Lagoon view', 'price': '\$2,200/night', 'rating': 4.95, 'reviews': 62, 'badge': 'ATLANTIS', 'beds': 3, 'baths': 4},
    {'name': 'Lyford Cay Estate', 'type': 'PRIVATE ESTATE', 'location': 'Lyford Cay • Gated community • Golf access', 'price': '\$4,500/night', 'rating': 5.0, 'reviews': 28, 'badge': 'LYFORD CAY', 'beds': 7, 'baths': 8},
    {'name': 'Baha Mar Oceanview Villa', 'type': 'RESORT VILLA', 'location': 'Cable Beach • Direct ocean access', 'price': '\$1,200/night', 'rating': 4.92, 'reviews': 145, 'badge': 'BAHA MAR', 'beds': 3, 'baths': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Rooms & Properties', style: AppTextStyles.headlineLarge), Text('LUXURY VILLA & RESORT CONCIERGE', style: AppTextStyles.cyanLabel)])),
        ])),
        // Search & filter
        Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 12), child: Column(children: [
          Row(children: [
            Expanded(child: TextFormField(style: AppTextStyles.bodyLarge, decoration: const InputDecoration(hintText: 'Search properties, villas, resorts...', prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 20), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
            const SizedBox(width: 8),
            Container(width: 44, height: 44, decoration: BoxDecoration(gradient: AppColors.cyanGradient, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.tune, color: AppColors.background, size: 20)),
          ]),
          const SizedBox(height: 8),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
            _filterChip('All Properties', true), const SizedBox(width: 8),
            _filterChip('Oceanfront', false), const SizedBox(width: 8),
            _filterChip('Private Pool', false), const SizedBox(width: 8),
            _filterChip('Beachfront', false),
          ])),
        ])),
        Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: _properties.length, itemBuilder: (c, i) => _PropertyCard(p: _properties[i]))),
      ])),
      bottomNavigationBar: _nav(context),
    );
  }

  Widget _filterChip(String l, bool active) => Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(gradient: active ? AppColors.cyanGradient : null, color: active ? null : AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: active ? Colors.transparent : AppColors.border)),
    child: Text(l, style: AppTextStyles.bodySmall.copyWith(color: active ? AppColors.background : AppColors.textPrimary, fontWeight: FontWeight.w600)));

  Widget _nav(BuildContext context) => Container(decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.border, width: 0.5))),
    child: SafeArea(top: false, child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      _ni(Icons.home, 'Home', true, () => Navigator.pop(context)),
      _ni(Icons.receipt_long_outlined, 'History', false, () {}),
      _ni(Icons.favorite_border, 'Favorites', false, () {}),
      _ni(Icons.headset_mic_outlined, 'Support', false, () {}),
      _ni(Icons.person_outline, 'Profile', false, () {}),
    ]))));

  Widget _ni(IconData icon, String label, bool active, VoidCallback onTap) => GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: active ? AppColors.cyan : AppColors.textMuted, size: 24), const SizedBox(height: 4), Text(label, style: AppTextStyles.caption.copyWith(color: active ? AppColors.cyan : AppColors.textMuted))]));
}

class _PropertyCard extends StatelessWidget {
  final Map<String, dynamic> p;
  const _PropertyCard({required this.p});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/properties/details'),
      child: Container(margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 160, decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)), gradient: LinearGradient(colors: [Color(0xFF1A2B40), Color(0xFF0A1520)])),
            child: Stack(children: [
              Center(child: Icon(Icons.villa, color: AppColors.textMuted, size: 48)),
              Positioned(top: 10, left: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.8), borderRadius: BorderRadius.circular(8)), child: Text(p['badge'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold)))),
              Positioned(top: 10, right: 10, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.background.withOpacity(0.8), shape: BoxShape.circle), child: const Icon(Icons.favorite_border, color: AppColors.textPrimary, size: 16))),
              Positioned(bottom: 10, right: 10, child: GSRatingRow(rating: p['rating'] as double, reviews: p['reviews'] as int)),
            ])),
          Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p['type'] as String, style: AppTextStyles.cyanLabel),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(p['name'] as String, style: AppTextStyles.headlineSmall)), Text(p['price'] as String, style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold))]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textSecondary), const SizedBox(width: 4), Expanded(child: Text(p['location'] as String, style: AppTextStyles.bodySmall))]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.bed_outlined, size: 14, color: AppColors.textSecondary), const SizedBox(width: 4), Text('${p['beds']} beds', style: AppTextStyles.bodySmall), const SizedBox(width: 12), const Icon(Icons.bathroom_outlined, size: 14, color: AppColors.textSecondary), const SizedBox(width: 4), Text('${p['baths']} baths', style: AppTextStyles.bodySmall), const SizedBox(width: 12), const Icon(Icons.pool, size: 14, color: AppColors.cyan), const SizedBox(width: 4), Text('Private Pool', style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan))]),
          ])),
        ])));
  }
}
