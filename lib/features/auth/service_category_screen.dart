import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class ServiceCategoryScreen extends StatefulWidget {
  const ServiceCategoryScreen({super.key});

  @override
  State<ServiceCategoryScreen> createState() => _ServiceCategoryScreenState();
}

class _ServiceCategoryScreenState extends State<ServiceCategoryScreen> {
  int _selected = 0;

  final _categories = [
    {'icon': Icons.directions_car, 'title': 'Ride Sharing & Chauffeur', 'sub': 'Executive Chauffeured Transit',
     'desc': 'Provide VIP island transit, airport tarmac FBO liaisons, and point-to-point luxury transfers with verified RTD meters.',
     'route': '/provider/driver/register'},
    {'icon': Icons.restaurant, 'title': 'Restaurant Partner', 'sub': 'Fine Dining & Culinary Dispatch',
     'desc': 'List gourmet menus, receive yacht berth orders, and dispatch via temperature-controlled couriers.',
     'route': '/provider/restaurant/register'},
    {'icon': Icons.local_shipping_outlined, 'title': 'Courier & Bonded Logistics', 'sub': 'Secure On-Demand Dispatch',
     'desc': 'Deliver diplomatic parcels, luxury boutique retail, and bonded legal documents with chain-of-custody tracking.',
     'route': '/provider/courier/register'},
    {'icon': Icons.vpn_key_outlined, 'title': 'Car Rental & Fleet Owner', 'sub': 'Private Fleet Management',
     'desc': 'List prestige vehicles, luxury SUVs, and exotic convertibles for vetted tourist and executive clients.',
     'route': '/provider/rental/register'},
    {'icon': Icons.villa_outlined, 'title': 'Room Services & Hospitality', 'sub': 'Luxury Villa & Resort Concierge',
     'desc': 'Provide in-villa private chefs, provisioning, housekeeping, and on-demand luxury estate assistance.',
     'route': '/provider/property/register'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background,
        leading: GestureDetector(onTap: () => Navigator.pop(context),
          child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 8),
            Text('Select Service Category', style: AppTextStyles.displayMedium),
            const SizedBox(height: 8),
            Text('Choose the commercial livery or hospitality tier you wish to license on the GO SWIFT Nassau and Family Islands network.', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            ..._categories.asMap().entries.map((e) => _CategoryCard(
              icon: e.value['icon'] as IconData,
              title: e.value['title'] as String,
              sub: e.value['sub'] as String,
              desc: e.value['desc'] as String,
              isSelected: _selected == e.key,
              onTap: () => setState(() => _selected = e.key),
            )),
            const SizedBox(height: 16),
          ]))),
        Padding(padding: const EdgeInsets.all(20),
          child: GSButton(
            label: 'Continue with ${_categories[_selected]['title']} →',
            onTap: () => Navigator.pushNamed(context, _categories[_selected]['route'] as String),
          )),
      ]),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon; final String title, sub, desc;
  final bool isSelected; final VoidCallback onTap;
  const _CategoryCard({required this.icon, required this.title, required this.sub, required this.desc, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.cyan : AppColors.border, width: isSelected ? 1.5 : 0.5)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: isSelected ? AppColors.cyan.withOpacity(0.15) : AppColors.surface, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: isSelected ? AppColors.cyan : AppColors.textSecondary, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.titleLarge),
            Text(sub, style: AppTextStyles.cyanLabel),
            const SizedBox(height: 6),
            Text(desc, style: AppTextStyles.bodySmall),
          ])),
          Container(width: 22, height: 22, decoration: BoxDecoration(
            color: isSelected ? AppColors.cyan : Colors.transparent, shape: BoxShape.circle,
            border: Border.all(color: isSelected ? AppColors.cyan : AppColors.border)),
            child: isSelected ? const Icon(Icons.check, size: 12, color: AppColors.background) : null),
        ]),
      ),
    );
  }
}
