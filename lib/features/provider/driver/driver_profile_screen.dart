import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class DriverProfileScreen extends StatelessWidget {
  final bool embedded;
  const DriverProfileScreen({super.key, this.embedded = false});
  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(child: Column(children: [
      Container(padding: const EdgeInsets.fromLTRB(20, 20, 20, 24), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0A1520), Color(0xFF0D1117)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(children: [
          if (embedded) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Profile', style: AppTextStyles.headlineLarge), Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.settings_outlined, color: AppColors.textSecondary, size: 20))]),
          if (embedded) const SizedBox(height: 20),
          Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle, border: Border.all(color: AppColors.cyan.withOpacity(0.4), width: 3)), child: const Icon(Icons.person, color: AppColors.background, size: 40)),
          const SizedBox(height: 12), Text('Captain Terrence Rolle', style: AppTextStyles.headlineMedium), Text('VIP Chauffeur  •  #CH-402', style: AppTextStyles.cyanLabel),
          const SizedBox(height: 8), Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.star, color: AppColors.gold, size: 14), const SizedBox(width: 4), Text('4.98 rating  •  620 completed trips', style: AppTextStyles.bodySmall)]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _s('620', 'Trips')), Expanded(child: _s('\$28,400', 'Earned')), Expanded(child: _s('4.98', 'Rating')),
          ]),
        ])),
      Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Driver Details', style: AppTextStyles.headlineSmall), const SizedBox(height: 12),
        _infoTile(Icons.badge_outlined, 'License', 'PSL-40291-NP  •  Expires Dec 2027'),
        _infoTile(Icons.directions_car, 'Vehicle', 'Cadillac Escalade ESV  •  BS-942-EX'),
        _infoTile(Icons.payment, 'Payout Account', 'Bank of Bahamas  •  ••••8921'),
        _infoTile(Icons.location_on_outlined, 'Service Zone', 'Nassau  •  Paradise Island  •  Cable Beach'),
        const SizedBox(height: 20),
        GSButton(label: 'Edit Profile', isSecondary: true, onTap: () {}),
        const SizedBox(height: 12),
        GSButton(label: 'Sign Out', isSecondary: true, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/choose-account', (_) => false)),
      ])),
    ]));
    return embedded ? content : Scaffold(appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))), title: Text('Driver Profile', style: AppTextStyles.titleLarge)), body: content);
  }
  Widget _s(String v, String l) => Column(children: [Text(v, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold)), Text(l, style: AppTextStyles.bodySmall)]);
  Widget _infoTile(IconData icon, String label, String val) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)), child: Row(children: [Icon(icon, color: AppColors.textSecondary, size: 20), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: AppTextStyles.bodySmall), Text(val, style: AppTextStyles.titleMedium)])]));
}
