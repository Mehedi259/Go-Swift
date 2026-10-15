import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/property_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final PropertyListingModel? listing;
  const PropertyDetailsScreen({super.key, this.listing});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  DateTime _checkInDate = DateTime.now().add(const Duration(days: 2));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 7));
  bool _isFavorite = false;
  bool _isTogglingFav = false;

  int get _nights {
    final diff = _checkOutDate.difference(_checkInDate).inDays;
    return diff > 0 ? diff : 1;
  }

  String _formatDisplayDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  Future<void> _selectDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _checkInDate, end: _checkOutDate),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked.start;
        _checkOutDate = picked.end;
      });
    }
  }

  Future<void> _toggleFavorite(int propertyId) async {
    if (_isTogglingFav) return;
    setState(() {
      _isTogglingFav = true;
      _isFavorite = !_isFavorite;
    });
    try {
      await AuthService().toggleFavorite(
        serviceType: 'properties',
        objectId: propertyId,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isFavorite ? 'Saved to Favorites' : 'Removed from Favorites'),
            backgroundColor: AppColors.primaryTeal,
            duration: const Duration(milliseconds: 1200),
          ),
        );
      }
    } catch (_) {
      if (mounted) setState(() => _isFavorite = !_isFavorite);
    } finally {
      if (mounted) setState(() => _isTogglingFav = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final mapArgs = args is Map<String, dynamic> ? args : (args is Map ? Map<String, dynamic>.from(args) : null);
    final PropertyListingModel? listing = widget.listing ??
        (args is PropertyListingModel
            ? args
            : (mapArgs?['model'] is PropertyListingModel
                ? mapArgs!['model'] as PropertyListingModel
                : null));

    final title = listing?.title ?? mapArgs?['name']?.toString() ?? 'The Ocean Club Villa';
    final pType = (listing?.propertyType ?? mapArgs?['type']?.toString() ?? 'OCEANFRONT VILLA').replaceAll('_', ' ').toUpperCase();
    final ratePerNight = listing?.pricePerNight ??
        (mapArgs?['price'] != null ? double.tryParse(mapArgs!['price'].toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 1850.0 : 1850.0);
    final pLocation = listing != null ? '${listing.city} • ${listing.address}' : (mapArgs?['location']?.toString() ?? 'Paradise Island • 0.2 miles from beach');
    final pBedrooms = listing?.bedrooms.toString() ?? mapArgs?['beds']?.toString() ?? '4';
    final pBathrooms = listing?.bathrooms.toString() ?? mapArgs?['baths']?.toString() ?? '4';
    final pGuests = listing?.maxGuests.toString() ?? '8';
    final pDesc = listing?.description ??
        'Exquisite oceanfront villa at Paradise Island. Features private infinity pool, direct beach access, dedicated butler service, and panoramic views of the Atlantic Ocean. Fully equipped gourmet kitchen, home cinema, and 24/7 concierge.';
    final double? rating = listing?.rating ?? (mapArgs?['rating'] is num ? (mapArgs!['rating'] as num).toDouble() : null);

    final subtotal = ratePerNight * _nights;
    final taxesAndFees = subtotal * 0.10;
    final totalStay = subtotal + taxesAndFees;

    final String? photoUrl = (listing?.photos.isNotEmpty == true)
        ? listing!.photos.first
        : (mapArgs?['photo'] != null && mapArgs!['photo'].toString().isNotEmpty ? mapArgs['photo'].toString() : null);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 240,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE8F4F8), Color(0xFFD6EDF4)],
                ),
              ),
              child: Stack(
                children: [
                  if (photoUrl != null && photoUrl.isNotEmpty)
                    Positioned.fill(
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(Icons.villa, color: AppColors.primaryTeal.withValues(alpha: 0.4), size: 72),
                        ),
                      ),
                    )
                  else
                    Center(child: Icon(Icons.villa, color: AppColors.primaryTeal.withValues(alpha: 0.4), size: 72)),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.35),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.45),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: GestureDetector(
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
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => _toggleFavorite(listing?.id ?? 1),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? AppColors.gold : AppColors.primaryTeal,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.badgeGold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(pType, style: AppTextStyles.labelSmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: rating != null
                          ? GSRatingRow(rating: rating, reviews: 0)
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: AppColors.gold, size: 14),
                                SizedBox(width: 4),
                                Text('New Listing', style: TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.headlineLarge),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(child: Text(pLocation, style: AppTextStyles.bodySmall)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${ratePerNight.toStringAsFixed(0)}/night', style: AppTextStyles.price.copyWith(fontSize: 24)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFE8F7ED), borderRadius: BorderRadius.circular(8)),
                          child: Text('AVAILABLE NOW', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Key facts
                    Row(
                      children: [
                        Expanded(child: _fact(Icons.king_bed_outlined, '$pBedrooms Beds', 'Master suites')),
                        const SizedBox(width: 10),
                        Expanded(child: _fact(Icons.bathtub_outlined, '$pBathrooms Baths', 'Spa ensuites')),
                        const SizedBox(width: 10),
                        Expanded(child: _fact(Icons.people_outline, '$pGuests Guests', 'Max occupancy')),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('About This Estate', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 8),
                    Text(pDesc, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 20),
                    Text('Amenities & Privileges', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Private Pool', 'Ocean View', 'Butler Service', 'Private Beach', 'Home Cinema', 'Chef Kitchen', 'Yacht Access', 'Gym & Spa', 'Golf Cart'].map((a) => _amenity(a)).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text('Included Services', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    ...[
                      {'icon': Icons.cleaning_services_outlined, 'l': 'Daily Housekeeping', 's': 'Professional housekeeping twice daily'},
                      {'icon': Icons.room_service_outlined, 'l': 'Butler Service', 's': '24/7 personal butler included'},
                      {'icon': Icons.local_parking, 'l': 'Private Parking', 's': 'Secure on-site parking for 4 vehicles'},
                    ].map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: AppColors.cardTouchpoint, borderRadius: BorderRadius.circular(10)),
                              child: Icon(s['icon'] as IconData, color: AppColors.primaryTeal, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s['l'] as String, style: AppTextStyles.titleMedium),
                                Text(s['s'] as String, style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Stay Dates', style: AppTextStyles.headlineSmall),
                        GestureDetector(
                          onTap: _selectDates,
                          child: Text(
                            'Edit Dates',
                            style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _selectDates,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                                boxShadow: AppColors.cardShadow,
                              ),
                              child: Column(
                                children: [
                                  Text('Check In', style: AppTextStyles.bodySmall),
                                  const SizedBox(height: 4),
                                  Text(_formatDisplayDate(_checkInDate), style: AppTextStyles.titleMedium),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.arrow_forward, color: AppColors.primaryTeal, size: 20),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                                boxShadow: AppColors.cardShadow,
                              ),
                              child: Column(
                                children: [
                                  Text('Check Out', style: AppTextStyles.bodySmall),
                                  const SizedBox(height: 4),
                                  Text(_formatDisplayDate(_checkOutDate), style: AppTextStyles.titleMedium),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Price estimation
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$_nights nights × \$${ratePerNight.toStringAsFixed(0)}', style: AppTextStyles.bodyMedium),
                              Text('\$${subtotal.toStringAsFixed(2)}', style: AppTextStyles.titleMedium),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('VAT & Resort Fees (10%)', style: AppTextStyles.bodyMedium),
                              Text('\$${taxesAndFees.toStringAsFixed(2)}', style: AppTextStyles.titleMedium),
                            ],
                          ),
                          const Divider(color: AppColors.border, height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ESTIMATED TOTAL', style: AppTextStyles.headlineSmall),
                              Text('\$${totalStay.toStringAsFixed(2)}', style: AppTextStyles.price.copyWith(fontSize: 22)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    GSButton(
                      label: 'Reserve Property →',
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/customer/properties/booking',
                        arguments: listing,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fact(IconData icon, String val, String sub) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.cardShadow,
    ),
    child: Column(
      children: [
        Icon(icon, color: AppColors.primaryTeal, size: 22),
        const SizedBox(height: 6),
        Text(val, style: AppTextStyles.titleMedium),
        Text(sub, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    ),
  );

  Widget _amenity(String a) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.cardShadow,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check, size: 14, color: AppColors.primaryTeal),
        const SizedBox(width: 4),
        Text(a, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
