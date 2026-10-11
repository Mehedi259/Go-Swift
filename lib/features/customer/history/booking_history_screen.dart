import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/models/food_model.dart';
import '../../../core/models/courier_model.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/models/property_model.dart';
import '../../../core/services/ride_service.dart';
import '../../../core/services/food_service.dart';
import '../../../core/services/courier_service.dart';
import '../../../core/services/car_rental_service.dart';
import '../../../core/services/room_service.dart';
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
  bool _isLoading = false;

  final List<Map<String, dynamic>> _liveActive = [];
  final List<Map<String, dynamic>> _livePast = [];
  final List<Map<String, dynamic>> _liveCancelled = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        RideService().getMyRides().catchError((_) => <RideModel>[]),
        FoodService().getMyOrders().catchError((_) => <FoodOrderModel>[]),
        CourierService().getMyDeliveries().catchError((_) => <CourierDeliveryModel>[]),
        CarRentalService().getMyBookings().catchError((_) => <CarRentalBookingModel>[]),
        RoomService().getMyBookings().catchError((_) => <RoomBookingModel>[]),
      ]);

      final rides = results[0] as List<RideModel>;
      final orders = results[1] as List<FoodOrderModel>;
      final deliveries = results[2] as List<CourierDeliveryModel>;
      final rentals = results[3] as List<CarRentalBookingModel>;
      final rooms = results[4] as List<RoomBookingModel>;

      final newActive = <Map<String, dynamic>>[];
      final newPast = <Map<String, dynamic>>[];
      final newCancelled = <Map<String, dynamic>>[];

      for (final r in rides) {
        final map = {
          'type': 'ride',
          'status': r.status.toUpperCase(),
          'id': '#BS-RD-${r.id}',
          'icon': Icons.directions_car,
          'color': AppColors.primaryTeal,
          'title': r.destinationAddress,
          'subtitle': 'Pickup: ${r.pickupAddress}',
          'category': 'Ride Service',
          'date': r.createdAt != null && r.createdAt!.length >= 10 ? r.createdAt!.substring(0, 10) : 'Recent',
        };
        if (r.status == 'cancelled') {
          newCancelled.add(map);
        } else if (r.status == 'completed') {
          newPast.add(map);
        } else {
          newActive.add(map);
        }
      }

      for (final o in orders) {
        final map = {
          'type': 'food',
          'status': o.status.toUpperCase(),
          'id': '#BS-FD-${o.id}',
          'icon': Icons.restaurant,
          'color': const Color(0xFFC78400),
          'title': o.restaurantName,
          'subtitle': o.deliveryAddress,
          'category': 'Dining Delivery',
          'date': o.createdAt != null && o.createdAt!.length >= 10 ? o.createdAt!.substring(0, 10) : 'Recent',
        };
        if (o.status == 'cancelled') {
          newCancelled.add(map);
        } else if (o.status == 'delivered' || o.status == 'completed') {
          newPast.add(map);
        } else {
          newActive.add(map);
        }
      }

      for (final d in deliveries) {
        final map = {
          'type': 'courier',
          'status': d.status.toUpperCase(),
          'id': '#BS-CR-${d.id}',
          'icon': Icons.shield_outlined,
          'color': AppColors.primaryTeal,
          'title': d.dropoffAddress,
          'subtitle': 'Pickup: ${d.pickupAddress}',
          'category': 'Courier Service',
          'date': d.createdAt != null && d.createdAt!.length >= 10 ? d.createdAt!.substring(0, 10) : 'Recent',
        };
        if (d.status == 'cancelled') {
          newCancelled.add(map);
        } else if (d.status == 'delivered' || d.status == 'completed') {
          newPast.add(map);
        } else {
          newActive.add(map);
        }
      }

      for (final rn in rentals) {
        final map = {
          'type': 'rental',
          'status': rn.status.toUpperCase(),
          'id': '#BS-RN-${rn.id}',
          'icon': Icons.vpn_key_outlined,
          'color': const Color(0xFFB8860B),
          'title': rn.vehicleName,
          'subtitle': '${rn.startDate} to ${rn.endDate}',
          'category': 'Car Rental',
          'date': rn.startDate,
        };
        if (rn.status == 'cancelled') {
          newCancelled.add(map);
        } else if (rn.status == 'completed' || rn.status == 'returned') {
          newPast.add(map);
        } else {
          newActive.add(map);
        }
      }

      for (final rm in rooms) {
        final map = {
          'type': 'property',
          'status': rm.status.toUpperCase(),
          'id': '#BS-RM-${rm.id}',
          'icon': Icons.hotel_outlined,
          'color': AppColors.primaryTeal,
          'title': rm.propertyTitle ?? 'Luxury Villa',
          'subtitle': '${rm.checkInDate} to ${rm.checkOutDate}',
          'category': 'Room Service',
          'date': rm.checkInDate,
        };
        if (rm.status == 'cancelled') {
          newCancelled.add(map);
        } else if (rm.status == 'completed' || rm.status == 'checked_out') {
          newPast.add(map);
        } else {
          newActive.add(map);
        }
      }

      if (mounted) {
        setState(() {
          _liveActive.clear();
          _liveActive.addAll(newActive);
          _livePast.clear();
          _livePast.addAll(newPast);
          _liveCancelled.clear();
          _liveCancelled.addAll(newCancelled);
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  final _activeData = [
    {
      'type': 'ride',
      'status': 'IN PROGRESS • EN ROUTE',
      'id': '#BS-RD-8492',
      'icon': Icons.directions_car,
      'color': AppColors.primaryTeal,
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
      'color': const Color(0xFFC78400),
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
      'color': AppColors.primaryTeal,
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
      'color': AppColors.primaryTeal,
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
      'color': AppColors.primaryTeal,
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
      'color': const Color(0xFFC78400),
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
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                  Text('History', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary)),
                ],
              ),
              Row(
                children: [
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
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primaryTeal, width: 1.5)),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset('assets/images/user_avatar.jpg', fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(color: AppColors.badgeTeal),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Header Texts
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _activeTab == 0 ? 'Active History' : _activeTab == 1 ? 'Past History' : 'Cancelled History',
                style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary, fontSize: 24),
              ),
              const SizedBox(height: 6),
              Text(
                _activeTab == 0
                    ? 'Archived concierge itineraries, VIP dispatches, and tax-ready settled waybills.'
                    : _activeTab == 1
                        ? 'Archived luxury transit, maritime deliveries, and concierge ledgers.'
                        : 'Refunded reservations, voided dispatches, and zero-fee escrows.',
                style: AppTextStyles.bodyMedium,
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
              color: AppColors.cardTouchpoint,
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
        const SizedBox(height: 14),

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
        const SizedBox(height: 14),

        // List
        Expanded(
          child: _isLoading && _liveActive.isEmpty && _livePast.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
              : RefreshIndicator(
                  onRefresh: _loadHistory,
                  color: AppColors.primaryTeal,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _activeTab == 0
                  ? (_liveActive.length + _activeData.length)
                  : _activeTab == 1
                      ? (_livePast.length + _pastData.length)
                      : (_liveCancelled.length + _cancelledData.length),
              itemBuilder: (c, i) {
                if (_activeTab == 0) {
                  final list = [..._liveActive, ..._activeData];
                  return ActiveHistoryCard(data: list[i]);
                } else if (_activeTab == 1) {
                  final list = [..._livePast, ..._pastData];
                  return PastHistoryCard(data: list[i]);
                } else {
                  final list = [..._liveCancelled, ..._cancelledData];
                  return CancelledHistoryCard(data: list[i]);
                }
              },
            ),
          ),
        ),
      ],
    );

    return widget.embedded ? content : Scaffold(backgroundColor: AppColors.background, body: SafeArea(child: content));
  }

  Widget _buildSegment(int index, String label, String count) {
    final isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? AppColors.cardShadow : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle)),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected ? AppColors.primaryTeal : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cyanPill : Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count,
                  style: AppTextStyles.caption.copyWith(color: isSelected ? AppColors.primaryTeal : AppColors.textSecondary, fontWeight: FontWeight.bold),
                ),
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
          color: isSelected ? AppColors.cyanPill : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primaryTeal : AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? AppColors.primaryTeal : AppColors.textSecondary),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primaryTeal : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryTeal : AppColors.cardTouchpoint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(color: isSelected ? Colors.white : AppColors.primaryTeal, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
