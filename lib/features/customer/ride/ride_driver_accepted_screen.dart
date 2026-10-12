import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/widgets/gs_button.dart';

class RideDriverAcceptedScreen extends StatelessWidget {
  const RideDriverAcceptedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = ModalRoute.of(context)?.settings.arguments as RideModel?;
    final tripCode = ride != null ? '#SW-${ride.id}' : '#SW-ESCORT';
    final driverName = ride?.driver?.legalName ?? 'Assigned Chauffeur';
    final vehicleName = ride?.driver != null && ride!.driver!.vehicleMake != null
        ? '${ride.driver!.vehicleMake} ${ride.driver!.vehicleModel ?? ''}'.trim()
        : (ride?.requestedVehicleCategory != null ? ride!.requestedVehicleCategory!.replaceAll('_', ' ').toUpperCase() : 'Luxury Escort Vehicle');
    final licensePlate = ride?.driver?.licensePlate ?? 'BS-PENDING';
    final rating = ride?.driver?.rating != null ? ride!.driver!.rating!.toStringAsFixed(1) : '5.0';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text('CHAUFFEUR EN ROUTE • TRIP $tripCode', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Your Chauffeur is On His Way', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text('Expected arrival: 4 minutes', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    // Driver card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.badgeTeal,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primaryTeal, width: 2),
                                ),
                                child: const Icon(Icons.person, color: AppColors.primaryTeal, size: 34),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(driverName, style: AppTextStyles.headlineSmall),
                                    const SizedBox(height: 2),
                                    Text('Official Licensed VIP Chauffeur', style: AppTextStyles.bodySmall),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, size: 14, color: AppColors.gold),
                                        const SizedBox(width: 4),
                                        Text(rating, style: AppTextStyles.titleMedium.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 8),
                                        Text('Verified Chauffeur', style: AppTextStyles.bodySmall),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: AppColors.border, height: 1),
                          const SizedBox(height: 16),
                          // Vehicle info
                          Row(
                            children: [
                              const Icon(Icons.directions_car, color: AppColors.textSecondary, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(vehicleName, style: AppTextStyles.titleMedium),
                                    Text('Premium VIP Comfort • Tinted Privacy Glass', style: AppTextStyles.bodySmall),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.cardTouchpoint, borderRadius: BorderRadius.circular(8)),
                                child: Text(licensePlate, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Progress steps
                          Row(
                            children: [
                              _step('Chauffeur Assigned', true),
                              Expanded(child: Container(height: 1, color: AppColors.border)),
                              _step('En Route to You', true),
                              Expanded(child: Container(height: 1, color: AppColors.border)),
                              _step('Arrived', false),
                              Expanded(child: Container(height: 1, color: AppColors.border)),
                              _step('In Transit', false),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.cyanPill,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.phone_outlined, color: AppColors.primaryTeal, size: 18),
                                        const SizedBox(width: 8),
                                        Text('Call Chauffeur', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.border),
                                      boxShadow: AppColors.cardShadow,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.message_outlined, color: AppColors.textSecondary, size: 18),
                                        const SizedBox(width: 8),
                                        Text('Message', style: AppTextStyles.titleMedium),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    GSButton(label: 'Track Live Ride →', onTap: () => Navigator.pushNamed(context, '/customer/ride/active', arguments: ride)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(String label, bool done) => Column(
    children: [
      Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: done ? AppColors.primaryTeal : AppColors.cardTouchpoint,
          shape: BoxShape.circle,
          border: Border.all(color: done ? AppColors.primaryTeal : AppColors.border),
        ),
        child: Icon(done ? Icons.check : Icons.radio_button_unchecked, size: 14, color: done ? Colors.white : AppColors.textMuted),
      ),
      const SizedBox(height: 4),
      Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
    ],
  );
}
