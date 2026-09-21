import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class CourierRequestScreen extends StatefulWidget {
  const CourierRequestScreen({super.key});
  @override State<CourierRequestScreen> createState() => _CourierRequestScreenState();
}
class _CourierRequestScreenState extends State<CourierRequestScreen> {
  int _type = 0;
  final _types = [
    {'icon': Icons.laptop_mac_outlined, 'label': 'Standard Package', 'sub': 'Up to 20 lbs • Standard tracking'},
    {'icon': Icons.gavel, 'label': 'Bonded Legal Document', 'sub': 'Chain-of-custody • Notarized delivery'},
    {'icon': Icons.diamond_outlined, 'label': 'Luxury Retail', 'sub': 'White-glove • Temperature controlled'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Row(children: [Text('GO ', style: AppTextStyles.titleLarge.copyWith(color: Colors.white)), Text('SWIFT', style: AppTextStyles.titleLarge.copyWith(color: AppColors.cyan)), const SizedBox(width: 8), Text('Courier & Delivery', style: AppTextStyles.titleLarge)])),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('SECURE ON-DEMAND PARCEL DISPATCH', style: AppTextStyles.cyanLabel),
          const SizedBox(height: 8),
          Text('Request a Courier', style: AppTextStyles.displayMedium),
          const SizedBox(height: 8),
          Text('Bonded parcel delivery, diplomatic dispatch, and luxury retail courier across Nassau & Family Islands.', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 24),
          Text('Pickup Location', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          TextFormField(style: AppTextStyles.bodyLarge, decoration: const InputDecoration(hintText: 'e.g. Graycliff Boutique, Downtown Nassau', prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.cyan, size: 20))),
          const SizedBox(height: 16),
          Text('Delivery Destination', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          TextFormField(style: AppTextStyles.bodyLarge, decoration: const InputDecoration(hintText: 'e.g. The Ocean Club, Paradise Island', prefixIcon: Icon(Icons.flag_outlined, color: AppColors.gold, size: 20))),
          const SizedBox(height: 20),
          Text('Package Type', style: AppTextStyles.headlineSmall), const SizedBox(height: 12),
          ..._types.asMap().entries.map((e) => GestureDetector(onTap: () => setState(() => _type = e.key),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: _type == e.key ? AppColors.cyan : AppColors.border, width: _type == e.key ? 1.5 : 0.5)),
              child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: _type == e.key ? AppColors.cyan.withOpacity(0.15) : AppColors.surface, borderRadius: BorderRadius.circular(10)), child: Icon(e.value['icon'] as IconData, color: _type == e.key ? AppColors.cyan : AppColors.textSecondary, size: 20)),
                const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e.value['label'] as String, style: AppTextStyles.titleMedium), Text(e.value['sub'] as String, style: AppTextStyles.bodySmall)])),
                Container(width: 22, height: 22, decoration: BoxDecoration(color: _type == e.key ? AppColors.cyan : Colors.transparent, shape: BoxShape.circle, border: Border.all(color: _type == e.key ? AppColors.cyan : AppColors.border)), child: _type == e.key ? const Icon(Icons.check, size: 12, color: AppColors.background) : null)])))),
          const SizedBox(height: 20),
          Text('Recipient Name', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          TextFormField(style: AppTextStyles.bodyLarge, decoration: const InputDecoration(hintText: 'Full name of recipient', prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary, size: 20))),
          const SizedBox(height: 12),
          Text('Recipient Phone', style: AppTextStyles.labelSmall), const SizedBox(height: 8),
          TextFormField(style: AppTextStyles.bodyLarge, decoration: const InputDecoration(hintText: '+1 (242) 555-0199', prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 20))),
        ]))),
        Padding(padding: const EdgeInsets.all(20), child: GSButton(label: 'Find Courier →', onTap: () => Navigator.pushNamed(context, '/customer/courier/status'))),
      ]),
    );
  }
}
