import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final MapController _mapController = MapController();
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

  Future<void> _makePhoneCall(String? phoneNumber) async {
    final target = (phoneNumber != null && phoneNumber.trim().isNotEmpty)
        ? phoneNumber.trim()
        : '+12423221000';
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

  void _onCompleteTripPressed() {
    _pollTimer?.cancel();
    final isAlreadyCompleted = (_ride?.status.toLowerCase() == 'completed');
    if (isAlreadyCompleted) {
      Navigator.pushNamed(context, '/customer/ride/completed', arguments: _ride);
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Trip in Transit', style: AppTextStyles.titleLarge),
        content: Text(
          'Chauffeur officially completes the ride upon arriving at your destination. You can view your receipt summary now.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Continue Tracking', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/customer/ride/completed', arguments: _ride);
            },
            child: const Text('View Receipt'),
          ),
        ],
      ),
    );
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
    final dist = ride?.distanceKm != null ? '${ride!.distanceKm} km' : '18.5 km';
    final estMins = ride?.estimatedDurationMinutes != null ? '${ride!.estimatedDurationMinutes} mins' : '25 mins';
    final status = ride?.status.toLowerCase() ?? 'in_transit';
    final driverPhone = ride?.driver?.contactPhone;

    // LatLng coordinates
    final pickupLat = ride?.pickupLatitude ?? 25.0389;
    final pickupLng = ride?.pickupLongitude ?? -77.4662;
    final destLat = ride?.destinationLatitude ?? 25.0786;
    final destLng = ride?.destinationLongitude ?? -77.3072;
    final driverLat = ride?.driverCurrentLatitude ?? (pickupLat + (destLat - pickupLat) * 0.45);
    final driverLng = ride?.driverCurrentLongitude ?? (pickupLng + (destLng - pickupLng) * 0.45);

    final pickupLatLng = LatLng(pickupLat, pickupLng);
    final destLatLng = LatLng(destLat, destLng);
    final driverLatLng = LatLng(driverLat, driverLng);
    final centerLatLng = LatLng((pickupLat + destLat) / 2, (pickupLng + destLng) / 2);

    final List<LatLng> routePoints = [
      pickupLatLng,
      LatLng(25.0435, -77.4520),
      LatLng(25.0482, -77.4350),
      LatLng(25.0512, -77.4080),
      LatLng(25.0570, -77.3820),
      LatLng(25.0680, -77.3550),
      LatLng(25.0745, -77.3320),
      destLatLng,
    ];

    final etaTime = DateTime.now().add(Duration(minutes: ride?.estimatedDurationMinutes ?? 20));
    final formattedEta = '${etaTime.hour % 12 == 0 ? 12 : etaTime.hour % 12}:${etaTime.minute.toString().padLeft(2, '0')} ${etaTime.hour >= 12 ? 'PM' : 'AM'}';

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
                    // Real Interactive OpenStreetMap
                    Container(
                      height: 230,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: centerLatLng,
                                initialZoom: 12.2,
                                minZoom: 9.0,
                                maxZoom: 18.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.goswift.app',
                                ),
                                PolylineLayer(
                                  polylines: [
                                    Polyline(
                                      points: routePoints,
                                      color: AppColors.primaryTeal,
                                      strokeWidth: 4.5,
                                    ),
                                  ],
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: pickupLatLng,
                                      width: 36,
                                      height: 36,
                                      child: const Icon(Icons.location_pin, color: AppColors.primaryTeal, size: 36),
                                    ),
                                    Marker(
                                      point: destLatLng,
                                      width: 36,
                                      height: 36,
                                      child: const Icon(Icons.flag, color: AppColors.gold, size: 30),
                                    ),
                                    Marker(
                                      point: driverLatLng,
                                      width: 40,
                                      height: 40,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryTeal,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2.5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.25),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(Icons.directions_car, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Top speed/route badge
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
                                    Text('LIVE GPS • Sir Milo Butler Hwy', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            // Bottom ETA badge
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
                                    Text('Expected $formattedEta • Smooth Island Traffic', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
                                  ],
                                ),
                              ),
                            ),
                            // Interactive controls: Center & Zoom
                            Positioned(
                              right: 12,
                              top: 12,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => _mapController.move(centerLatLng, 12.5),
                                    child: _ctrl(Icons.my_location),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      final currentZoom = _mapController.camera.zoom;
                                      _mapController.move(_mapController.camera.center, currentZoom + 1);
                                    },
                                    child: _ctrl(Icons.add),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      final currentZoom = _mapController.camera.zoom;
                                      _mapController.move(_mapController.camera.center, currentZoom - 1);
                                    },
                                    child: _ctrl(Icons.remove),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                          GestureDetector(
                            onTap: () => _makePhoneCall(driverPhone),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.cyanPill,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.phone_outlined, color: AppColors.primaryTeal, size: 16),
                                  const SizedBox(width: 8),
                                  Text('Call Chauffeur', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                                ],
                              ),
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
                      onTap: _onCompleteTripPressed,
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
