import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class DriverRideRequestsScreen extends StatelessWidget {
  const DriverRideRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = [
      {'fare': '\$85.00', 'from': 'Lynden Pindling Int\'l (NAS)', 'to': 'The Ocean Club, Paradise Island', 'passenger': 'Alexander Vance', 'dist': '14.2 km'},
      {'fare': '\$105.00', 'from': 'Baha Mar Resort, Cable Beach', 'to': 'Albany Luxury Marina', 'passenger': 'Sarah Jenkins', 'dist': '18.6 km'},
      {'fare': '\$125.00', 'from': 'Atlantis Paradise Island', 'to': 'Lyford Cay Club', 'passenger': 'David Sterling', 'dist': '24.1 km'},
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
        title: Text('Ride Requests', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: requests.length,
        itemBuilder: (c, i) {
          final req = requests[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.goldLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('NEW REQUEST', style: AppTextStyles.goldLabel),
                    ),
                    Text(
                      req['fare']!,
                      style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.cardTouchpoint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: AppColors.cyan, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(req['passenger']!, style: AppTextStyles.titleMedium),
                    const Spacer(),
                    Text(req['dist']!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.border, height: 1),
                ),
                Row(
                  children: [
                    const Icon(Icons.radio_button_checked, color: AppColors.cyan, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(req['from']!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.gold, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(req['to']!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GSButton(
                        label: 'Decline',
                        isSecondary: true,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: GSButton(
                        label: 'Accept →',
                        onTap: () => Navigator.pushNamed(context, '/provider/driver/active-ride'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
