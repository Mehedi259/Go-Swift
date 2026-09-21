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
        // App Bar equivalent
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.embedded)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Icon(Icons.arrow_back, color: AppColors.cyan, size: 24),
                  ),
                ),
              if (!widget.embedded) const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: widget.embedded ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Text('Notifications', style: AppTextStyles.headlineMedium.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('GO SWIFT CONCIERGE', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              _buildFilterChip(0, 'All', count: 5),
              const SizedBox(width: 12),
              _buildFilterChip(1, 'Rides', icon: Icons.directions_car_outlined),
              const SizedBox(width: 12),
              _buildFilterChip(2, 'Food', icon: Icons.restaurant_outlined),
              const SizedBox(width: 12),
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
                color: const Color(0xFF00D4FF),
                badgeText: 'Active Ride',
                actionText: 'Track Ride',
              ),
              _buildNotificationCard(
                category: 'FOOD & DINING',
                title: 'Order Out for Delivery',
                body: 'Dune at The Ocean Club has handed your order #SW-FD-892 to Chauffeur Devon.',
                time: '14m ago',
                icon: Icons.restaurant_outlined,
                color: const Color(0xFF5E5CE6),
                badgeText: 'In Transit',
                actionText: 'View Food Status',
              ),
              
              _buildSectionHeader('EARLIER TODAY', '2 Updates'),
              _buildNotificationCard(
                category: 'COURIER & FREIGHT',
                title: 'Package Secured & Picked Up',
                body: 'Courier Liam collected secure documents from Lyford Cay Club Concierge. En route to Downtown Nassau.',
                time: '1h ago',
                icon: Icons.local_shipping_outlined,
                color: const Color(0xFF8E8E93),
                badgeText: 'En Route',
                actionText: 'Live Courier Map',
              ),
              _buildNotificationCard(
                category: 'CAR RENTAL',
                title: 'Vehicle Ready for Handover',
                body: 'Porsche 911 Carrera Cabriolet pre-inspection passed. Ready at Lyford Cay Marina Bay #4.',
                time: '3h ago',
                icon: Icons.vpn_key_outlined,
                color: const Color(0xFFB8860B),
                badgeText: 'Confirmed',
                actionText: 'View Rental Details',
              ),
              
              _buildSectionHeader('YESTERDAY', '1 Update'),
              _buildNotificationCard(
                category: 'PROPERTY & VILLA',
                title: 'Stay Confirmed & Gate Pass Active',
                body: 'The Sovereign Ocean Villa booking #BS-STAY-4071 confirmed by Julian Turnquest. Digital gate access code generated.',
                time: 'Yesterday',
                icon: Icons.home_work_outlined,
                color: const Color(0xFFF5A623),
                badgeText: null, 
                actionText: 'View Property\nBooking',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
    return widget.embedded ? content : Scaffold(body: SafeArea(child: content));
  }

  Widget _buildFilterChip(int index, String label, {int? count, IconData? icon}) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyan.withOpacity(0.15) : AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.cyan : AppColors.border),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: AppColors.cyan,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(color: AppColors.background, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0, fontWeight: FontWeight.bold)),
          Text(subtitle, style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan.withOpacity(0.8), fontWeight: FontWeight.bold)),
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
    required Color color,
    String? badgeText,
    required String actionText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.6)),
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(category, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary, letterSpacing: 0.5, fontWeight: FontWeight.bold))),
                    Text(time, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(title, style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 6),
                Text(body, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4, fontSize: 13)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (badgeText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            if (badgeText == 'Active Ride') ...[
                              Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                              const SizedBox(width: 6),
                            ],
                            Text(badgeText, style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    else
                      Expanded(
                        child: Text(actionText, style: AppTextStyles.titleMedium.copyWith(color: color, fontSize: 14)),
                      ),
                      
                    if (badgeText != null)
                      Row(
                        children: [
                          Text(actionText, style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 14)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                        ],
                      )
                    else
                      Icon(Icons.arrow_forward, color: color, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
