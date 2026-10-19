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
        final fareStr = '\$${(r.finalFare ?? r.estimatedFare).toStringAsFixed(2)}';
        final driver = r.driver?.legalName ?? 'VIP Chauffeur';
        final vehicle = r.driver != null && r.driver!.vehicleMake != null
            ? '${r.driver!.vehicleMake} ${r.driver!.vehicleModel ?? ''}'.trim()
            : (r.requestedVehicleCategory != null ? r.requestedVehicleCategory!.replaceAll('_', ' ').toUpperCase() : 'Luxury Chauffeur');

        final map = {
          'type': 'ride',
          'status': r.status.toUpperCase(),
          'rawStatus': r.status.toLowerCase(),
          'model': r,
          'rawId': r.id,
          'id': '#BS-RD-${r.id}',
          'icon': Icons.directions_car,
          'color': AppColors.primaryTeal,
          'title': r.destinationAddress,
          'subtitle': 'Pickup: ${r.pickupAddress}',
          'category': 'Ride Service',
          'date': r.createdAt != null && r.createdAt!.length >= 10 ? r.createdAt!.substring(0, 10) : 'Recent',
          'pickup': r.pickupAddress,
          'destination': r.destinationAddress,
          'driverName': driver,
          'vehicle': vehicle,
          'fare': fareStr,
          'cancelReason': r.status == 'cancelled' ? 'CANCELLED' : null,
          'actionLabel': 'Rebook Ride',
          'actionIcon': Icons.replay,
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
        final itemsStr = o.items.isNotEmpty
            ? o.items.map((i) => '${i.name} (x${i.quantity})').join(', ')
            : 'Curated Dining Order';
        final fareStr = '\$${o.totalAmount.toStringAsFixed(2)}';

        final map = {
          'type': 'food',
          'status': o.status.toUpperCase(),
          'rawStatus': o.status.toLowerCase(),
          'model': o,
          'rawId': o.id,
          'id': '#BS-FD-${o.id}',
          'icon': Icons.restaurant,
          'color': const Color(0xFFC78400),
          'title': o.restaurantName ?? 'Fine Dining',
          'subtitle': o.deliveryAddress ?? 'Customer Villa',
          'category': 'Dining Delivery',
          'date': o.createdAt != null && o.createdAt!.length >= 10 ? o.createdAt!.substring(0, 10) : 'Recent',
          'restaurant': o.restaurantName ?? 'Fine Dining',
          'destination': o.deliveryAddress ?? 'Customer Villa',
          'items': itemsStr,
          'fare': fareStr,
          'cancelReason': o.status == 'cancelled' ? 'VOIDED' : null,
          'actionLabel': 'Order Again',
          'actionIcon': Icons.shopping_bag_outlined,
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
        final fareStr = '\$${d.fee.toStringAsFixed(2)}';
        final map = {
          'type': 'courier',
          'status': d.status.toUpperCase(),
          'rawStatus': d.status.toLowerCase(),
          'model': d,
          'rawId': d.id,
          'id': '#BS-CR-${d.id}',
          'icon': Icons.shield_outlined,
          'color': AppColors.primaryTeal,
          'title': d.dropoffAddress,
          'subtitle': 'Pickup: ${d.pickupAddress}',
          'category': 'Courier Service',
          'date': d.createdAt != null && d.createdAt!.length >= 10 ? d.createdAt!.substring(0, 10) : 'Recent',
          'pickup': d.pickupAddress,
          'destination': d.dropoffAddress,
          'fare': fareStr,
          'cancelReason': d.status == 'cancelled' ? 'CANCELLED' : null,
          'actionLabel': 'Dispatch Again',
          'actionIcon': Icons.replay,
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
        final fareStr = '\$${rn.totalPrice.toStringAsFixed(2)}';
        final map = {
          'type': 'rental',
          'status': rn.status.toUpperCase(),
          'rawStatus': rn.status.toLowerCase(),
          'model': rn,
          'rawId': rn.id,
          'id': '#BS-RN-${rn.id}',
          'icon': Icons.vpn_key_outlined,
          'color': const Color(0xFFB8860B),
          'title': rn.vehicleName,
          'subtitle': '${rn.startDate.split('T').first} to ${rn.endDate.split('T').first}',
          'category': 'Car Rental',
          'date': rn.startDate.split('T').first,
          'vehicle': rn.vehicleName,
          'pickup': 'FBO / Marina Handover',
          'destination': 'Escort Return Point',
          'fare': fareStr,
          'cancelReason': rn.status == 'cancelled' ? 'CANCELLED' : null,
          'actionLabel': 'Rent Again',
          'actionIcon': Icons.replay,
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
        final fareStr = '\$${rm.totalPrice.toStringAsFixed(2)}';
        final map = {
          'type': 'property',
          'status': rm.status.toUpperCase(),
          'rawStatus': rm.status.toLowerCase(),
          'model': rm,
          'rawId': rm.id,
          'id': '#BS-RM-${rm.id}',
          'icon': Icons.hotel_outlined,
          'color': AppColors.primaryTeal,
          'title': rm.propertyTitle ?? 'Luxury Villa',
          'subtitle': '${rm.checkInDate.isNotEmpty ? rm.checkInDate.split('T').first : ''} to ${rm.checkOutDate.isNotEmpty ? rm.checkOutDate.split('T').first : ''}',
          'category': 'Room Service',
          'date': rm.checkInDate.isNotEmpty ? rm.checkInDate.split('T').first : '',
          'property': rm.propertyTitle ?? 'Luxury Villa',
          'pickup': 'Check-in: ${rm.checkInDate.isNotEmpty ? rm.checkInDate.split('T').first : ''}',
          'destination': 'Check-out: ${rm.checkOutDate.isNotEmpty ? rm.checkOutDate.split('T').first : ''}',
          'fare': fareStr,
          'cancelReason': rm.status == 'cancelled' ? 'CANCELLED' : null,
          'actionLabel': 'Book Again',
          'actionIcon': Icons.replay,
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

  List<Map<String, dynamic>> _getCurrentTabList() {
    if (_activeTab == 0) return _liveActive;
    if (_activeTab == 1) return _livePast;
    return _liveCancelled;
  }

  final List<Map<String, dynamic>> _filterCategories = const [
    {'type': 'all', 'label': 'All Bookings', 'icon': null},
    {'type': 'ride', 'label': 'Rides & VIP Transit', 'icon': Icons.directions_car_outlined},
    {'type': 'food', 'label': 'Dining & Food', 'icon': Icons.restaurant_outlined},
    {'type': 'courier', 'label': 'Courier & Logistics', 'icon': Icons.shield_outlined},
    {'type': 'rental', 'label': 'Fleet Rentals', 'icon': Icons.vpn_key_outlined},
    {'type': 'property', 'label': 'Villas & Stays', 'icon': Icons.hotel_outlined},
  ];

  List<Map<String, dynamic>> _getFilteredList() {
    final list = _getCurrentTabList();
    if (_selectedFilter <= 0 || _selectedFilter >= _filterCategories.length) return list;
    final targetType = _filterCategories[_selectedFilter]['type'] as String;
    return list.where((item) => item['type'] == targetType).toList();
  }

  void _onCardTapped(Map<String, dynamic> item) {
    final type = item['type'] as String? ?? '';
    final model = item['model'];
    final status = (item['rawStatus'] as String? ?? item['status'] as String? ?? '').toLowerCase();

    if (type == 'ride') {
      if (status == 'matching' || status == 'requested') {
        Navigator.pushNamed(context, '/customer/ride/waiting', arguments: model);
      } else if (status == 'accepted') {
        Navigator.pushNamed(context, '/customer/ride/driver-accepted', arguments: model);
      } else if (status == 'in_progress' || status == 'arrived') {
        Navigator.pushNamed(context, '/customer/ride/active', arguments: model);
      } else if (status == 'completed') {
        Navigator.pushNamed(context, '/customer/ride/completed', arguments: model);
      } else {
        Navigator.pushNamed(context, '/customer/ride/booking');
      }
    } else if (type == 'food') {
      Navigator.pushNamed(context, '/customer/food/order-status', arguments: model);
    } else if (type == 'courier') {
      Navigator.pushNamed(context, '/customer/courier/status', arguments: model);
    } else if (type == 'rental') {
      Navigator.pushNamed(context, '/customer/car-rental/active', arguments: model);
    } else if (type == 'property') {
      Navigator.pushNamed(context, '/customer/properties/search');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTabList = _getCurrentTabList();
    final filteredList = _getFilteredList();

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
                    ? 'Active concierge itineraries, VIP dispatches, and real-time transit.'
                    : _activeTab == 1
                        ? 'Archived luxury transit, maritime deliveries, and settled concierge ledgers.'
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
                _buildSegment(0, 'Active', '${_liveActive.length}'),
                _buildSegment(1, 'Past', '${_livePast.length}'),
                _buildSegment(2, 'Cancelled', '${_liveCancelled.length}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Sub-filters (all 5 services with live counts)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: List.generate(_filterCategories.length, (idx) {
              final cat = _filterCategories[idx];
              final type = cat['type'] as String;
              final int count = type == 'all'
                  ? currentTabList.length
                  : currentTabList.where((x) => x['type'] == type).length;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildFilterChip(
                  idx,
                  cat['label'] as String,
                  icon: cat['icon'] as IconData?,
                  count: count,
                ),
              );
            }),
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
                  child: filteredList.isEmpty
                      ? Center(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: AppColors.cyanPill,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.history_outlined, size: 32, color: AppColors.primaryTeal),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No ${_activeTab == 0 ? "Active" : _activeTab == 1 ? "Past" : "Cancelled"} Itineraries',
                                  style: AppTextStyles.headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your verified concierge bookings and live itineraries will appear here in real time.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: filteredList.length,
                          itemBuilder: (c, i) {
                            final item = filteredList[i];
                            if (_activeTab == 0) {
                              return ActiveHistoryCard(data: item, onTap: () => _onCardTapped(item));
                            } else if (_activeTab == 1) {
                              return GestureDetector(onTap: () => _onCardTapped(item), child: PastHistoryCard(data: item));
                            } else {
                              return GestureDetector(onTap: () => _onCardTapped(item), child: CancelledHistoryCard(data: item));
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
