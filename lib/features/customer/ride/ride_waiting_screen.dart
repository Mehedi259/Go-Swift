import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/services/ride_service.dart';
import '../../../core/widgets/gs_button.dart';

class RideWaitingScreen extends StatefulWidget {
  const RideWaitingScreen({super.key});

  @override
  State<RideWaitingScreen> createState() => _RideWaitingScreenState();
}

class _RideWaitingScreenState extends State<RideWaitingScreen> {
  bool _isCancelling = false;
  Timer? _pollTimer;
  bool _initialized = false;
  RideModel? _currentRide;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is RideModel) {
        _currentRide = arg;
        _startPolling();
      }
    }
  }

  void _startPolling() {
    if (_currentRide == null) return;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      try {
        final updated = await RideService().getRideDetail(_currentRide!.id);
        if (!mounted) return;
        final s = updated.status.toLowerCase();
        if (s == 'accepted' || s == 'driver_assigned' || s == 'in_transit' || s == 'in_progress' || s == 'arrived') {
          _pollTimer?.cancel();
          Navigator.pushReplacementNamed(
            context,
            '/customer/ride/driver-accepted',
            arguments: updated,
          );
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleCancel(RideModel? ride) async {
    _pollTimer?.cancel();
    final target = ride ?? _currentRide;
    if (target != null) {
      setState(() => _isCancelling = true);
      try {
        await RideService().cancelRide(target.id, reason: 'Customer requested cancellation');
      } catch (_) {}
    }
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = (ModalRoute.of(context)?.settings.arguments as RideModel?) ?? _currentRide;
    final pickup = ride?.pickupAddress ?? "Lynden Pindling Int'l Airport (NAS)";
    final destination = ride?.destinationAddress ?? 'The Ocean Club, Four Seasons Resort';
    final fare = ride != null ? '\$${ride.estimatedFare.toStringAsFixed(2)}' : '\$118.50';

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
                  const SizedBox(width: 12),
                  Text('GO SWIFT', style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.badgeGold,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF3C78E)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search, size: 14, color: Color(0xFF8A5300)),
                          const SizedBox(width: 6),
                          Text('FINDING YOUR CHAUFFEUR', style: AppTextStyles.labelSmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Matching you with a\ncertified VIP chauffeur', style: AppTextStyles.displayMedium),
                    const SizedBox(height: 8),
                    Text('Nassau & Paradise Island dispatch network', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 24),
                    Center(
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.3), width: 2),
                          boxShadow: AppColors.softShadow,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.directions_car, color: AppColors.primaryTeal, size: 40),
                            const SizedBox(height: 8),
                            Text('Searching...', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Trip details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle)),
                              const SizedBox(width: 10),
                              Expanded(child: Text(pickup, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Container(width: 1, height: 24, color: AppColors.border, margin: const EdgeInsets.symmetric(vertical: 4)),
                          ),
                          Row(
                            children: [
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle)),
                              const SizedBox(width: 10),
                              Expanded(child: Text(destination, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _infoBox('Est. Fare', fare, AppColors.primaryTeal)),
                        const SizedBox(width: 12),
                        Expanded(child: _infoBox('Est. Time', '12-18 min', AppColors.textPrimary)),
                      ],
                    ),
                    const Spacer(),
                    GSButton(
                      label: 'Cancel Request',
                      isSecondary: true,
                      isLoading: _isCancelling,
                      onTap: () => _handleCancel(ride),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/customer/ride/driver-accepted', arguments: ride),
                        child: Text('View Chauffeur Dispatch Status →', style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String label, String value, Color color) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.cardShadow,
    ),
    child: Column(
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.headlineSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
