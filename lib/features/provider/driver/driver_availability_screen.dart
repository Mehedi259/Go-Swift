import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/services/ride_service.dart';
import 'driver_earnings_screen.dart';
import 'driver_ride_history_screen.dart';
import 'driver_ratings_screen.dart';
import 'driver_profile_screen.dart';

class DriverAvailabilityScreen extends StatefulWidget {
  const DriverAvailabilityScreen({super.key});
  @override
  State<DriverAvailabilityScreen> createState() => _DriverAvailabilityScreenState();
}

class _DriverAvailabilityScreenState extends State<DriverAvailabilityScreen> {
  bool _online = true;
  int _nav = 0;
  DateTime? _lastBackPressTime;
  String _driverName = LocalStorage.getUser()?.fullName.isNotEmpty == true ? LocalStorage.getUser()!.fullName : 'VIP Chauffeur';
  String _driverTitle = 'VIP Chauffeur • Verified';
  String _todayEarnings = '\$0.00';
  String _tripsCount = '0';
  List<RideModel> _incomingRequests = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final profile = await ProviderApplicationService().getRideProfile();
      if (mounted && profile.isNotEmpty) {
        setState(() {
          if (profile['legal_name'] != null && (profile['legal_name'] as String).isNotEmpty) {
            _driverName = profile['legal_name'];
          }
          if (profile['vehicle_category'] != null) {
            _driverTitle = 'VIP Chauffeur • ${profile['vehicle_category'].toString().toUpperCase()}';
          }
          if (profile['online_accepting_requests'] != null) {
            _online = profile['online_accepting_requests'] == true;
          }
        });
      }
    } catch (_) {}

    try {
      final rides = await RideService().getAvailableRides();
      if (mounted) {
        setState(() {
          _incomingRequests = rides;
        });
      }
    } catch (_) {}

    try {
      final history = await RideService().getDriverRideHistory();
      if (mounted && history.isNotEmpty) {
        double todaySum = 0;
        int todayTrips = 0;
        final todayStr = DateTime.now().toIso8601String().substring(0, 10);
        for (final r in history) {
          if (r.createdAt != null && r.createdAt!.startsWith(todayStr)) {
            todaySum += r.finalFare ?? r.estimatedFare;
            todayTrips++;
          }
        }
        if (todayTrips > 0) {
          setState(() {
            _todayEarnings = '\$${todaySum.toStringAsFixed(2)}';
            _tripsCount = '$todayTrips';
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _toggleOnline() async {
    final nextState = !_online;
    setState(() => _online = nextState);
    try {
      await ProviderApplicationService().updateRideProfile(onlineAcceptingRequests: nextState);
    } catch (_) {}
  }

  Widget _body() {
    switch (_nav) {
      case 1:
        return const DriverEarningsScreen(embedded: true);
      case 2:
        return const DriverRideHistoryScreen(embedded: true);
      case 3:
        return const DriverRatingsScreen(embedded: true);
      case 4:
        return const DriverProfileScreen(embedded: true);
      default:
        return _homeTab();
    }
  }

  Widget _homeTab() => SingleChildScrollView(
        child: Column(
          children: [
            // Hero card
            Container(
              margin: const EdgeInsets.all(20),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_driverName, style: AppTextStyles.headlineMedium),
                          const SizedBox(height: 2),
                          Text(_driverTitle,
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.gold, size: 14),
                              const SizedBox(width: 4),
                              Text('4.98 • 620+ trips',
                                  style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
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
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Online toggle
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardTouchpoint,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_online ? 'ONLINE' : 'OFFLINE',
                                style: AppTextStyles.labelSmall
                                    .copyWith(color: _online ? AppColors.green : AppColors.textMuted, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(_online ? 'Ready for dispatch' : 'Not accepting rides',
                                style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary)),
                          ],
                        ),
                        GestureDetector(
                          onTap: _toggleOnline,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 64,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _online ? AppColors.green : AppColors.border,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 300),
                              alignment: _online ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                width: 28,
                                height: 28,
                                margin: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _statBox("Today's Earnings", _todayEarnings, const Color(0xFF8A5300), Icons.attach_money)),
                      const SizedBox(width: 12),
                      Expanded(child: _statBox('Trips Today', _tripsCount, AppColors.primaryTeal, Icons.directions_car)),
                    ],
                  ),
                ],
              ),
            ),
            // Ride requests
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Incoming Requests', style: AppTextStyles.headlineSmall),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/provider/driver/requests'),
                    child: Text('View All', style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _RideRequestCard(
                ride: _incomingRequests.isNotEmpty ? _incomingRequests.first : null,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Quick Actions', style: AppTextStyles.headlineSmall),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: [
                  _quickAction(Icons.receipt_long_outlined, 'Ride History', () => Navigator.pushNamed(context, '/provider/driver/history')),
                  _quickAction(Icons.attach_money, 'Earnings', () => Navigator.pushNamed(context, '/provider/driver/earnings')),
                  _quickAction(Icons.badge_outlined, 'Documents', () => Navigator.pushNamed(context, '/provider/driver/documents')),
                  _quickAction(Icons.star_outline, 'My Ratings', () => Navigator.pushNamed(context, '/provider/driver/ratings')),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );

  Widget _statBox(String label, String val, Color color, IconData icon) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                Text(val, style: AppTextStyles.headlineSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      );

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryTeal, size: 20),
              const SizedBox(width: 10),
              Text(label, style: AppTextStyles.titleMedium),
              const Spacer(),
              const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 16),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_nav != 0) {
          setState(() => _nav = 0);
          return;
        }
        final now = DateTime.now();
        if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit Go-Swift'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(color: AppColors.primaryTeal, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.bolt, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('Driver Hub', style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/customer/notifications'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Icon(Icons.notifications_none_outlined, color: AppColors.textPrimary, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _body()),
            ],
          ),
        ),
        bottomNavigationBar: _driverNav(),
      ),
    );
  }

  Widget _driverNav() => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ni(Icons.home_outlined, Icons.home, 'Home', 0),
                _ni(Icons.attach_money, Icons.attach_money, 'Earnings', 1),
                _ni(Icons.receipt_long_outlined, Icons.receipt_long, 'History', 2),
                _ni(Icons.star_outline, Icons.star, 'Ratings', 3),
                _ni(Icons.person_outline, Icons.person, 'Profile', 4),
              ],
            ),
          ),
        ),
      );

  Widget _ni(IconData icon, IconData activeIcon, String label, int idx) => GestureDetector(
        onTap: () => setState(() => _nav = idx),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_nav == idx ? activeIcon : icon, color: _nav == idx ? AppColors.primaryTeal : AppColors.textMuted, size: 24),
            const SizedBox(height: 4),
            Text(label,
                style: AppTextStyles.caption.copyWith(
                    color: _nav == idx ? AppColors.primaryTeal : AppColors.textMuted,
                    fontWeight: _nav == idx ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      );
}

class _RideRequestCard extends StatelessWidget {
  final RideModel? ride;
  const _RideRequestCard({this.ride});

  @override
  Widget build(BuildContext context) {
    if (ride == null) {
      return Container(
        padding: const EdgeInsets.all(20),
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
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text('DISPATCH LISTENER ACTIVE', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text('Awaiting Chauffeur Requests', style: AppTextStyles.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Listening for dispatch requests across New Providence. You will be prompted instantly when a VIP booking is dispatched.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final tripCode = '#SW-${ride!.id}';
    final pickup = ride!.pickupAddress;
    final destination = ride!.destinationAddress;
    final fare = '\$${ride!.estimatedFare.toStringAsFixed(2)}';
    final dist = ride!.distanceKm != null ? '${ride!.distanceKm} km' : 'En Route';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.3)),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.badgeGold, borderRadius: BorderRadius.circular(20)),
                child: Text('NEW REQUEST', style: AppTextStyles.goldLabel.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              Text(tripCode, style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.primaryTeal, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(pickup, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.flag_outlined, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(destination, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip(Icons.route, dist),
              const SizedBox(width: 8),
              _chip(Icons.attach_money, fare),
              const SizedBox(width: 8),
              _chip(Icons.access_time, '18 min'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardTouchpoint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('Decline', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () async {
                    if (ride != null) {
                      try {
                        await RideService().acceptRide(ride!.id);
                      } catch (_) {}
                    }
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/provider/driver/active-ride');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Center(
                      child: Text('Accept Ride →', style: AppTextStyles.buttonText),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: AppColors.cardTouchpoint, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primaryTeal),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          ],
        ),
      );
}
