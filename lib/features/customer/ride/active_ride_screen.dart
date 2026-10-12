import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/services/ride_service.dart';
import '../../../core/widgets/gs_button.dart';

class ActiveRideScreen extends StatefulWidget {
  final RideModel? ride;
  const ActiveRideScreen({super.key, this.ride});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  final RideService _rideService = RideService();
  RideModel? _ride;
  Timer? _pollTimer;
  bool _initialized = false;
  bool _isCancelling = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is RideModel) {
        _ride = args;
      } else if (widget.ride != null) {
        _ride = widget.ride;
      }
      _startPolling();
    }
  }

  void _startPolling() {
    final rideId = _ride?.id;
    if (rideId == null) return;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      try {
        final updated = await _rideService.getRideDetail(rideId);
        if (!mounted) return;
        setState(() {
          _ride = updated;
        });
        final s = updated.status.toLowerCase();
        if (s == 'completed') {
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

  Future<void> _handleCancelRide() async {
    final rideId = _ride?.id;
    if (rideId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel VIP Transit?', style: AppTextStyles.titleLarge),
        content: Text(
          'Are you sure you want to cancel Trip #${_ride?.id ?? rideId}? Your chauffeur has already been dispatched.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Keep Ride', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel Ride'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isCancelling = true);
    try {
      await _rideService.cancelRide(rideId, reason: 'Passenger cancelled');
      _pollTimer?.cancel();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride cancelled.'), backgroundColor: AppColors.red),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isCancelling = false);
        Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = _ride;
    final tripCode = ride != null ? '#SW-${ride.id}' : '#SW-ACTIVE';
    final driverName = ride?.driver?.legalName ?? 'Assigned Chauffeur';
    final vehicleName = ride?.driver != null && ride!.driver!.vehicleMake != null
        ? '${ride.driver!.vehicleMake} ${ride.driver!.vehicleModel ?? ''}'.trim()
        : (ride?.requestedVehicleCategory != null ? ride!.requestedVehicleCategory!.replaceAll('_', ' ').toUpperCase() : 'Luxury Escort Vehicle');
    final licensePlate = ride?.driver?.licensePlate ?? 'BS-PENDING';
    final rating = ride?.driver?.rating != null ? ride!.driver!.rating!.toStringAsFixed(1) : '5.0';
    final dist = ride?.distanceKm != null ? '${ride!.distanceKm} km' : 'En Route';
    final estMins = ride?.estimatedDurationMinutes != null ? '${ride!.estimatedDurationMinutes} mins' : 'Calculating...';
    final status = ride?.status.toLowerCase() ?? 'in_transit';

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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.badgeTeal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.replaceAll('_', ' ').toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text('ACTIVE TRANSIT • TRIP $tripCode', style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$estMins remaining', style: AppTextStyles.displayMedium),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.route, size: 14, color: AppColors.primaryTeal),
                              const SizedBox(width: 6),
                              Text(dist, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Light Map
                    _MapView(),
                    const SizedBox(height: 16),
                    // Route locations
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
                              const Icon(Icons.radio_button_checked, color: AppColors.primaryTeal, size: 16),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ride?.pickupAddress ?? "Lynden Pindling Int'l Airport (NAS)",
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(width: 2, height: 16, color: AppColors.border),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: AppColors.gold, size: 16),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ride?.destinationAddress ?? "The Ocean Club, Paradise Island",
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.badgeTeal,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primaryTeal, width: 2),
                                ),
                                child: const Icon(Icons.person, color: AppColors.primaryTeal, size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(driverName, style: AppTextStyles.headlineSmall),
                                    Text('Official Licensed VIP Chauffeur', style: AppTextStyles.bodySmall),
                                    const SizedBox(height: 4),
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
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.cyanPill,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.phone_outlined, color: AppColors.primaryTeal, size: 16),
                                const SizedBox(width: 8),
                                Text('Call Chauffeur', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Vehicle
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.cardTouchpoint,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.directions_car, color: AppColors.primaryTeal, size: 18),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.border)),
                                  child: Text(licensePlate, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GSButton(
                      label: 'Complete Trip & View Receipt →',
                      onTap: () {
                        _pollTimer?.cancel();
                        Navigator.pushNamed(context, '/customer/ride/completed', arguments: ride);
                      },
                    ),
                    const SizedBox(height: 12),
                    GSButton(
                      label: _isCancelling ? 'Cancelling...' : 'Cancel Transit',
                      isSecondary: true,
                      isLoading: _isCancelling,
                      onTap: _isCancelling ? () {} : _handleCancelRide,
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
}

class _MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFE8F4F8),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            CustomPaint(size: const Size(double.infinity, 220), painter: _BgPainter()),
            // Speed badge
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text('58 km/h • Sir Milo Butler Hwy', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            // ETA badge
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 12, color: AppColors.primaryTeal),
                    const SizedBox(width: 6),
                    Text('Expected 4:18 PM • Smooth Island Traffic', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.badgeTeal, borderRadius: BorderRadius.circular(6)),
                      child: Text('LIVE GPS', style: AppTextStyles.caption.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),
            // Controls
            Positioned(
              right: 12,
              top: 12,
              child: Column(
                children: [
                  _ctrl(Icons.my_location),
                  const SizedBox(height: 8),
                  _ctrl(Icons.layers_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ctrl(IconData icon) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.cardShadow,
    ),
    child: Icon(icon, size: 18, color: AppColors.primaryTeal),
  );
}

class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Crystal Bahamas water base
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFFE4F3F7));
    // Island land
    final landPaint = Paint()..color = Colors.white;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(10, 10, size.width - 20, size.height - 20), const Radius.circular(12)), landPaint);

    final street = Paint()
      ..color = const Color(0xFFE2EFF5)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    for (double y = 20; y < size.height; y += 35) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), street);
    }
    for (double x = 20; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), street);
    }

    final hwy = Paint()..color = const Color(0xFFCCE4EC)..strokeWidth = 10;
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.3), hwy);

    // Route in Sovereign Ocean Teal
    final route = Paint()
      ..color = const Color(0xFF007A8C)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final p = Path()
      ..moveTo(size.width * 0.15, size.height * 0.7)
      ..cubicTo(size.width * 0.35, size.height * 0.55, size.width * 0.55, size.height * 0.4, size.width * 0.82, size.height * 0.2);
    canvas.drawPath(p, route);

    // Car pin in Ocean Teal & White
    canvas.drawCircle(Offset(size.width * 0.42, size.height * 0.48), 12, Paint()..color = const Color(0xFF007A8C));
    canvas.drawCircle(Offset(size.width * 0.42, size.height * 0.48), 8, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(size.width * 0.42, size.height * 0.48), 5, Paint()..color = const Color(0xFF007A8C));
  }

  @override
  bool shouldRepaint(_) => false;
}
