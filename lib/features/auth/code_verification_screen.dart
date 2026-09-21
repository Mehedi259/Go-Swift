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
      appBar: AppBar(backgroundColor: AppColors.background,
        leading: GestureDetector(onTap: () => Navigator.pop(context),
          child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 32),
          Container(width: 72, height: 72, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: AppColors.cyan.withOpacity(0.3))),
            child: const Icon(Icons.sms_outlined, color: AppColors.cyan, size: 32)),
          const SizedBox(height: 20),
          Text('Verify Your Identity', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('A 6-digit verification code has been sent to your Bahamas mobile number +1 (242) 555-0199', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 36),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) => SizedBox(width: 48, child: TextFormField(
              controller: _controllers[i], textAlign: TextAlign.center, maxLength: 1,
              keyboardType: TextInputType.number, style: AppTextStyles.headlineMedium,
              decoration: InputDecoration(counterText: '', filled: true, fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cyan, width: 2))),
            )))),
          const SizedBox(height: 32),
          GSButton(label: 'Verify & Continue →', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false)),
          const SizedBox(height: 20),
          GestureDetector(onTap: () {},
            child: RichText(text: TextSpan(text: "Didn't receive the code? ", style: AppTextStyles.bodyMedium,
              children: [TextSpan(text: 'Resend', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan, fontWeight: FontWeight.w700))]))),
          const SizedBox(height: 12),
          Text('Code expires in 5:00', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold)),
        ]),
      ),
    );
  }
}
