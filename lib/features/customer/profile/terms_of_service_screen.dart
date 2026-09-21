import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Terms of Service', style: AppTextStyles.titleLarge),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Go Swift Terms of Service', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text('Last Updated: May 20, 2026', style: AppTextStyles.bodySmall),
            const SizedBox(height: 24),
            Text('1. Acceptance of Terms', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text('By accessing or using the Go Swift app, you agree to be bound by these Terms. If you disagree with any part of the terms, you may not access our services.', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            Text('2. User Accounts', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text('You are responsible for safeguarding your password and for all activities that occur under your account. You must notify Go Swift immediately upon becoming aware of any breach of security or unauthorized use of your account.', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            Text('3. Service Availability', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text('While we strive to provide 24/7 service across Nassau and Paradise Island, availability may vary based on demand, weather conditions, or unforeseen circumstances.', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            Text('4. Payments & Refunds', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text('All payments are processed securely. Refund requests are handled on a case-by-case basis by our Customer Support team.', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
