import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'rental_booking_management_screen.dart';
import 'rental_earnings_screen.dart';
import 'rental_provider_profile_screen.dart';
import 'vehicle_listings_screen.dart';

class CarRentalHubScreen extends StatefulWidget {
  final int initialTab;
  const CarRentalHubScreen({super.key, this.initialTab = 0});

  @override
  State<CarRentalHubScreen> createState() => _CarRentalHubScreenState();
}

class _CarRentalHubScreenState extends State<CarRentalHubScreen> {
  late int _currentIndex;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  void _onSelectTab(int index) {
    if (mounted) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
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
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            VehicleListingsScreen(embedded: true),
            RentalBookingManagementScreen(embedded: true),
            RentalEarningsScreen(embedded: true),
            RentalProviderProfileScreen(embedded: true),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border, width: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.directions_car_outlined, Icons.directions_car, 'Fleet', 0),
              _navItem(Icons.calendar_month_outlined, Icons.calendar_month, 'Bookings', 1),
              _navItem(Icons.attach_money, Icons.attach_money, 'Earnings', 2),
              _navItem(Icons.business_outlined, Icons.business, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, IconData activeIcon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onSelectTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.cyanLight : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.cyan : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isActive ? AppColors.cyan : AppColors.textMuted,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
