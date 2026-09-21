import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/gs_button.dart';
import '../../../../core/widgets/gs_text_field.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Personal Information', style: AppTextStyles.titleLarge),
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
            const GSTextField(label: 'Full Name', hint: 'Alexander Vance', prefixIcon: Icons.person_outline),
            const SizedBox(height: 16),
            const GSTextField(label: 'Email Address', hint: 'alexander@example.com', prefixIcon: Icons.email_outlined),
            const SizedBox(height: 16),
            const GSTextField(label: 'Phone Number', hint: '+1 (242) 555-0199', prefixIcon: Icons.phone_outlined),
            const SizedBox(height: 32),
            GSButton(label: 'Save Changes', onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
