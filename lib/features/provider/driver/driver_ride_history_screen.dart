import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class DriverRideHistoryScreen extends StatelessWidget {
  final bool embedded;
  const DriverRideHistoryScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final rides = [
      {'route': 'NAS Airport → Ocean Club', 'id': '#SW-8521', 'time': 'Apr 20, 4:18 PM', 'fare': '\$118.50', 'rating': '5.0'},
      {'route': 'Atlantis → Cable Beach', 'id': '#SW-8498', 'time': 'Apr 20, 2:00 PM', 'fare': '\$65.00', 'rating': '5.0'},
      {'route': 'Baha Mar → NAS Airport', 'id': '#SW-8471', 'time': 'Apr 19, 9:00 AM', 'fare': '\$98.00', 'rating': '4.9'},
      {'route': 'Lyford Cay → Paradise Island', 'id': '#SW-8450', 'time': 'Apr 19, 3:30 PM', 'fare': '\$145.00', 'rating': '5.0'},
      {'route': 'Albany Marina → Downtown', 'id': '#SW-8422', 'time': 'Apr 18, 11:15 AM', 'fare': '\$82.00', 'rating': '5.0'},
      {'route': 'Downtown → Atlantis', 'id': '#SW-8401', 'time': 'Apr 18, 6:45 PM', 'fare': '\$45.00', 'rating': '4.8'},
    ];

    final content = ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: rides.length,
      itemBuilder: (c, i) {
        final r = rides[i];
        return Container(
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
                  color: AppColors.cardTouchpoint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_car, color: AppColors.cyan, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r['route']!, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 2),
                    Text('${r['id']}  •  ${r['time']}', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(r['fare']!, style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.gold),
                      const SizedBox(width: 3),
                      Text(r['rating']!, style: AppTextStyles.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    return embedded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text('Ride History', style: AppTextStyles.headlineLarge),
              ),
              const SizedBox(height: 8),
              Expanded(child: content),
            ],
          )
        : Scaffold(
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
              title: Text('Ride History', style: AppTextStyles.titleLarge),
              centerTitle: false,
            ),
            body: content,
          );
  }
}
