import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_text_field.dart';

class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.softShadow,
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text('Customer Profile Sign In', style: AppTextStyles.titleLarge),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Lock icon
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.cyanLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cyan.withOpacity(0.25), width: 1.5),
                        boxShadow: AppColors.softShadow,
                      ),
                      child: const Icon(Icons.lock_outline, color: AppColors.cyan, size: 32),
                    ),
                    const SizedBox(height: 20),
                    Text('Customer Sign In', style: AppTextStyles.displayMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome back to frictionless island transit and luxury living.',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Email field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Email or Bahamas Mobile', style: AppTextStyles.labelSmall),
                        Text('NASSAU • OUT ISLANDS', style: AppTextStyles.cyanLabel),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: AppTextStyles.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: 'marcus.vance@swiftbahamas.com or +1 (242) 555-0199',
                        prefixIcon: Icon(Icons.alternate_email, color: AppColors.textSecondary, size: 20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Password', style: AppTextStyles.labelSmall),
                        GestureDetector(
                          onTap: () {},
                          child: Text('Forgot password?', style: AppTextStyles.cyanLabel),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const GSTextField(
                      label: '',
                      hint: 'Enter your security credentials',
                      isPassword: true,
                      prefixIcon: Icons.key_outlined,
                    ),
                    const SizedBox(height: 28),
                    GSButton(label: 'Sign In →', onTap: () => Navigator.pushNamed(context, '/verify-code')),
                    const SizedBox(height: 20),
                    // Register card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 0.8),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('NEW TO GO SWIFT?', style: AppTextStyles.goldLabel),
                                const SizedBox(height: 2),
                                Text(
                                  'Open your account',
                                  style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/customer/register'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.cyanPill,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Register',
                                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.north_east, size: 14, color: AppColors.cyan),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Footer
                    Column(
                      children: [
                        const Icon(Icons.verified_user_outlined, color: AppColors.textMuted, size: 18),
                        const SizedBox(height: 6),
                        Text(
                          'OFFICIAL TRANSPORT PARTNER',
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted, letterSpacing: 0.8),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'LICENSED BY THE ROAD TRAFFIC DEPARTMENT OF THE BAHAMAS',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
