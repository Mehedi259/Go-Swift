import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/ride_service.dart';
import '../../../core/widgets/gs_bottom_nav.dart';
import '../history/booking_history_screen.dart';
import '../favorites/favorites_screen.dart';
import '../support/support_screen.dart';
import '../profile/customer_profile_screen.dart';

class CustomerHubScreen extends StatefulWidget {
  const CustomerHubScreen({super.key});

  @override
  State<CustomerHubScreen> createState() => _CustomerHubScreenState();
}

class _CustomerHubScreenState extends State<CustomerHubScreen> {
  int _navIndex = 0;

  Widget _body() {
    switch (_navIndex) {
      case 1:
        return const BookingHistoryScreen(embedded: true);
      case 2:
        return const FavoritesScreen(embedded: true);
      case 3:
        return const SupportScreen(embedded: true);
      case 4:
        return const CustomerProfileScreen(embedded: true);
      default:
        return const _HomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _body(),
      bottomNavigationBar: GSBottomNav(currentIndex: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  RideModel? _activeRide;

  @override
  void initState() {
    super.initState();
    _fetchActiveRide();
  }

  Future<void> _fetchActiveRide() async {
    try {
      final rides = await RideService().getMyRides();
      if (mounted) {
        final active = rides.where((r) {
          final s = r.status.toLowerCase();
          return s == 'pending' || s == 'accepted' || s == 'arrived' || s == 'in_progress';
        }).toList();
        setState(() {
          _activeRide = active.isNotEmpty ? active.first : null;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final greetingName = (user != null && user.firstName.isNotEmpty)
        ? user.firstName
        : ((user != null && user.fullName.isNotEmpty) ? user.fullName : 'Guest');

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/AppLogo.png',
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle),
                        child: const Icon(Icons.bolt, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/customer/notifications'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.softShadow,
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Icon(Icons.notifications_none_outlined, color: AppColors.textPrimary, size: 22),
                          ),
                          Positioned(
                            top: 8,
                            right: 9,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cyan, width: 2),
                      boxShadow: AppColors.softShadow,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/user_avatar.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.cyanPill,
                        child: const Icon(Icons.person, color: AppColors.cyan),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Welcome Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, $greetingName',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a service for on-demand luxury island mobility\n& concierge living.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),

            // Active Dispatch Card (Live or Quick Dispatch)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.8),
                  boxShadow: AppColors.cardShadow,
                ),
                child: _activeRide != null
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'ACTIVE DISPATCH • SW-${_activeRide!.id}',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.cyan,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.borderLight),
                                ),
                                child: Text(
                                  _activeRide!.status.toUpperCase(),
                                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.cyanPill,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.directions_car_outlined, color: AppColors.cyan, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _activeRide!.requestedVehicleCategory != null && _activeRide!.requestedVehicleCategory!.isNotEmpty
                                          ? _activeRide!.requestedVehicleCategory!.replaceAll('_', ' ').toUpperCase()
                                          : 'Executive Chauffeur',
                                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'To: ${_activeRide!.destinationAddress.split(',').first}',
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/customer/ride/active', arguments: _activeRide),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.cyan,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.cyan.withOpacity(0.22),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Live Track',
                                        style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.arrow_forward, color: Colors.white, size: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'ISLAND MOBILITY CONCIERGE',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.cyan,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.badgeTeal,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'ON-DEMAND',
                                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.badgeTeal,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.directions_car_outlined, color: AppColors.primaryTeal, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Executive Chauffeur Service',
                                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'NAS Airport transfers & island transit',
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/customer/ride/booking'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.cyan,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.cyan.withOpacity(0.22),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Book Ride',
                                        style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.arrow_forward, color: Colors.white, size: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),

            // Verticals Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GO SWIFT VERTICALS',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.cyan,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dedicated Concierge Services',
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text('5 On-Demand', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),

            // Services List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildServiceCard(
                    context: context,
                    icon: Icons.directions_car_outlined,
                    iconBgColor: AppColors.cyanLight,
                    iconColor: AppColors.cyan,
                    title: 'Ride',
                    badge: 'Island Chauffeur',
                    badgeBgColor: AppColors.cyanLight,
                    badgeTextColor: AppColors.cyan,
                    description: 'On-demand VIP rides, private airport transfers & luxury island transit.',
                    footerIcon: Icons.verified_user_outlined,
                    footerText: 'Vetted Drivers & Escorts',
                    buttonLabel: 'Book Ride',
                    route: '/customer/ride/booking',
                  ),
                  _buildServiceCard(
                    context: context,
                    icon: Icons.restaurant_outlined,
                    iconBgColor: AppColors.goldLight,
                    iconColor: AppColors.gold,
                    title: 'Food',
                    badge: 'Fine Dining & Yacht Delivery',
                    badgeBgColor: AppColors.goldLight,
                    badgeTextColor: AppColors.gold,
                    description: 'Michelin-tier island restaurants delivered hot to your door or private slip.',
                    footerIcon: Icons.sailing_outlined,
                    footerText: 'Marina & Dock Direct',
                    buttonLabel: 'Order Food',
                    route: '/customer/food',
                  ),
                  _buildServiceCard(
                    context: context,
                    icon: Icons.chat_bubble_outline,
                    iconBgColor: AppColors.courierBlueLight,
                    iconColor: AppColors.courierBlue,
                    title: 'Courier',
                    badge: 'Bonded & Insured',
                    badgeBgColor: AppColors.courierBlueLight,
                    badgeTextColor: AppColors.courierBlue,
                    description: 'Rapid point-to-point courier & customs document dispatch across Nassau.',
                    footerIcon: Icons.bolt_outlined,
                    footerText: 'Rush 45-Min Service',
                    buttonLabel: 'Send Parcel',
                    route: '/customer/courier/request',
                  ),
                  _buildServiceCard(
                    context: context,
                    icon: Icons.vpn_key_outlined,
                    iconBgColor: AppColors.fleetTanLight,
                    iconColor: AppColors.fleetTan,
                    title: 'Car Rental',
                    badge: 'Executive Fleet',
                    badgeBgColor: AppColors.fleetTanLight,
                    badgeTextColor: AppColors.fleetTan,
                    description: 'Cadillac Escalades, Porsche convertibles & SUVs delivered directly to your FBO or villa.',
                    footerIcon: Icons.flight_takeoff_outlined,
                    footerText: 'Tarmac FBO Handover',
                    buttonLabel: 'Select Vehicle',
                    route: '/customer/car-rental/search',
                  ),
                  _buildServiceCard(
                    context: context,
                    icon: Icons.home_work_outlined,
                    iconBgColor: AppColors.staysTealLight,
                    iconColor: AppColors.staysTeal,
                    title: 'Rooms / Properties',
                    badge: 'Luxury Stays',
                    badgeBgColor: AppColors.staysTealLight,
                    badgeTextColor: AppColors.staysTeal,
                    description: 'Exclusive oceanfront villas, private island retreats & penthouse rentals.',
                    footerIcon: Icons.groups_outlined,
                    footerText: 'Staffed & Fully Provisioned',
                    buttonLabel: 'Explore Villas',
                    route: '/customer/properties/search',
                  ),
                ],
              ),
            ),

            // Account Touchpoints Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Account Touchpoints',
                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'QUICK MANAGEMENT',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Account Touchpoints Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTouchpointCard(
                      context,
                      Icons.receipt_long_outlined,
                      'Booking History',
                      'View past & upcoming rides, meals, and...',
                      '/customer/history',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTouchpointCard(
                      context,
                      Icons.favorite_border_outlined,
                      'Saved Favorites',
                      'Your preferred chauffeurs, villas, and...',
                      '/customer/favorites',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String badge,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required String description,
    required IconData footerIcon,
    required String footerText,
    required String buttonLabel,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badge,
                            style: AppTextStyles.labelSmall.copyWith(color: badgeTextColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(footerIcon, color: AppColors.textSecondary, size: 15),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        footerText,
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, route),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cyanPill,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        buttonLabel,
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, color: AppColors.cyan, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTouchpointCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD8E9F3), width: 0.8),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Icon(icon, color: AppColors.cyan, size: 20),
                ),
                const Icon(Icons.arrow_forward, color: AppColors.cyan, size: 16),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}
