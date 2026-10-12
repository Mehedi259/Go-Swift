import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/services/ride_service.dart';
import '../../../core/widgets/gs_button.dart';

class DriverRideRequestsScreen extends StatefulWidget {
  const DriverRideRequestsScreen({super.key});

  @override
  State<DriverRideRequestsScreen> createState() => _DriverRideRequestsScreenState();
}

class _DriverRideRequestsScreenState extends State<DriverRideRequestsScreen> {
  final RideService _rideService = RideService();
  List<RideModel> _liveRequests = [];
  bool _isLoading = true;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchRequests(silent: true));
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchRequests({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final rides = await _rideService.getAvailableRides();
      if (mounted) {
        setState(() {
          _liveRequests = rides;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAccept(int rideId, RideModel liveRide) async {
    try {
      final accepted = await _rideService.acceptRide(rideId);
      if (mounted) {
        Navigator.pushNamed(context, '/provider/driver/active-ride', arguments: accepted);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushNamed(context, '/provider/driver/active-ride', arguments: liveRide);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryTeal),
            onPressed: () => _fetchRequests(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
          : RefreshIndicator(
              color: AppColors.primaryTeal,
              onRefresh: () => _fetchRequests(),
              child: _liveRequests.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: _liveRequests.length,
                      itemBuilder: (c, i) {
                        final r = _liveRequests[i];
                        final fare = '\$${r.estimatedFare.toStringAsFixed(2)}';
                        final from = r.pickupAddress;
                        final to = r.destinationAddress;
                        final passenger = r.customerName;
                        final dist = r.distanceKm != null ? '${r.distanceKm} km' : '12.0 km';
                        final category = (r.requestedVehicleCategory ?? 'LUXURY SEDAN').replaceAll('_', ' ').toUpperCase();

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
                                    child: Text('NEW DISPATCH • $category', style: AppTextStyles.goldLabel),
                                  ),
                                  Text(
                                    fare,
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
                                  Text(passenger, style: AppTextStyles.titleMedium),
                                  const Spacer(),
                                  Text(dist, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Divider(color: AppColors.border, height: 1),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.radio_button_checked, color: AppColors.cyan, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(from, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on, color: AppColors.gold, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(to, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
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
                                      onTap: () {
                                        setState(() {
                                          _liveRequests.removeAt(i);
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 2,
                                    child: GSButton(
                                      label: 'Accept Dispatch →',
                                      onTap: () => _handleAccept(r.id, r),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.local_taxi_outlined, size: 38, color: AppColors.primaryTeal),
            ),
            const SizedBox(height: 20),
            Text('No Active Ride Requests', style: AppTextStyles.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'All passenger trips in Nassau & Paradise Island are currently assigned. Stay on this screen or pull down to check for new VIP requests.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GSButton(
              label: 'Refresh Requests',
              isSecondary: true,
              onTap: () => _fetchRequests(),
            ),
          ],
        ),
      ),
    );
  }
}
