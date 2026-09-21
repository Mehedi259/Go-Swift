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
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Row(children: [
            Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.bolt, color: AppColors.background, size: 20)),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Text('GO ', style: AppTextStyles.titleLarge.copyWith(color: Colors.white)), Text('SWIFT', style: AppTextStyles.titleLarge.copyWith(color: AppColors.cyan))]),
              Text('BAHAMAS', style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold, letterSpacing: 2)),
            ]),
            const Spacer(),
            GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/notifications'),
              child: Stack(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: const Icon(Icons.notifications_none_outlined, color: AppColors.textPrimary, size: 22)),
                Positioned(top: 6, right: 6, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle))),
              ])),
            const SizedBox(width: 10),
            Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle), child: const Icon(Icons.person, color: AppColors.background, size: 22)),
          ])),

          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Welcome back,', style: AppTextStyles.bodyMedium),
            Text('Alexander Vance', style: AppTextStyles.displayMedium),
            const SizedBox(height: 4),
            Text('Nassau, New Providence Island', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ])),

          // Active dispatch
          Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0A2A3A), Color(0xFF0F1D2E)]),
              borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.cyan.withOpacity(0.3))),
            child: Column(children: [
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.green.withOpacity(0.4))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)), const SizedBox(width: 6), Text('ACTIVE DISPATCH', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green))])),
                const Spacer(),
                Text('TRIP #SW-8492', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                const Icon(Icons.directions_car, color: AppColors.cyan, size: 28),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Captain Terrence Rolle', style: AppTextStyles.titleLarge),
                  Text('VIP Licensed Chauffeur • 4.98 ★', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold)),
                ]),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                  child: Column(children: [Text('18 min', style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan)), Text('away', style: AppTextStyles.bodySmall)])),
              ]),
              const SizedBox(height: 12),
              GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/ride/active'),
                child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(gradient: AppColors.cyanGradient, borderRadius: BorderRadius.circular(12)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Track Active Ride', style: AppTextStyles.buttonText),
                    const SizedBox(width: 8), const Icon(Icons.arrow_forward, size: 18, color: AppColors.background)]))),
            ])),
          )),

          // Services
          Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 0), child: Text('Go Swift Services', style: AppTextStyles.headlineMedium)),
          Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 0), child: GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.9,
            children: [
              _serviceGrid(context, Icons.directions_car, 'Ride & Chauffeur', '/customer/ride/booking', AppColors.cyan),
              _serviceGrid(context, Icons.restaurant, 'Food & Dining', '/customer/food', AppColors.orange),
              _serviceGrid(context, Icons.local_shipping_outlined, 'Courier & Delivery', '/customer/courier/request', AppColors.green),
              _serviceGrid(context, Icons.vpn_key_outlined, 'Car Rental', '/customer/car-rental/search', AppColors.gold),
              _serviceGrid(context, Icons.villa_outlined, 'Rooms & Properties', '/customer/properties/search', const Color(0xFF9B59B6)),
              _serviceGrid(context, Icons.more_horiz, 'More Services', '/customer/hub', AppColors.textSecondary),
            ])),

          // Account Touchpoints
          Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Account Touchpoints', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            _touchpoint(context, Icons.receipt_long_outlined, 'Booking History', 'View and manage past trips', '/customer/history'),
            _touchpoint(context, Icons.favorite_border, 'Saved Favorites', 'Restaurants & properties saved', '/customer/favorites'),
            _touchpoint(context, Icons.notifications_none_outlined, 'Notifications', 'Alerts and dispatch messages', '/customer/notifications'),
            _touchpoint(context, Icons.person_outline, 'Profile Settings', 'Account and preferences', '/customer/profile'),
            _touchpoint(context, Icons.headset_mic_outlined, 'Support & Help', 'Live concierge chat', '/customer/support'),
          ])),
        ]),
      ),
    );
  }

  Widget _serviceGrid(BuildContext context, IconData icon, String label, String route, Color color) {
    return GestureDetector(onTap: () => Navigator.pushNamed(context, route),
      child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22)),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.center),
        ])));
  }

  Widget _touchpoint(BuildContext context, IconData icon, String title, String sub, String route) {
    return GestureDetector(onTap: () => Navigator.pushNamed(context, route),
      child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.textSecondary, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: AppTextStyles.titleMedium), Text(sub, style: AppTextStyles.bodySmall)])),
          const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        ])));
  }
}
