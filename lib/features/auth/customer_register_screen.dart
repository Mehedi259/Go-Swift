import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class CustomerRegisterScreen extends StatelessWidget {
  const CustomerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: GestureDetector(onTap: () => Navigator.pop(context),
          child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Row(children: [
          Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.bolt, color: AppColors.background, size: 18)),
          const SizedBox(width: 8), Text('Customer Profile Setup', style: AppTextStyles.titleLarge),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          Text('BAHAMAS PREMIER MOBILITY & CONCIERGE', style: AppTextStyles.goldLabel),
          const SizedBox(height: 8),
          Text('Create Your Account', style: AppTextStyles.displayMedium),
          const SizedBox(height: 28),
          _buildField('FULL NAME', 'Marcus Vance', Icons.person_outline),
          const SizedBox(height: 20),
          _buildField('EMAIL ADDRESS', 'marcus.vance@swiftbahamas.com', Icons.mail_outline),
          const SizedBox(height: 20),
          Text('MOBILE PHONE', style: AppTextStyles.labelSmall),
          const SizedBox(height: 8),
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Row(children: [Text('🇧🇸 +1 (242)', style: AppTextStyles.bodyLarge), const SizedBox(width: 4), const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary)])),
            const SizedBox(width: 8),
            Expanded(child: TextFormField(style: AppTextStyles.bodyLarge, decoration: const InputDecoration(hintText: '555-0199'))),
          ]),
          const SizedBox(height: 6),
          Row(children: [const Icon(Icons.verified_user_outlined, size: 12, color: AppColors.textSecondary), const SizedBox(width: 6),
            Expanded(child: Text('Used for SMS driver alerts and ride verifications in the Bahamas.', style: AppTextStyles.bodySmall))]),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('PASSWORD', style: AppTextStyles.labelSmall), Text('Min. 8 characters', style: AppTextStyles.bodySmall)]),
          const SizedBox(height: 8),
          TextFormField(obscureText: true, style: AppTextStyles.bodyLarge,
            decoration: InputDecoration(prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 20),
              suffixIcon: const Icon(Icons.visibility_outlined, color: AppColors.textSecondary, size: 20))),
          const SizedBox(height: 6),
          LinearProgressIndicator(value: 0.0, backgroundColor: AppColors.border, color: AppColors.cyan),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Security: Minimum 8 characters', style: AppTextStyles.bodySmall), Text('0/8', style: AppTextStyles.bodySmall)]),
          const SizedBox(height: 20),
          Text('CONFIRM PASSWORD', style: AppTextStyles.labelSmall),
          const SizedBox(height: 8),
          TextFormField(obscureText: true, style: AppTextStyles.bodyLarge,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.lock_clock_outlined, color: AppColors.textSecondary, size: 20))),
          const SizedBox(height: 20),
          RichText(text: TextSpan(text: 'I acknowledge and agree to the ', style: AppTextStyles.bodySmall,
            children: [
              TextSpan(text: 'Terms of Service', style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan, decoration: TextDecoration.underline)),
              TextSpan(text: ' and ', style: AppTextStyles.bodySmall),
              TextSpan(text: 'Privacy Policy', style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan, decoration: TextDecoration.underline)),
              TextSpan(text: ' governing island concierge and transportation services.', style: AppTextStyles.bodySmall),
            ])),
          const SizedBox(height: 24),
          GSButton(label: 'Create Account →', onTap: () => Navigator.pushNamed(context, '/verify-code')),
          const SizedBox(height: 16),
          Center(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/login'),
            child: RichText(text: TextSpan(text: 'Already have a GO SWIFT account? ', style: AppTextStyles.bodyMedium,
              children: [TextSpan(text: 'Log In →', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan, fontWeight: FontWeight.w700))])))),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  Widget _buildField(String label, String hint, IconData icon) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.labelSmall),
      const SizedBox(height: 8),
      TextFormField(style: AppTextStyles.bodyLarge, decoration: InputDecoration(hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20))),
    ]);
  }
}
