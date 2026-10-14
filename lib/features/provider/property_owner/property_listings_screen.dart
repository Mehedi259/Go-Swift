import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/property_model.dart';
import '../../../core/services/room_service.dart';
import '../../../core/widgets/gs_card.dart';
import 'booking_requests_screen.dart';
import 'property_earnings_screen.dart';

class PropertyListingsScreen extends StatefulWidget {
  const PropertyListingsScreen({super.key});

  @override
  State<PropertyListingsScreen> createState() => _PropertyListingsScreenState();
}

class _PropertyListingsScreenState extends State<PropertyListingsScreen> {
  final RoomService _roomService = RoomService();
  bool _isLoading = true;
  List<PropertyListingModel> _listings = [];
  Map<String, dynamic> _stats = {};
  int _nav = 0;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _roomService.getMyListings(),
        _roomService.getProviderStats().catchError((_) => <String, dynamic>{}),
      ]);
      if (mounted) {
        setState(() {
          _listings = results[0] as List<PropertyListingModel>;
          _stats = results[1] as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    switch (_nav) {
      case 1:
        return AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleSpacing: 4,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cyanLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.calendar_month_outlined, color: AppColors.cyan, size: 20),
          ),
          title: Text('Booking Requests', style: AppTextStyles.titleLarge),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/provider/property/past-bookings'),
              child: Text(
                'History',
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan, fontSize: 14),
              ),
            ),
            const SizedBox(width: 8),
          ],
        );
      case 2:
        return AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleSpacing: 4,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.goldLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.bar_chart_rounded, color: AppColors.gold, size: 20),
          ),
          title: Text('Earnings & Metrics', style: AppTextStyles.titleLarge),
        );
      case 3:
        return AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleSpacing: 4,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.person_outline, color: AppColors.textPrimary, size: 20),
          ),
          title: Text('Host Profile', style: AppTextStyles.titleLarge),
        );
      case 0:
      default:
        return AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleSpacing: 4,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cyanLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.villa_outlined, color: AppColors.cyan, size: 20),
          ),
          title: Text('Properties', style: AppTextStyles.titleLarge),
          actions: [
            IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh, color: AppColors.textSecondary, size: 20),
              onPressed: _loadData,
            ),
            const SizedBox(width: 8),
          ],
        );
    }
  }

  Widget _buildBody(String totalListings, String activeListings, String requestedBookings) {
    switch (_nav) {
      case 1:
        return const BookingRequestsScreen(embedded: true);
      case 2:
        return const PropertyEarningsScreen(embedded: true);
      case 3:
        return const PropertyOwnerProfileScreen(embedded: true);
      case 0:
      default:
        return _buildListingsTab(totalListings, activeListings, requestedBookings);
    }
  }

  Widget _buildListingsTab(String totalListings, String activeListings, String requestedBookings) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.cyan));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.cyan,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(child: _s(totalListings, 'Listed', AppColors.cyan)),
              const SizedBox(width: 10),
              Expanded(child: _s(activeListings, 'Active', AppColors.green)),
              const SizedBox(width: 10),
              Expanded(child: _s(requestedBookings, 'Pending Req', AppColors.gold)),
            ],
          ),
          const SizedBox(height: 20),
          if (_listings.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(Icons.villa_outlined, size: 56, color: AppColors.cyan),
                  const SizedBox(height: 16),
                  Text('No Properties Listed Yet', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Add your luxury villa, beachfront cottage, or private island estate to start receiving bookings.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyan,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Your First Property'),
                    onPressed: () => Navigator.pushNamed(context, '/provider/property/create').then((_) => _loadData()),
                  ),
                ],
              ),
            )
          else
            ..._listings.map((p) {
              final statusLabel = p.isActive ? 'Active' : 'Inactive';
              final statusColor = p.isActive ? AppColors.green : AppColors.gold;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: AppColors.cardTouchpoint,
                        image: p.photos.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(p.photos.first),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: p.photos.isEmpty
                          ? const Center(
                              child: Icon(Icons.villa, color: AppColors.cyan, size: 48),
                            )
                          : null,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.title, style: AppTextStyles.headlineSmall),
                              const SizedBox(height: 2),
                              Text(
                                '${p.islandRegion ?? "Bahamas"} • ${p.bedrooms} Beds • ${p.bathrooms} Baths',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GSStatusBadge(label: statusLabel, color: statusColor),
                            const SizedBox(height: 4),
                            Text(
                              '\$${p.nightlyBaseRate.toStringAsFixed(0)}/night',
                              style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _nav = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Center(
                                child: Text('View Requests', style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pushNamed(context, '/customer/properties/details', arguments: p);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              decoration: BoxDecoration(
                                color: AppColors.cyanLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                              ),
                              child: Center(
                                child: Text(
                                  'Listing Details',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.cyan,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final reqCount = _stats['requested_bookings'] is int
        ? _stats['requested_bookings'] as int
        : int.tryParse('${_stats['requested_bookings'] ?? 0}') ?? 0;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Icons.villa_outlined,
                activeIcon: Icons.villa,
                label: 'Properties',
                index: 0,
              ),
              _navItem(
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month,
                label: 'Bookings',
                index: 1,
                badgeCount: reqCount,
              ),
              _centerAddItem(),
              _navItem(
                icon: Icons.bar_chart_outlined,
                activeIcon: Icons.bar_chart_rounded,
                label: 'Earnings',
                index: 2,
              ),
              _navItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _centerAddItem() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/provider/property/create').then((_) => _loadData()),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.cyan,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyan.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 3),
            Text(
              'Add',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    int? badgeCount,
  }) {
    final active = _nav == index;
    final color = active ? AppColors.cyan : AppColors.textMuted;
    return GestureDetector(
      onTap: () => setState(() => _nav = index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(active ? activeIcon : icon, color: color, size: 24),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalListings = _stats['total_listings']?.toString() ?? '${_listings.length}';
    final activeListings = _stats['active_listings']?.toString() ?? '${_listings.where((l) => l.isActive).length}';
    final requestedBookings = _stats['requested_bookings']?.toString() ?? '0';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_nav != 0) {
          setState(() => _nav = 0);
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
        appBar: _buildAppBar(),
        body: _buildBody(totalListings, activeListings, requestedBookings),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _s(String v, String l, Color color) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Text(v, style: AppTextStyles.headlineSmall.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 2),
            Text(l, style: AppTextStyles.caption),
          ],
        ),
      );
}
