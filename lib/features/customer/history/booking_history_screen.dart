import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'widgets/active_history_card.dart';
import 'widgets/past_history_card.dart';
import 'widgets/cancelled_history_card.dart';

class BookingHistoryScreen extends StatefulWidget {
  final bool embedded;
  const BookingHistoryScreen({super.key, this.embedded = false});
  @override State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  int _activeTab = 0; // 0: Active, 1: Past, 2: Cancelled
  int _selectedFilter = 0;

  final _filters = ['All Bookings', 'Rides & VIP Transit', 'Dining'];

  final _activeData = [
    {
      'type': 'ride',
      'status': 'IN PROGRESS • EN ROUTE',
      'id': '#BS-RD-8492',
      'icon': Icons.directions_car,
      'color': const Color(0xFF00D4FF),
      'title': 'Cadillac Escalade-V Sovereign',
      'subtitle': 'Chauffeur Marcus Vance • Black Edition',
      'rating': 5.0,
      'actions': [
        {'label': 'Live Tracking', 'icon': null, 'trailingIcon': Icons.arrow_forward, 'isPrimary': true},
        {'label': 'Call Driver', 'icon': Icons.phone, 'trailingIcon': null, 'isPrimary': false},
      ],
    },
    {
      'type': 'food',
      'status': 'COURIER DISPATCHED • IN TRANSIT',
      'id': '#BS-FD-8924',
      'icon': Icons.restaurant,
      'color': const Color(0xFFF5A623),
      'title': 'Dune at The Ocean Club',
      'subtitle': 'Paradise Island • White-Glove Butler Route',
      'actions': [
        {'label': 'Track Delivery', 'icon': null, 'trailingIcon': Icons.arrow_forward, 'isPrimary': true},
      ],
    },
    {
      'type': 'courier',
      'status': 'ESCORT IN PROGRESS • SECURE COURIER',
      'id': '#BS-CR-3158',
      'icon': Icons.shield_outlined,
      'color': const Color(0xFF8E8E93),
      'title': 'Tamper-Evident Legal Dossier',
      'subtitle': 'Courier Liam Pinder • Escorted Transit (< 5 lbs)',
      'actions': [
        {'label': 'Live Courier Map', 'icon': null, 'trailingIcon': Icons.my_location, 'isPrimary': true},
      ],
    },
    {
      'type': 'prep',
      'status': 'PREPARING IN KITCHEN • CHEF DISPATCH',
      'id': '#BS-FD-9154',
      'icon': Icons.restaurant,
      'color': const Color(0xFF5E5CE6),
      'title': 'Nobu Atlantis • Bahamas',
      'subtitle': 'Paradise Island • Teppanyaki & Sushi Omakase',
      'actions': [
        {'label': 'Track Kitchen', 'icon': null, 'trailingIcon': Icons.arrow_forward, 'isPrimary': true},
        {'label': 'Order Details', 'icon': Icons.receipt_long, 'trailingIcon': null, 'isPrimary': false},
      ],
    },
    {
      'type': 'rental',
      'status': 'ACTIVE ON TRANSIT',
      'id': '#BS-RN-8394',
      'icon': Icons.vpn_key_outlined,
      'color': const Color(0xFFB8860B),
      'title': 'Range Rover Autobiography',
      'subtitle': 'Renter: Alastair Vance • 68h remaining',
    }
  ];

  final _pastData = [
    {
      'type': 'ride',
      'category': 'Ride Service',
      'id': '#BS-RD-8492',
      'date': 'Yesterday,\nNov 14',
      'icon': Icons.directions_car,
      'color': const Color(0xFF00D4FF),
      'status': 'Completed',
    },
    {
      'type': 'food',
      'category': 'Fine Dining Delivery',
      'id': '#BS-FD-8539',
      'date': 'Nov 12, 8:45\nPM',
      'icon': Icons.restaurant,
      'color': const Color(0xFF5E5CE6),
      'status': 'Delivered',
    },
    {
      'type': 'courier',
      'category': 'Secure Courier Delivery',
      'id': '#BS-CR-3158',
      'date': 'Nov 10, 2:15\nPM',
      'icon': Icons.local_shipping,
      'color': const Color(0xFF00D4FF),
      'status': 'Completed',
    },
    {
      'type': 'rental',
      'category': 'Luxury Car Rental',
      'id': '#BS-RENT-2041',
      'date': 'Nov 05 - Nov\n08 (3 Days)',
      'icon': Icons.vpn_key_outlined,
      'color': const Color(0xFFB8860B),
      'status': 'Returned &\nSettled',
    },
    {
      'type': 'property',
      'category': 'Luxury Villa Stay',
      'id': '#BS-STAY-4071',
      'date': 'Sep 18 - Sep 22',
      'icon': Icons.home_work_outlined,
      'color': const Color(0xFFF5A623),
      'status': 'Completed',
    },
  ];

  final _cancelledData = [
    {
      'type': 'ride',
      'category': 'Ride Service',
      'id': 'SW-8471',
      'date': 'Oct 11, 2024 • 4:15 PM',
      'icon': Icons.directions_car,
      'cancelReason': 'CANCELLED BY PAX',
      'actionLabel': 'Rebook Ride',
      'actionIcon': Icons.replay,
    },
    {
      'type': 'food',
      'category': 'Dining & Fine Delivery',
      'id': 'SW-8439',
      'date': 'Sep 22, 2024 • 6:30 PM',
      'icon': Icons.restaurant,
      'cancelReason': 'VOIDED BY CONCIERGE',
      'actionLabel': 'Order Again',
      'actionIcon': Icons.shopping_bag_outlined,
    }
  ];

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (!widget.embedded) ...[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Text('History', style: AppTextStyles.headlineMedium.copyWith(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.notifications_none, color: AppColors.textSecondary, size: 24),
                  const SizedBox(width: 16),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.cyan)),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset('assets/images/user_avatar.jpg', fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(color: AppColors.surface),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Header Texts
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _activeTab == 0 ? 'Active History' : _activeTab == 1 ? 'Past History' : 'Cancelled History',
                style: AppTextStyles.headlineMedium.copyWith(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                _activeTab == 0 ? 'Archived concierge itineraries, VIP dispatches, and tax-ready settled waybills.'
                : _activeTab == 1 ? 'Archived luxury transit, maritime deliveries, and concierge ledgers.'
                : 'Refunded reservations, voided dispatches, and zero-fee escrows.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),

        // Custom Segmented Control
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _buildSegment(0, 'Active', '1'),
                _buildSegment(1, 'Past', '41'),
                _buildSegment(2, 'Cancelled', '2'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Sub-filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildFilterChip(0, 'All Bookings', count: 42),
              const SizedBox(width: 8),
              _buildFilterChip(1, 'Rides & VIP Transit', icon: Icons.directions_car_outlined),
              const SizedBox(width: 8),
              _buildFilterChip(2, 'Dining', icon: Icons.restaurant_outlined),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: _activeTab == 0 ? _activeData.length : _activeTab == 1 ? _pastData.length : _cancelledData.length,
            itemBuilder: (c, i) {
              if (_activeTab == 0) {
                return ActiveHistoryCard(data: _activeData[i]);
              } else if (_activeTab == 1) {
                return PastHistoryCard(data: _pastData[i]);
              } else {
                return CancelledHistoryCard(data: _cancelledData[i]);
              }
            },
          ),
        ),
      ],
    );

    return widget.embedded ? content : Scaffold(body: SafeArea(child: content));
  }

  Widget _buildSegment(int index, String label, String count) {
    final isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.background : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? AppColors.border : Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected && index == 0) ...[
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)),
                const SizedBox(width: 6),
              ] else if (isSelected && index == 1) ...[
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.textSecondary, shape: BoxShape.circle)),
                const SizedBox(width: 6),
              ] else if (isSelected && index == 2) ...[
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: isSelected ? AppColors.surface : AppColors.background, borderRadius: BorderRadius.circular(10)),
                child: Text(count, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(int index, String label, {int? count, IconData? icon}) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyan : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.cyan : AppColors.border),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? AppColors.background : AppColors.textSecondary),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.background : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.background.withOpacity(0.2) : AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(color: isSelected ? AppColors.background : AppColors.cyan, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
