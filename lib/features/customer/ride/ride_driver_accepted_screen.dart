import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/services/ride_service.dart';
import '../../../core/widgets/gs_button.dart';

class RideDriverAcceptedScreen extends StatefulWidget {
  final RideModel? ride;
  const RideDriverAcceptedScreen({super.key, this.ride});

  @override
  State<RideDriverAcceptedScreen> createState() => _RideDriverAcceptedScreenState();
}

class _RideDriverAcceptedScreenState extends State<RideDriverAcceptedScreen> {
  final RideService _rideService = RideService();
  RideModel? _currentRide;
  Timer? _pollTimer;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is RideModel) {
        _currentRide = args;
      } else if (widget.ride != null) {
        _currentRide = widget.ride;
      }
      _startPolling();
    }
  }

  void _startPolling() {
    final rideId = _currentRide?.id;
    if (rideId == null) return;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      try {
        final updated = await _rideService.getRideDetail(rideId);
        if (!mounted) return;
        setState(() => _currentRide = updated);

        final s = updated.status.toLowerCase();
        if (s == 'in_progress' || s == 'in_transit') {
          _pollTimer?.cancel();
          Navigator.pushReplacementNamed(
            context,
            '/customer/ride/active',
            arguments: updated,
          );
        } else if (s == 'completed') {
          _pollTimer?.cancel();
          Navigator.pushReplacementNamed(
            context,
            '/customer/ride/completed',
            arguments: updated,
          );
        } else if (s == 'cancelled') {
          _pollTimer?.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trip was cancelled.'), backgroundColor: AppColors.red),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false);
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    final target = (phoneNumber != null && phoneNumber.trim().isNotEmpty)
        ? phoneNumber.trim()
        : '+12423221000'; // Bahamas VIP Concierge Dispatch
    final uri = Uri.parse('tel:$target');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Direct Chauffeur line: $target'),
              backgroundColor: AppColors.primaryTeal,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Direct Chauffeur line: $target'),
            backgroundColor: AppColors.primaryTeal,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _sendSms(String? phoneNumber) async {
    final target = (phoneNumber != null && phoneNumber.trim().isNotEmpty)
        ? phoneNumber.trim()
        : '+12423221000';
    final uri = Uri.parse('sms:$target');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('SMS Dispatch line: $target'),
              backgroundColor: AppColors.primaryTeal,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('SMS Dispatch line: $target'),
            backgroundColor: AppColors.primaryTeal,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = _currentRide;
    final tripCode = ride != null ? '#SW-${ride.id}' : '#SW-ESCORT';
    final driverName = ride?.driver?.legalName ?? 'Assigned Chauffeur';
    final vehicleName = ride?.driver != null && ride!.driver!.vehicleMake != null
        ? '${ride.driver!.vehicleMake} ${ride.driver!.vehicleModel ?? ''}'.trim()
        : (ride?.requestedVehicleCategory != null ? ride!.requestedVehicleCategory!.replaceAll('_', ' ').toUpperCase() : 'Luxury Escort Vehicle');
    final licensePlate = ride?.driver?.licensePlate ?? 'BS-PENDING';
    final rating = ride?.driver?.rating != null ? ride!.driver!.rating!.toStringAsFixed(1) : '5.0';
    final driverPhone = ride?.driver?.contactPhone;

    final status = (ride?.status ?? 'accepted').toLowerCase();
    final bool isArrived = status == 'arrived' || status == 'in_progress' || status == 'in_transit' || status == 'completed';
    final bool isInTransit = status == 'in_progress' || status == 'in_transit' || status == 'completed';

    final etaText = isArrived
        ? 'Chauffeur has arrived at your pickup spot!'
        : (ride?.estimatedPickupMinutes != null ? 'Expected arrival: ${ride!.estimatedPickupMinutes} minutes' : 'Expected arrival: 3-5 minutes');

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
                    onTap: () {
                      _pollTimer?.cancel();
                      Navigator.pop(context);
                    },
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
                        color: isArrived ? AppColors.badgeGold : AppColors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isArrived ? const Color(0xFF8A5300) : AppColors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isArrived ? 'CHAUFFEUR ARRIVED • TRIP $tripCode' : 'CHAUFFEUR EN ROUTE • TRIP $tripCode',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isArrived ? const Color(0xFF8A5300) : AppColors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isArrived ? 'Your Chauffeur has Arrived' : 'Your Chauffeur is On His Way',
                      style: AppTextStyles.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      etaText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isArrived ? const Color(0xFF8A5300) : AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
                          // Dynamic Progress steps
                          Row(
                            children: [
                              _step('Chauffeur Assigned', true),
                              Expanded(child: Container(height: 1, color: AppColors.primaryTeal)),
                              _step('En Route to You', true),
                              Expanded(child: Container(height: 1, color: isArrived ? AppColors.primaryTeal : AppColors.border)),
                              _step('Arrived', isArrived),
                              Expanded(child: Container(height: 1, color: isInTransit ? AppColors.primaryTeal : AppColors.border)),
                              _step('In Transit', isInTransit),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _makePhoneCall(driverPhone),
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
                                  onTap: () => _sendSms(driverPhone),
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
                    GSButton(
                      label: 'Track Live Ride →',
                      onTap: () {
                        _pollTimer?.cancel();
                        Navigator.pushNamed(context, '/customer/ride/active', arguments: ride);
                      },
                    ),
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
