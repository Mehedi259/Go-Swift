import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/ride_service.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_app_bar.dart';

class RideBookingScreen extends StatefulWidget {
  const RideBookingScreen({super.key});
  @override State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  int _vehicle = 0;
  final _pickupController = TextEditingController(text: "Lynden Pindling Int'l Airport (NAS)");
  final _destController = TextEditingController(text: "The Ocean Club, Four Seasons");
  
  bool _isLoading = false;
  bool _initialized = false;
  FareEstimateModel? _estimate;

  final _vehicles = [
    {'name': 'Executive SUV', 'type': 'Cadillac Escalade ESV', 'category': 'executive_suv', 'price': '\$85–\$120', 'eta': '4 min', 'icon': Icons.directions_car, 'badge': 'MOST POPULAR'},
    {'name': 'Luxury Sedan', 'type': 'Mercedes-Benz S-Class', 'category': 'luxury_sedan', 'price': '\$65–\$90', 'eta': '6 min', 'icon': Icons.directions_car_outlined, 'badge': ''},
    {'name': 'VIP Sprinter', 'type': 'Mercedes-Benz Sprinter', 'category': 'vip_sprinter', 'price': '\$110–\$160', 'eta': '8 min', 'icon': Icons.airport_shuttle_outlined, 'badge': 'GROUP PREFERRED'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null && user.streetAddress != null && user.streetAddress!.isNotEmpty) {
        _pickupController.text = '${user.streetAddress}${user.city != null ? ", ${user.city}" : ""}';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEstimate();
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destController.dispose();
    super.dispose();
  }

  Future<void> _fetchEstimate() async {
    try {
      final est = await RideService().estimateFare(
        distanceKm: 18.5,
        estimatedDurationMinutes: 25,
        passengerCount: 2,
      );
      if (mounted) setState(() => _estimate = est);
    } catch (_) {}
  }

  Future<void> _handleBookRide() async {
    final pickup = _pickupController.text.trim();
    final dest = _destController.text.trim();
    if (pickup.isEmpty || dest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter pickup and destination'), backgroundColor: AppColors.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final selectedCategory = _vehicles[_vehicle]['category'] as String;
      final ride = await RideService().createRide(
        pickupAddress: pickup,
        pickupLatitude: 25.0389,
        pickupLongitude: -77.4662,
        destinationAddress: dest,
        destinationLatitude: 25.0786,
        destinationLongitude: -77.3072,
        requestedVehicleCategory: selectedCategory,
        requestedPassengerCount: 2,
        distanceKm: 18.5,
        estimatedDurationMinutes: 25,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/customer/ride/waiting', arguments: ride);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking request failed: $e'), backgroundColor: AppColors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estimatedTotal = _estimate != null ? '\$${_estimate!.estimatedFare.toStringAsFixed(2)}' : '\$118.50';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GSAppBar(
        title: 'Book a Ride',
        showLogo: true,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text('LIVE', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pickup
                  Text('PICKUP LOCATION', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _pickupController,
                    style: AppTextStyles.bodyLarge,
                    decoration: InputDecoration(
                      hintText: "Lynden Pindling Int'l Airport (NAS)",
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        child: Container(
                          width: 10, height: 10,
                          decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('DESTINATION', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _destController,
                    style: AppTextStyles.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'The Ocean Club, Four Seasons',
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        child: Container(
                          width: 10, height: 10,
                          decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _quickDestBtn('Paradise Island'),
                      const SizedBox(width: 8),
                      _quickDestBtn('Atlantis Resort'),
                      const SizedBox(width: 8),
                      _quickDestBtn('Baha Mar'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Select Your Vehicle', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 12),
                  ..._vehicles.asMap().entries.map((e) => GestureDetector(
                    onTap: () => setState(() => _vehicle = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _vehicle == e.key ? AppColors.primaryTeal : AppColors.border,
                          width: _vehicle == e.key ? 2 : 1,
                        ),
                        boxShadow: _vehicle == e.key ? AppColors.softShadow : AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _vehicle == e.key ? AppColors.badgeTeal : AppColors.cardTouchpoint,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              e.value['icon'] as IconData,
                              color: _vehicle == e.key ? AppColors.primaryTeal : AppColors.textSecondary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(e.value['name'] as String, style: AppTextStyles.titleLarge),
                                    const SizedBox(width: 8),
                                    if ((e.value['badge'] as String).isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.cyanPill,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          e.value['badge'] as String,
                                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(e.value['type'] as String, style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(e.value['price'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                              Text(e.value['eta'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.green)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 20),
                  Text('Trip Summary', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardTouchpoint,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _summaryRow('Estimated Fare', estimatedTotal),
                        const Divider(color: AppColors.border, height: 16),
                        _summaryRow('Service Fee', '\$8.50'),
                        _summaryRow('Go Swift Concierge', 'Included'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GSButton(
              label: 'Confirm Booking →',
              isLoading: _isLoading,
              onTap: _handleBookRide,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickDestBtn(String label) => GestureDetector(
    onTap: () => setState(() => _destController.text = label),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
    ),
  );

  Widget _summaryRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
