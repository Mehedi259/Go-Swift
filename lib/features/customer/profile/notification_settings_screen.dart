import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool pushEnabled = true;
  bool smsEnabled = true;
  bool emailEnabled = false;
  bool promoEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Notifications', style: AppTextStyles.titleLarge),
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
          children: [
            _toggleTile('Push Notifications', 'Trip status and important alerts', pushEnabled, (v) => setState(() => pushEnabled = v)),
            const SizedBox(height: 12),
            _toggleTile('SMS Alerts', 'Driver arrival and verification codes', smsEnabled, (v) => setState(() => smsEnabled = v)),
            const SizedBox(height: 12),
            _toggleTile('Email Receipts', 'Trip receipts and monthly summaries', emailEnabled, (v) => setState(() => emailEnabled = v)),
            const SizedBox(height: 12),
            _toggleTile('Promotional Offers', 'Discounts and news from Go Swift', promoEnabled, (v) => setState(() => promoEnabled = v)),
          ],
        ),
      ),
    );
  }

  Widget _toggleTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.background,
            activeTrackColor: AppColors.cyan,
            inactiveThumbColor: AppColors.textMuted,
            inactiveTrackColor: AppColors.surface,
          ),
        ],
      ),
    );
  }
}
