import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/services/car_rental_service.dart';

class CarRentalSearchScreen extends StatefulWidget {
  const CarRentalSearchScreen({super.key});

  @override
  State<CarRentalSearchScreen> createState() => _CarRentalSearchScreenState();
}

class _CarRentalSearchScreenState extends State<CarRentalSearchScreen> {
  List<RentalVehicleModel> _liveVehicles = [];
  bool _isLoading = false;

  final _cars = const [
    {'name': 'Cadillac Escalade ESV', 'type': 'LUXURY SUV', 'price': '\$285/day', 'badge': 'MOST BOOKED', 'seats': 6, 'bags': 6},
    {'name': 'Range Rover Sport', 'type': 'LUXURY SUV', 'price': '\$245/day', 'badge': 'ISLAND FAVORITE', 'seats': 5, 'bags': 4},
    {'name': 'Lamborghini Urus', 'type': 'EXOTIC SUV', 'price': '\$850/day', 'badge': 'VIP SELECTION', 'seats': 4, 'bags': 3},
    {'name': 'Mercedes S-Class', 'type': 'EXECUTIVE SEDAN', 'price': '\$195/day', 'badge': '', 'seats': 4, 'bags': 3},
    {'name': 'Ferrari 488 Spider', 'type': 'EXOTIC CONVERTIBLE', 'price': '\$1,200/day', 'badge': 'EXOTIC', 'seats': 2, 'bags': 1},
  ];

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    setState(() => _isLoading = true);
    try {
      final vehicles = await CarRentalService().getVehicles();
      if (mounted) {
        setState(() {
          _liveVehicles = vehicles;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _displayCars {
    if (_liveVehicles.isNotEmpty) {
      return _liveVehicles.map((v) => {
        'id': v.id,
        'name': '${v.make ?? ''} ${v.model ?? ''}'.trim().isNotEmpty
            ? '${v.make ?? ''} ${v.model ?? ''}'.trim()
            : v.name,
        'type': v.category.replaceAll('_', ' ').toUpperCase(),
        'price': '\$${v.dailyRate.toStringAsFixed(0)}/day',
        'badge': v.year != null ? v.year.toString() : '',
        'seats': v.seatingCapacity,
        'bags': v.luggageCapacity,
        'image': v.displayImageUrl,
        'model': v,
      }).toList();
    }
    return _cars.map((c) => {
      ...c,
      'image': getCarRentalFallbackImage(
        name: c['name'] as String?,
        category: c['type'] as String?,
      ),
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Row(
          children: [
            Text('GO ', style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w900)),
            Text('SWIFT', style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w900)),
            const SizedBox(width: 8),
            Text('Car Rental', style: AppTextStyles.titleLarge),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.badgeTeal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('PRIVATE FLEET MANAGEMENT', style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Text('Reserve Your Vehicle', style: AppTextStyles.displayMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Pick-up Location',
                          prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primaryTeal, size: 20),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _fetchVehicles,
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.search, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _dateField('Pick-up Date', 'April 21, 2026')),
                    const SizedBox(width: 10),
                    Expanded(child: _dateField('Return Date', 'April 25, 2026')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading && _liveVehicles.isEmpty
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
                : RefreshIndicator(
                    onRefresh: _fetchVehicles,
                    color: AppColors.primaryTeal,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _displayCars.length,
                      itemBuilder: (c, i) => _CarCard(car: _displayCars[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _dateField(String label, String val) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.cardShadow,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(val, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

class _CarCard extends StatelessWidget {
  final Map<String, dynamic> car;
  const _CarCard({required this.car});

  @override
  Widget build(BuildContext context) {
    final imageUrl = car['image'] as String? ??
        (car['model'] is RentalVehicleModel
            ? (car['model'] as RentalVehicleModel).displayImageUrl
            : null) ??
        getCarRentalFallbackImage(
          name: car['name'] as String?,
          category: car['type'] as String?,
          seed: car['id'] as int?,
        );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/customer/car-rental/vehicle',
        arguments: car['model'] ?? car,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Container(
              height: 140,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
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
                        child: Icon(Icons.directions_car, color: AppColors.primaryTeal.withValues(alpha: 0.5), size: 54),
                      ),
                    )
                  else
                    Center(child: Icon(Icons.directions_car, color: AppColors.primaryTeal.withValues(alpha: 0.5), size: 54)),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.25),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if ((car['badge'] as String? ?? '').isNotEmpty)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Text(car['badge'] as String, style: AppTextStyles.labelSmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                      ),
                    ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: const Icon(Icons.favorite_border, color: AppColors.primaryTeal, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(car['name'] as String, style: AppTextStyles.headlineSmall),
                            const SizedBox(height: 2),
                            Text(car['type'] as String, style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal)),
                          ],
                        ),
                      ),
                      Text(car['price'] as String, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.people_outline, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('${car['seats']} seats', style: AppTextStyles.bodySmall),
                      const SizedBox(width: 14),
                      const Icon(Icons.luggage, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('${car['bags']} bags', style: AppTextStyles.bodySmall),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: AppColors.gold),
                      const SizedBox(width: 4),
                      Text('4.97', style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
