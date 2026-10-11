import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class DriverDocumentsScreen extends StatelessWidget {
  const DriverDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final docs = [
      {'title': 'Public Service Driver\'s License', 'status': 'Verified', 'expiry': 'Dec 2027', 'color': AppColors.green, 'bg': AppColors.greenLight},
      {'title': 'Vehicle Registration', 'status': 'Verified', 'expiry': 'Mar 2027', 'color': AppColors.green, 'bg': AppColors.greenLight},
      {'title': 'Vehicle Insurance', 'status': 'Verified', 'expiry': 'Jun 2026', 'color': AppColors.green, 'bg': AppColors.greenLight},
      {'title': 'Background Check', 'status': 'Approved', 'expiry': 'Annual', 'color': AppColors.cyan, 'bg': AppColors.cyanLight},
      {'title': 'Chauffeur Badge Photo', 'status': 'Pending Review', 'expiry': '—', 'color': AppColors.gold, 'bg': AppColors.goldLight},
    ];

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
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Text('Documents', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Upload and manage your required driver documents and state certifications.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 20),
          ...docs.map((d) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: d['bg'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.description_outlined, color: d['color'] as Color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d['title'] as String, style: AppTextStyles.titleMedium),
                          const SizedBox(height: 2),
                          Text('Expires: ${d['expiry']}', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: d['bg'] as Color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            d['status'] as String,
                            style: AppTextStyles.caption.copyWith(color: d['color'] as Color, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Icon(Icons.upload_file_outlined, color: AppColors.cyan, size: 20),
                      ],
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 20),
          GSButton(
            label: 'Upload New Document',
            isSecondary: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
