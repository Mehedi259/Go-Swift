import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Privacy Policy', style: AppTextStyles.titleLarge),
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
            Text('Go Swift Privacy Policy', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text('Last Updated: May 20, 2026', style: AppTextStyles.bodySmall),
            const SizedBox(height: 24),
            Text('1. Data Collection', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text('We collect personal data required to provide our luxury transportation and delivery services across the Bahamas. This includes your name, contact information, location data, and payment details.', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            Text('2. How We Use Your Data', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text('Your data is used exclusively to facilitate rides, deliveries, property rentals, and customer support. Location data is shared with your assigned chauffeur or courier only during active service.', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            Text('3. Data Protection', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text('Go Swift employs industry-standard encryption to protect your sensitive information. We do not sell your personal data to third parties under any circumstances.', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            Text('4. Your Rights', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text('You have the right to request access to, correction of, or deletion of your personal data at any time by contacting Go Swift Customer Support.', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
