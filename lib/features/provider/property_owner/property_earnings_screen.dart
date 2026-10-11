import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/property_model.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/services/room_service.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class PropertyEarningsScreen extends StatefulWidget {
  const PropertyEarningsScreen({super.key});

  @override
  State<PropertyEarningsScreen> createState() => _PropertyEarningsScreenState();
}

class _PropertyEarningsScreenState extends State<PropertyEarningsScreen> {
  final RoomService _roomService = RoomService();
  bool _isLoading = true;
  Map<String, dynamic> _stats = {};
  List<RoomBookingModel> _bookings = [];
  List<dynamic> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _roomService.getProviderStats().catchError((_) => <String, dynamic>{}),
        _roomService.getProviderBookings().catchError((_) => <RoomBookingModel>[]),
        _roomService.getProviderReviews().catchError((_) => <dynamic>[]),
      ]);
      if (mounted) {
        setState(() {
          _stats = results[0] as Map<String, dynamic>;
          _bookings = results[1] as List<RoomBookingModel>;
          _reviews = results[2] as List<dynamic>;
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
    double totalRevenue = 0.0;
    for (final b in _bookings) {
      if (b.status.toLowerCase() != 'cancelled') {
        totalRevenue += b.totalPrice;
      }
    }

    final totalListings = _stats['total_listings']?.toString() ?? '0';
    final activeListings = _stats['active_listings']?.toString() ?? '0';
    final confirmedBookings = _stats['confirmed_bookings']?.toString() ?? '${_bookings.length}';
    final rating = (_stats['average_rating'] != null) ? '${_stats['average_rating']}' : '4.98';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
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
        title: Text('Property Earnings & Metrics', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.cyan,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Gross Booking Revenue', style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 6),
                          Text(
                            '\$${totalRevenue.toStringAsFixed(2)}',
                            style: AppTextStyles.price.copyWith(color: AppColors.gold, fontSize: 36),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(child: _s(confirmedBookings, 'Bookings', AppColors.cyan)),
                              const SizedBox(width: 8),
                              Expanded(child: _s('$activeListings / $totalListings', 'Active / Total', AppColors.green)),
                              const SizedBox(width: 8),
                              Expanded(child: _s(rating, 'Host Rating ★', AppColors.gold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Booking Revenue Breakdown', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    if (_bookings.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Center(
                          child: Text('No guest bookings recorded yet.', style: AppTextStyles.bodySmall),
                        ),
                      )
                    else
                      ..._bookings.map(
                        (b) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.cardTouchpoint,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.villa_outlined, color: AppColors.cyan, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(b.propertyTitle ?? 'Luxury Property', style: AppTextStyles.titleMedium),
                                    const SizedBox(height: 2),
                                    Text('${b.bookingNumber ?? "#PB-${b.id}"} • ${b.totalNights} nights', style: AppTextStyles.bodySmall),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${b.totalPrice.toStringAsFixed(2)}',
                                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  GSStatusBadge(
                                    label: b.status.toUpperCase(),
                                    color: b.status.toLowerCase() == 'completed' ? AppColors.green : AppColors.gold,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Guest Ratings & Reviews', style: AppTextStyles.headlineSmall),
                        Text('★ $rating (${_reviews.length})', style: AppTextStyles.labelMedium.copyWith(color: AppColors.gold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_reviews.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Center(
                          child: Text('No guest reviews published yet.', style: AppTextStyles.bodySmall),
                        ),
                      )
                    else
                      ..._reviews.map(
                        (r) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    r['customer_name']?.toString() ?? 'VIP Guest',
                                    style: AppTextStyles.titleMedium,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: AppColors.gold, size: 16),
                                      const SizedBox(width: 4),
                                      Text('${r['rating'] ?? 5}', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              if (r['comment'] != null && r['comment'].toString().isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  r['comment'].toString(),
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _s(String v, String l, Color color) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(v, style: AppTextStyles.headlineSmall.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 2),
            Text(l, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      );
}

class PropertyOwnerProfileScreen extends StatefulWidget {
  const PropertyOwnerProfileScreen({super.key});

  @override
  State<PropertyOwnerProfileScreen> createState() => _PropertyOwnerProfileScreenState();
}

class _PropertyOwnerProfileScreenState extends State<PropertyOwnerProfileScreen> {
  final ProviderApplicationService _providerService = ProviderApplicationService();
  final RoomService _roomService = RoomService();

  bool _isLoading = true;
  Map<String, dynamic> _profile = {};
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _providerService.getPropertyProfile().catchError((_) => <String, dynamic>{}),
        _roomService.getProviderStats().catchError((_) => <String, dynamic>{}),
      ]);
      if (mounted) {
        setState(() {
          _profile = results[0];
          _stats = results[1];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _editProfileDialog() async {
    final hostNameCtrl = TextEditingController(text: _profile['host_name']?.toString() ?? _profile['brand_trade_name']?.toString() ?? '');
    final phoneCtrl = TextEditingController(text: _profile['mobile_phone']?.toString() ?? _profile['contact_phone']?.toString() ?? '');
    final emailCtrl = TextEditingController(text: _profile['official_host_email']?.toString() ?? _profile['contact_email']?.toString() ?? '');
    final bankCtrl = TextEditingController(text: _profile['payout_bank_name']?.toString() ?? 'Commonwealth Bank');
    final accountCtrl = TextEditingController(text: _profile['payout_account_number']?.toString() ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Host Profile', style: AppTextStyles.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: hostNameCtrl,
                decoration: const InputDecoration(labelText: 'Host / Legal Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Official Host Email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Mobile Phone'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bankCtrl,
                decoration: const InputDecoration(labelText: 'Payout Bank'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: accountCtrl,
                decoration: const InputDecoration(labelText: 'Payout Account Number'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyan, foregroundColor: Colors.white),
            child: const Text('Save'),
            onPressed: () async {
              try {
                await _providerService.updatePropertyProfile(data: {
                  'host_name': hostNameCtrl.text.trim(),
                  'official_host_email': emailCtrl.text.trim(),
                  'mobile_phone': phoneCtrl.text.trim(),
                  'payout_bank_name': bankCtrl.text.trim(),
                  'payout_account_number': accountCtrl.text.trim(),
                });
                if (ctx.mounted) Navigator.pop(ctx, true);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Error updating: $e')));
                }
              }
            },
          ),
        ],
      ),
    );

    if (saved == true) {
      _loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hostName = _profile['host_name']?.toString() ?? _profile['brand_trade_name']?.toString() ?? 'Bahamian Sovereign Host';
    final location = _profile['primary_property_location']?.toString() ?? _profile['island_group']?.toString() ?? 'Nassau & Paradise Island';
    final email = _profile['official_host_email']?.toString() ?? _profile['contact_email']?.toString() ?? 'host@bahamasovereign.bs';
    final phone = _profile['mobile_phone']?.toString() ?? _profile['contact_phone']?.toString() ?? '+1 (242) 555-7721';
    final bank = _profile['payout_bank_name']?.toString() ?? 'Commonwealth Bank';
    final account = _profile['payout_account_number']?.toString() ?? '•••• 7721';
    final taxId = _profile['taxpayer_identification_number']?.toString() ?? 'TIN-40192-NP';
    final license = _profile['tourism_license_number']?.toString() ?? 'TL-2026-VIP';

    final rating = (_stats['average_rating'] != null) ? '${_stats['average_rating']}' : '4.98';
    final listingsCount = _stats['total_listings']?.toString() ?? '3';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Owner Profile', style: AppTextStyles.titleLarge),
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
          : RefreshIndicator(
              onRefresh: _loadProfile,
              color: AppColors.cyan,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.cyanLight,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.cyan, width: 2),
                            ),
                            child: const Icon(Icons.villa, color: AppColors.cyan, size: 36),
                          ),
                          const SizedBox(height: 12),
                          Text(hostName, style: AppTextStyles.headlineMedium, textAlign: TextAlign.center),
                          const SizedBox(height: 2),
                          Text('Verified Property Host • $location', style: AppTextStyles.cyanLabel, textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, color: AppColors.gold, size: 16),
                              const SizedBox(width: 4),
                              Text('$rating ★ • $listingsCount luxury properties listed', style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _infoTile(Icons.verified_outlined, 'Host Status', 'Superhost • Licensed Vacation Rental'),
                    _infoTile(Icons.account_balance_outlined, 'Payout Account', '$bank • $account'),
                    _infoTile(Icons.email_outlined, 'Official Host Email', email),
                    _infoTile(Icons.phone_outlined, 'Contact Phone', phone),
                    _infoTile(Icons.receipt_long_outlined, 'Tax Registration', taxId),
                    _infoTile(Icons.badge_outlined, 'Tourism License', license),
                    const SizedBox(height: 24),
                    GSButton(label: 'Edit Host Profile', isSecondary: true, onTap: _editProfileDialog),
                    const SizedBox(height: 12),
                    GSButton(
                      label: 'Sign Out',
                      isSecondary: true,
                      onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/choose-account', (_) => false),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _infoTile(IconData icon, String label, String val) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.cyan, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 2),
                  Text(val, style: AppTextStyles.titleMedium),
                ],
              ),
            ),
          ],
        ),
      );
}
