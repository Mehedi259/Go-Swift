import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class CustomerProfileScreen extends StatelessWidget {
  final bool embedded;
  const CustomerProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final content = Column(children: [
      // Header
      Container(padding: const EdgeInsets.fromLTRB(20, 20, 20, 24), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0A1520), Color(0xFF0D1117)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Profile', style: AppTextStyles.headlineLarge), GestureDetector(onTap: () {}, child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.settings_outlined, color: AppColors.textSecondary, size: 20)))]),
          const SizedBox(height: 20),
          Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle, border: Border.all(color: AppColors.cyan.withOpacity(0.4), width: 3)), child: const Icon(Icons.person, color: AppColors.background, size: 40)),
          const SizedBox(height: 12),
          Text('Alexander Vance', style: AppTextStyles.headlineMedium),
          Text('Platinum Member', style: AppTextStyles.cyanLabel),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.star, color: AppColors.gold, size: 14), const SizedBox(width: 4), Text('4.98 rating • 62 completed trips', style: AppTextStyles.bodySmall),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _stat('62', 'Total Trips')), Expanded(child: _stat('\$4,830', 'Total Spent')), Expanded(child: _stat('Gold', 'Status')),
          ]),
        ])),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
        _section('Account Details', [
          _tile(Icons.person_outline, 'Personal Information', 'Update name, email & phone', () {}),
          _tile(Icons.lock_outline, 'Change Password', 'Update security credentials', () => Navigator.pushNamed(context, '/customer/profile/change-password')),
          _tile(Icons.credit_card, 'Payment Methods', 'Cards, wallets & billing', () {}),
          _tile(Icons.location_on_outlined, 'Saved Addresses', 'Home, work & frequent stops', () {}),
        ]),
        const SizedBox(height: 16),
        _section('Preferences', [
          _tile(Icons.notifications_none_outlined, 'Notification Settings', 'Alerts and push notifications', () {}),
          _tile(Icons.language, 'Language & Region', 'English (Bahamas)', () {}),
          _tile(Icons.dark_mode_outlined, 'Appearance', 'Dark Mode • Active', () {}),
        ]),
        const SizedBox(height: 16),
        _section('Support & Legal', [
          _tile(Icons.headset_mic_outlined, 'Customer Support', 'Live concierge chat', () => Navigator.pushNamed(context, '/customer/support')),
          _tile(Icons.policy_outlined, 'Privacy Policy', 'How we use your data', () {}),
          _tile(Icons.article_outlined, 'Terms of Service', 'User agreement', () {}),
        ]),
        const SizedBox(height: 20),
        GSButton(label: 'Sign Out', isSecondary: true, onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/choose-account', (_) => false)),
        const SizedBox(height: 24),
      ]))),
    ]);
    return embedded ? content : Scaffold(body: SafeArea(child: content));
  }

  Widget _stat(String val, String label) => Column(children: [Text(val, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold)), Text(label, style: AppTextStyles.bodySmall)]);

  Widget _section(String title, List<Widget> tiles) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: AppTextStyles.headlineSmall), const SizedBox(height: 12), Container(decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)), child: Column(children: tiles.asMap().entries.map((e) => e.key < tiles.length - 1 ? Column(children: [e.value, const Divider(color: AppColors.border, height: 1, indent: 56)]) : e.value).toList()))]);

  Widget _tile(IconData icon, String title, String sub, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(14), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.textSecondary, size: 20)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: AppTextStyles.titleMedium), Text(sub, style: AppTextStyles.bodySmall)])), const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20)])));
}

