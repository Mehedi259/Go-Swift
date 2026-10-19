import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final RentalVehicleModel? vehicle;
  const VehicleDetailsScreen({super.key, this.vehicle});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 5));
  bool _isFavorite = false;
  bool _isTogglingFav = false;

  int get _rentalDays {
    final diff = _endDate.difference(_startDate).inDays;
    return diff > 0 ? diff : 1;
  }

  String _formatDisplayDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  Future<void> _selectRentalDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
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
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _toggleFavorite(int vehicleId) async {
    if (_isTogglingFav) return;
    setState(() {
      _isTogglingFav = true;
      _isFavorite = !_isFavorite;
    });
    try {
      await AuthService().toggleFavorite(
        serviceType: 'car_rentals',
        objectId: vehicleId,
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
    final RentalVehicleModel? vehicle = widget.vehicle ?? (args is RentalVehicleModel ? args : null);
    final Map<String, dynamic>? carMap = args is Map<String, dynamic> ? args : null;

    final vehicleName = vehicle?.name ?? carMap?['name'] as String? ?? 'Cadillac Escalade ESV';
    final category = (vehicle?.category ?? carMap?['type'] as String? ?? 'luxury_suv').replaceAll('_', ' ').toUpperCase();
    final dailyRate = vehicle?.dailyRate ?? (carMap != null ? (double.tryParse((carMap['price'] as String? ?? '').replaceAll(RegExp(r'[^0-9.]'), '')) ?? 285.0) : 285.0);
    final rating = vehicle?.rating ?? 4.97;
    final seats = vehicle?.seatingCapacity ?? carMap?['seats'] as int? ?? 6;
    final bags = vehicle?.luggageCapacity ?? carMap?['bags'] as int? ?? 4;
    final transmission = vehicle?.transmission ?? 'Automatic';
    final fuel = vehicle?.fuelType ?? 'Petrol';
    final vehicleDesc = vehicle?.description ??
        'Premium luxury SUV perfect for Nassau Island tours, airport transfers, and resort-to-resort travel. Features extended wheelbase, panoramic sunroof, and premium sound system.';
    final location = vehicle?.location ?? 'Cable Beach Fleet Hub, Nassau';

    final imageUrl = vehicle?.displayImageUrl ??
        carMap?['image'] as String? ??
        getCarRentalFallbackImage(
          name: vehicleName,
          category: category,
          seed: vehicle?.id ?? carMap?['id'] as int?,
        );

    final totalCost = dailyRate * _rentalDays;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 220,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE8F4F8), Color(0xFFD6EDF4)],
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.directions_car,
                          color: AppColors.primaryTeal.withValues(alpha: 0.4),
                          size: 72,
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Icon(
                        Icons.directions_car,
                        color: AppColors.primaryTeal.withValues(alpha: 0.4),
                        size: 72,
                      ),
                    ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.35),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.15),
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
                      onTap: () => _toggleFavorite(vehicle?.id ?? 1),
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
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.badgeTeal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: AppTextStyles.cyanLabel.copyWith(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(vehicleName, style: AppTextStyles.headlineLarge),
                        ),
                        GSRatingRow(rating: rating, reviews: 142),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehicle?.make ?? "Luxury"} ${vehicle?.model ?? "Fleet"} • $transmission • $fuel',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '\$${dailyRate.toStringAsFixed(0)}/day',
                      style: AppTextStyles.price.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 16),
                    // Features
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        '$seats Seats',
                        '$bags Bags',
                        transmission,
                        fuel,
                        'Full Insurance Included',
                        'Concierge Delivery',
                        '24/7 Island Support',
                      ].map((f) => Container(
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
                            Text(
                              f,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text('Location & Pickup', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppColors.primaryTeal, size: 16),
                        const SizedBox(width: 6),
                        Expanded(child: Text(location, style: AppTextStyles.bodyMedium)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('About This Vehicle', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 8),
                    Text(vehicleDesc, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 20),
                    // Rental duration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Rental Duration', style: AppTextStyles.headlineSmall),
                        GestureDetector(
                          onTap: _selectRentalDates,
                          child: Text(
                            'Edit Dates',
                            style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _selectRentalDates,
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
                                  Text('Pick-up', style: AppTextStyles.bodySmall),
                                  const SizedBox(height: 4),
                                  Text(_formatDisplayDate(_startDate), style: AppTextStyles.titleMedium),
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
                                  Text('Return', style: AppTextStyles.bodySmall),
                                  const SizedBox(height: 4),
                                  Text(_formatDisplayDate(_endDate), style: AppTextStyles.titleMedium),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Summary
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
                          _row('$_rentalDays days × \$${dailyRate.toStringAsFixed(0)}/day', '\$${totalCost.toStringAsFixed(2)}'),
                          _row('Insurance & Protection', 'Included'),
                          _row('Concierge Fleet Delivery', '\$0.00'),
                          const Divider(color: AppColors.border, height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('TOTAL', style: AppTextStyles.headlineSmall),
                              Text('\$${totalCost.toStringAsFixed(2)}', style: AppTextStyles.price.copyWith(fontSize: 22)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    GSButton(
                      label: 'Reserve Vehicle →',
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/customer/car-rental/booking',
                        arguments: vehicle,
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

  Widget _row(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: AppTextStyles.bodyMedium),
        Text(v, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary)),
      ],
    ),
  );
}
