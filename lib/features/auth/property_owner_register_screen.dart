import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class PropertyOwnerRegisterScreen extends StatelessWidget {
  const PropertyOwnerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background,
        leading: GestureDetector(onTap: () => Navigator.pop(context),
          child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('LUXURY VILLA & RESORT CONCIERGE', style: AppTextStyles.cyanLabel),
        const SizedBox(height: 8),
        Text('List Your Property', style: AppTextStyles.displayMedium),
        const SizedBox(height: 8),
        Text('Offer oceanfront villas, penthouses, and private estates to elite island travelers.', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 28),
        _field('Full Legal Name', Icons.person_outline, 'e.g. Victoria Stubbs'),
        const SizedBox(height: 16),
        _field('Property Name', Icons.villa_outlined, 'e.g. Ocean Club Villa #4'),
        const SizedBox(height: 16),
        _field('Email Address', Icons.mail_outline, 'victoria@villaresort.bs'),
        const SizedBox(height: 16),
        _field('Bahamas Mobile', Icons.phone_outlined, '+1 (242) 555-0000'),
        const SizedBox(height: 16),
        _field('Property License / Permit', Icons.badge_outlined, 'HPL-000000-NP'),
        const SizedBox(height: 16),
        _field('Password', Icons.lock_outline, ''),
        const SizedBox(height: 24),
        GSButton(label: 'Register & Continue →', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/provider/property/listings', (_) => false)),
        const SizedBox(height: 32),
      ])),
    );
  }

  Widget _field(String label, IconData icon, String hint) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: AppTextStyles.labelSmall),
      const SizedBox(height: 8),
      TextFormField(style: AppTextStyles.bodyLarge, obscureText: label.contains('Password'),
        decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20))),
    ]);
  }
}
