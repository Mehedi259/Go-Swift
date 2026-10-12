import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/property_model.dart';
import '../../../core/services/room_service.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/widgets/gs_card.dart';

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

  @override
  Widget build(BuildContext context) {
    final totalListings = _stats['total_listings']?.toString() ?? '${_listings.length}';
    final activeListings = _stats['active_listings']?.toString() ?? '${_listings.where((l) => l.isActive).length}';
    final requestedBookings = _stats['requested_bookings']?.toString() ?? '0';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () async {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              await LocalStorage.saveActivePortal('customer');
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/customer/hub');
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Text('My Properties', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            tooltip: 'Booking Requests',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.calendar_month_outlined, color: AppColors.cyan),
                if ((_stats['requested_bookings'] ?? 0) > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                      child: Text(
                        '${_stats['requested_bookings']}',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => Navigator.pushNamed(context, '/provider/property/requests').then((_) => _loadData()),
          ),
          IconButton(
            tooltip: 'Earnings & Reviews',
            icon: const Icon(Icons.bar_chart_rounded, color: AppColors.gold),
            onPressed: () => Navigator.pushNamed(context, '/provider/property/earnings'),
          ),
          IconButton(
            tooltip: 'Host Profile',
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.textPrimary),
            onPressed: () => Navigator.pushNamed(context, '/provider/property/owner-profile'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/provider/property/create').then((_) => _loadData()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Add',
                      style: AppTextStyles.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
          : RefreshIndicator(
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
                                    onTap: () => Navigator.pushNamed(context, '/provider/property/requests').then((_) => _loadData()),
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
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Listing #${p.id} status: $statusLabel'),
                                          backgroundColor: AppColors.cyan,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 11),
                                      decoration: BoxDecoration(
                                        color: AppColors.cyanLight,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Listing Details',
                                          style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan, fontSize: 14, fontWeight: FontWeight.bold),
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
