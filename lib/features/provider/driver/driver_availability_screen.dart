import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';
import 'driver_earnings_screen.dart';
import 'driver_ride_history_screen.dart';
import 'driver_ratings_screen.dart';
import 'driver_profile_screen.dart';

class DriverAvailabilityScreen extends StatefulWidget {
  const DriverAvailabilityScreen({super.key});
  @override State<DriverAvailabilityScreen> createState() => _DriverAvailabilityScreenState();
}
class _DriverAvailabilityScreenState extends State<DriverAvailabilityScreen> {
  bool _online = true;
  int _nav = 0;

  Widget _body() {
    switch (_nav) {
      case 1: return const DriverEarningsScreen(embedded: true);
      case 2: return const DriverRideHistoryScreen(embedded: true);
      case 3: return const DriverRatingsScreen(embedded: true);
      case 4: return const DriverProfileScreen(embedded: true);
      default: return _homeTab();
    }
  }

  Widget _homeTab() => SingleChildScrollView(child: Column(children: [
    // Hero card
    Container(margin: const EdgeInsets.all(20), padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0A2030), Color(0xFF0D1117)]), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.cyan.withOpacity(0.2))),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Captain Terrence Rolle', style: AppTextStyles.headlineMedium), Text('VIP Chauffeur  •  #CH-402', style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan)), const SizedBox(height: 6), Row(children: [const Icon(Icons.star, color: AppColors.gold, size: 14), const SizedBox(width: 4), Text('4.98 • 620+ trips', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold))])]),
          Container(width: 64, height: 64, decoration: BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle, border: Border.all(color: AppColors.cyan.withOpacity(0.3), width: 3)), child: const Icon(Icons.person, color: AppColors.background, size: 32)),
        ]),
        const SizedBox(height: 20),
        // Online toggle
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.3), borderRadius: BorderRadius.circular(16)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_online ? 'ONLINE' : 'OFFLINE', style: AppTextStyles.labelSmall.copyWith(color: _online ? AppColors.green : AppColors.textMuted)), Text(_online ? 'Ready for dispatch' : 'Not accepting rides', style: AppTextStyles.titleMedium.copyWith(color: _online ? AppColors.textPrimary : AppColors.textSecondary))]),
            GestureDetector(onTap: () => setState(() => _online = !_online),
              child: AnimatedContainer(duration: const Duration(milliseconds: 300), width: 64, height: 36, decoration: BoxDecoration(color: _online ? AppColors.green : AppColors.surface, borderRadius: BorderRadius.circular(20)),
                child: AnimatedAlign(duration: const Duration(milliseconds: 300), alignment: _online ? Alignment.centerRight : Alignment.centerLeft, child: Container(width: 28, height: 28, margin: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))))),
          ])),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _statBox('Today\'s Earnings', '\$284.00', AppColors.gold, Icons.attach_money)),
          const SizedBox(width: 12), Expanded(child: _statBox('Trips Today', '8', AppColors.cyan, Icons.directions_car)),
        ]),
      ])),
    // Ride requests
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Incoming Requests', style: AppTextStyles.headlineSmall), GestureDetector(onTap: () => Navigator.pushNamed(context, '/provider/driver/requests'), child: Text('View All', style: AppTextStyles.cyanLabel))])),
    const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _RideRequestCard()),
    const SizedBox(height: 20),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Quick Actions', style: AppTextStyles.headlineSmall)])),
    const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2.5,
      children: [
        _quickAction(Icons.receipt_long_outlined, 'Ride History', () => Navigator.pushNamed(context, '/provider/driver/history')),
        _quickAction(Icons.attach_money, 'Earnings', () => Navigator.pushNamed(context, '/provider/driver/earnings')),
        _quickAction(Icons.badge_outlined, 'Documents', () => Navigator.pushNamed(context, '/provider/driver/documents')),
        _quickAction(Icons.star_outline, 'My Ratings', () => Navigator.pushNamed(context, '/provider/driver/ratings')),
      ])),
    const SizedBox(height: 24),
  ]));

  Widget _statBox(String label, String val, Color color, IconData icon) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.3), borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(icon, color: color, size: 18), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: AppTextStyles.caption), Text(val, style: AppTextStyles.headlineSmall.copyWith(color: color))])]));
  Widget _quickAction(IconData icon, String label, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 0.5)), child: Row(children: [Icon(icon, color: AppColors.textSecondary, size: 20), const SizedBox(width: 10), Text(label, style: AppTextStyles.titleMedium), const Spacer(), const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 16)])));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        // Top bar
        Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Row(children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.bolt, color: AppColors.background, size: 20)),
          const SizedBox(width: 8), Text('Driver Hub', style: AppTextStyles.titleLarge.copyWith(color: AppColors.cyan)), const Spacer(),
          GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/notifications'), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.notifications_none_outlined, color: AppColors.textPrimary, size: 22))),
        ])),
        Expanded(child: _body()),
      ])),
      bottomNavigationBar: _driverNav(),
    );
  }

  Widget _driverNav() => Container(decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.border, width: 0.5))),
    child: SafeArea(top: false, child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      _ni(Icons.home_outlined, Icons.home, 'Home', 0),
      _ni(Icons.attach_money, Icons.attach_money, 'Earnings', 1),
      _ni(Icons.receipt_long_outlined, Icons.receipt_long, 'History', 2),
      _ni(Icons.star_outline, Icons.star, 'Ratings', 3),
      _ni(Icons.person_outline, Icons.person, 'Profile', 4),
    ]))));

  Widget _ni(IconData icon, IconData activeIcon, String label, int idx) => GestureDetector(onTap: () => setState(() => _nav = idx), behavior: HitTestBehavior.opaque, child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(_nav == idx ? activeIcon : icon, color: _nav == idx ? AppColors.cyan : AppColors.textMuted, size: 24), const SizedBox(height: 4), Text(label, style: AppTextStyles.caption.copyWith(color: _nav == idx ? AppColors.cyan : AppColors.textMuted))]));
}

class _RideRequestCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cyan.withOpacity(0.3), width: 1)),
      child: Column(children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text('NEW REQUEST', style: AppTextStyles.goldLabel)),
          const Spacer(),
          Text('TRIP #SW-8521', style: AppTextStyles.cyanLabel),
        ]),
        const SizedBox(height: 14),
        Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.cyan, size: 18), const SizedBox(width: 8), Expanded(child: Text('Lynden Pindling Int\'l Airport (NAS)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)))]),
        const SizedBox(height: 6),
        Row(children: [const Icon(Icons.flag_outlined, color: AppColors.gold, size: 18), const SizedBox(width: 8), Expanded(child: Text('The Ocean Club, Paradise Island', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)))]),
        const SizedBox(height: 12),
        Row(children: [
          _chip(Icons.route, '14.2 km'), const SizedBox(width: 8), _chip(Icons.attach_money, '\$118.50'), const SizedBox(width: 8), _chip(Icons.access_time, '18 min'),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)), child: const Center(child: Text('Decline', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)))))),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/provider/driver/active-ride'), child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(gradient: AppColors.cyanGradient, borderRadius: BorderRadius.circular(10)), child: Center(child: Text('Accept Ride →', style: AppTextStyles.buttonText))))),
        ]),
      ]));
  }
  Widget _chip(IconData icon, String label) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)), child: Row(children: [Icon(icon, size: 14, color: AppColors.textSecondary), const SizedBox(width: 4), Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))]));
}
