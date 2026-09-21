import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background,
        leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Change Password', style: AppTextStyles.titleLarge)),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Update your security credentials.', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 24),
        _field('Current Password', 'Enter current password'),
        const SizedBox(height: 16),
        _field('New Password', 'Min. 8 characters'),
        const SizedBox(height: 16),
        _field('Confirm New Password', 'Re-enter new password'),
        const SizedBox(height: 32),
        GSButton(label: 'Update Password →', onTap: () => Navigator.pop(context)),
      ])),
    );
  }
  Widget _field(String label, String hint) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label.toUpperCase(), style: AppTextStyles.labelSmall), const SizedBox(height: 8), TextFormField(obscureText: true, style: AppTextStyles.bodyLarge, decoration: InputDecoration(hintText: hint, prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 20), suffixIcon: const Icon(Icons.visibility_outlined, color: AppColors.textSecondary, size: 20)))]);
}
