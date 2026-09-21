import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class DriverDocumentsScreen extends StatelessWidget {
  const DriverDocumentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final docs = [
      {'title': 'Public Service Driver\'s License', 'status': 'Verified', 'expiry': 'Dec 2027', 'color': AppColors.green},
      {'title': 'Vehicle Registration', 'status': 'Verified', 'expiry': 'Mar 2027', 'color': AppColors.green},
      {'title': 'Vehicle Insurance', 'status': 'Verified', 'expiry': 'Jun 2026', 'color': AppColors.green},
      {'title': 'Background Check', 'status': 'Approved', 'expiry': 'Annual', 'color': AppColors.cyan},
      {'title': 'Chauffeur Badge Photo', 'status': 'Pending Review', 'expiry': '—', 'color': AppColors.gold},
    ];
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        title: Text('Documents', style: AppTextStyles.titleLarge)),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text('Upload and manage your required driver documents.', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 20),
        ...docs.map((d) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
          child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: (d['color'] as Color).withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.description_outlined, color: d['color'] as Color, size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(d['title'] as String, style: AppTextStyles.titleMedium), Text('Expires: ${d['expiry']}', style: AppTextStyles.bodySmall)])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: (d['color'] as Color).withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Text(d['status'] as String, style: AppTextStyles.caption.copyWith(color: d['color'] as Color))),
              const SizedBox(height: 4), const Icon(Icons.upload_file_outlined, color: AppColors.textMuted, size: 18),
            ]),
          ]))),
        const SizedBox(height: 16),
        GSButton(label: 'Upload New Document', isSecondary: true, onTap: () {}),
      ]),
    );
  }
}
