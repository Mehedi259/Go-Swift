import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class RentalProviderRegisterScreen extends StatelessWidget {
  const RentalProviderRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.badgeTeal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'CAR RENTAL & FLEET OWNER',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text('Register Your Fleet', style: AppTextStyles.displayMedium),
            const SizedBox(height: 8),
            Text(
              'List prestige vehicles for vetted tourist and executive clients across the Bahamas.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 28),
            _field('Full Legal Name', Icons.person_outline, 'e.g. James Thompson'),
            const SizedBox(height: 16),
            _field('Business / Email Address', Icons.mail_outline, 'business@example.bs'),
            const SizedBox(height: 16),
            _field('Bahamas Mobile', Icons.phone_outlined, '+1 (242) 555-0000'),
            const SizedBox(height: 16),
            _field('Business License No.', Icons.badge_outlined, 'BL-000000-NP'),
            const SizedBox(height: 16),
            _field('Password', Icons.lock_outline, 'Create password'),
            const SizedBox(height: 24),
            GSButton(
              label: 'Register & Continue →',
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/provider/rental/vehicles', (_) => false),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/customer/login'),
                child: RichText(
                  text: TextSpan(
                    text: 'Already registered? ',
                    style: AppTextStyles.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Log In →',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, IconData icon, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.labelSmall),
        const SizedBox(height: 8),
        TextFormField(
          style: AppTextStyles.bodyLarge,
          obscureText: label.contains('Password'),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primaryTeal, size: 20),
          ),
        ),
      ],
    );
  }
}
