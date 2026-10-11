import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  final bool embedded;
  const NotificationsScreen({super.key, this.embedded = false});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.embedded)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: widget.embedded ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Text('Notifications', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(
                      'GO SWIFT CONCIERGE',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              _buildFilterChip(0, 'All', count: 5),
              const SizedBox(width: 8),
              _buildFilterChip(1, 'Rides', icon: Icons.directions_car_outlined),
              const SizedBox(width: 8),
              _buildFilterChip(2, 'Food', icon: Icons.restaurant_outlined),
              const SizedBox(width: 8),
              _buildFilterChip(3, 'Courier', icon: Icons.local_shipping_outlined),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              _buildSectionHeader('NEW & ACTIVE', '2 Updates'),
              _buildNotificationCard(
                category: 'RIDE • VIP CHAUFFEUR',
                title: 'Driver Marcus Arriving in 3 Mins',
                body: 'Mercedes-Maybach S580 (Plate BS-7492) is approaching Odyssey Aviation FBO pickup terminal.',
                time: 'Just now',
                icon: Icons.directions_car_outlined,
                iconColor: AppColors.cyan,
                iconBgColor: AppColors.cyanLight,
                badgeText: 'Active Ride',
                badgeColor: AppColors.cyan,
                badgeBgColor: AppColors.cyanLight,
                actionText: 'Track Ride →',
              ),
              _buildNotificationCard(
                category: 'FOOD & DINING',
                title: 'Order Out for Delivery',
                body: 'Dune at The Ocean Club has handed your order #SW-FD-892 to Chauffeur Devon.',
                time: '14m ago',
                icon: Icons.restaurant_outlined,
                iconColor: AppColors.gold,
                iconBgColor: AppColors.goldLight,
                badgeText: 'In Transit',
                badgeColor: AppColors.gold,
                badgeBgColor: AppColors.goldLight,
                actionText: 'View Food Status →',
              ),

              _buildSectionHeader('EARLIER TODAY', '2 Updates'),
              _buildNotificationCard(
                category: 'COURIER & FREIGHT',
                title: 'Package Secured & Picked Up',
                body: 'Courier Liam collected secure documents from Lyford Cay Club Concierge. En route to Downtown Nassau.',
                time: '1h ago',
                icon: Icons.local_shipping_outlined,
                iconColor: AppColors.courierBlue,
                iconBgColor: AppColors.courierBlueLight,
                badgeText: 'En Route',
                badgeColor: AppColors.courierBlue,
                badgeBgColor: AppColors.courierBlueLight,
                actionText: 'Live Courier Map →',
              ),
              _buildNotificationCard(
                category: 'CAR RENTAL',
                title: 'Vehicle Ready for Handover',
                body: 'Porsche 911 Carrera Cabriolet pre-inspection passed. Ready at Lyford Cay Marina Bay #4.',
                time: '3h ago',
                icon: Icons.vpn_key_outlined,
                iconColor: AppColors.fleetTan,
                iconBgColor: AppColors.fleetTanLight,
                badgeText: 'Confirmed',
                badgeColor: AppColors.fleetTan,
                badgeBgColor: AppColors.fleetTanLight,
                actionText: 'View Rental Details →',
              ),

              _buildSectionHeader('YESTERDAY', '1 Update'),
              _buildNotificationCard(
                category: 'PROPERTY & VILLA',
                title: 'Stay Confirmed & Gate Pass Active',
                body: 'The Sovereign Ocean Villa booking #BS-STAY-4071 confirmed by Julian Turnquest. Digital gate access code generated.',
                time: 'Yesterday',
                icon: Icons.home_work_outlined,
                iconColor: AppColors.staysTeal,
                iconBgColor: AppColors.staysTealLight,
                badgeText: 'Gate Active',
                badgeColor: AppColors.staysTeal,
                badgeBgColor: AppColors.staysTealLight,
                actionText: 'View Property Booking →',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
    return widget.embedded ? content : Scaffold(backgroundColor: AppColors.background, body: SafeArea(child: content));
  }

  Widget _buildFilterChip(int index, String label, {int? count, IconData? icon}) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyanPill : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.cyan.withOpacity(0.3) : AppColors.border, width: 0.8),
          boxShadow: isSelected ? null : AppColors.softShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? AppColors.cyan : AppColors.textSecondary),
              const SizedBox(width: 6),
            ],
            Text(
              count != null ? '$label $count' : label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.cyan : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String countText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1.0, fontWeight: FontWeight.bold)),
          Text(countText, style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String category,
    required String title,
    required String body,
    required String time,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    String? badgeText,
    Color? badgeColor,
    Color? badgeBgColor,
    required String actionText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                        ),
                        Text(time, style: AppTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(body, style: AppTextStyles.bodySmall.copyWith(height: 1.3)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBgColor ?? AppColors.cyanLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    style: AppTextStyles.labelSmall.copyWith(color: badgeColor ?? AppColors.cyan, fontWeight: FontWeight.bold),
                  ),
                )
              else
                const SizedBox.shrink(),
              Text(
                actionText,
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
