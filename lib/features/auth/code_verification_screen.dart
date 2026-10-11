import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({super.key});

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.softShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
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
            Text('Verify Your Identity', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'A 6-digit cryptographic security code was dispatched\nto your authorized credentials:',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cyanPill,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.mark_email_read_outlined, size: 14, color: AppColors.cyan),
                  const SizedBox(width: 6),
                  Text(
                    'marcus.v***@swiftbahamas.com',
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (i) => SizedBox(
                  width: 48,
                  height: 56,
                  child: TextFormField(
                    controller: _controllers[i],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.cyan, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            GSButton(
              label: 'Verify & Continue →',
              icon: Icons.shield_outlined,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: RichText(
                text: TextSpan(
                  text: "Didn't receive cryptographic code? ",
                  style: AppTextStyles.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'Resend (42s)',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(
                  'OFFICIAL TRANSPORT PARTNER • RTD SOVEREIGN CERTIFIED PROTOCOL',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
