import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
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
      case 1: return const BookingHistoryScreen(embedded: true);
      case 2: return const FavoritesScreen(embedded: true);
      case 3: return const SupportScreen(embedded: true);
      case 4: return const CustomerProfileScreen(embedded: true);
      default: return const _HomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      bottomNavigationBar: GSBottomNav(currentIndex: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/customer/notifications'),
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.notifications_none_outlined, color: AppColors.textSecondary, size: 24),
                      ),
                      Positioned(
                        top: 6,
                        right: 8,
                        child: Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.cyan, width: 1.5)),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset('assets/images/user_avatar.jpg', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: AppColors.surface)),
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
                Text('Welcome back, Marcus', style: AppTextStyles.headlineMedium.copyWith(color: Colors.white, fontSize: 24)),
                const SizedBox(height: 8),
                Text(
                  'Select a service for on-demand luxury island mobility\n& concierge living.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),

          // Active Dispatch
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text('ACTIVE DISPATCH • SW-8492', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.background.withOpacity(0.8), borderRadius: BorderRadius.circular(12)),
                        child: Text('ETA 4 MIN', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.directions_car_outlined, color: AppColors.cyan, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cadillac Escalade ESV', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                            Text('En route to Lynden Pindling...', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/customer/ride/active'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Text('Live Track', style: AppTextStyles.titleMedium.copyWith(color: AppColors.background, fontSize: 14)),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, color: AppColors.background, size: 16),
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
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('GO SWIFT VERTICALS', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, letterSpacing: 1.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Dedicated Concierge Services', style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
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
                  color: AppColors.cyan,
                  title: 'Ride',
                  badge: 'Island Chauffeur',
                  description: 'On-demand VIP rides, private airport transfers & luxury island transit.',
                  footerIcon: Icons.verified_user_outlined,
                  footerText: 'Vetted Drivers & Escorts',
                  buttonLabel: 'Book Ride',
                  route: '/customer/ride/booking',
                ),
                _buildServiceCard(
                  context: context,
                  icon: Icons.restaurant_outlined,
                  color: AppColors.gold,
                  title: 'Food',
                  badge: 'Fine Dining & Yacht Delivery',
                  description: 'Michelin-tier island restaurants delivered hot to your door or private slip.',
                  footerIcon: Icons.sailing_outlined,
                  footerText: 'Marina & Dock Direct',
                  buttonLabel: 'Order Food',
                  route: '/customer/food',
                ),
                _buildServiceCard(
                  context: context,
                  icon: Icons.chat_outlined,
                  color: const Color(0xFF00B4D8), // Teal/Cyan variant
                  title: 'Courier',
                  badge: 'Bonded & Insured',
                  description: 'Rapid point-to-point courier & customs document dispatch across Nassau.',
                  footerIcon: Icons.bolt_outlined,
                  footerText: 'Rush 45-Min Service',
                  buttonLabel: 'Send Parcel',
                  route: '/customer/courier/request',
                ),
                _buildServiceCard(
                  context: context,
                  icon: Icons.vpn_key_outlined,
                  color: const Color(0xFFB8860B), // Bronze/Gold variant
                  title: 'Car Rental',
                  badge: 'Executive Fleet',
                  description: 'Cadillac Escalades, Porsche convertibles & SUVs delivered directly to your FBO or villa.',
                  footerIcon: Icons.flight_takeoff_outlined,
                  footerText: 'Tarmac FBO Handover',
                  buttonLabel: 'Select Vehicle',
                  route: '/customer/car-rental/search',
                ),
                _buildServiceCard(
                  context: context,
                  icon: Icons.home_work_outlined,
                  color: const Color(0xFF0096C7), // Darker cyan
                  title: 'Rooms / Properties',
                  badge: 'Luxury Stays',
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
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Account Touchpoints', style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                Text('QUICK MANAGEMENT', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Account Touchpoints Row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Row(
              children: [
                Expanded(child: _buildTouchpointCard(context, Icons.receipt_long_outlined, 'Booking History', 'View past & upcoming rides, meals, and...', '/customer/history')),
                const SizedBox(width: 12),
                Expanded(child: _buildTouchpointCard(context, Icons.favorite_border_outlined, 'Saved Favorites', 'Your preferred chauffeurs, villas, and...', '/customer/favorites')),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String badge,
    required String description,
    required IconData footerIcon,
    required String footerText,
    required String buttonLabel,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title, style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: Text(badge, style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(footerIcon, color: AppColors.textSecondary, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(footerText, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary))),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, route),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                  child: Row(
                    children: [
                      Text(buttonLabel, style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 13)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
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

  Widget _buildTouchpointCard(BuildContext context, IconData icon, String title, String subtitle, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: AppColors.cyan, size: 20),
                ),
                const Icon(Icons.arrow_forward, color: AppColors.textSecondary, size: 16),
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 15)),
            const SizedBox(height: 6),
            Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
