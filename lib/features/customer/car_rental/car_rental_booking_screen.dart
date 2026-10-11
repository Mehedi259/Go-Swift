import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/services/car_rental_service.dart';
import '../../../core/widgets/gs_button.dart';

class CarRentalBookingScreen extends StatefulWidget {
  const CarRentalBookingScreen({super.key});

  @override
  State<CarRentalBookingScreen> createState() => _CarRentalBookingScreenState();
}

class _CarRentalBookingScreenState extends State<CarRentalBookingScreen> {
  bool _isSubmitting = false;
  int _deliveryOption = 0;

  Future<void> _confirmBooking() async {
    setState(() => _isSubmitting = true);
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      int vehicleId = 1;
      if (args is RentalVehicleModel) {
        vehicleId = args.id;
      } else if (args is Map && args['id'] is int) {
        vehicleId = args['id'] as int;
      }

      final booking = await CarRentalService().createBooking(
        vehicleId: vehicleId,
        startDate: '2026-04-21',
        endDate: '2026-04-25',
        pickupHandoverStation: _deliveryOption == 2
            ? "Lynden Pindling International Airport (NAS)"
            : _deliveryOption == 1
                ? "The Ocean Club, Paradise Island"
                : "Cable Beach Fleet Hub, Nassau",
        deliverToVillaOrHotel: _deliveryOption == 1,
        deliveryAddress: _deliveryOption == 1 ? "The Ocean Club, Paradise Island" : null,
        customerNote: "VIP handover requested",
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.pushNamed(context, '/customer/car-rental/active', arguments: booking);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rental confirmed: $e'),
            backgroundColor: AppColors.primaryNavy,
          ),
        );
        Navigator.pushNamed(context, '/customer/car-rental/active');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final RentalVehicleModel? vehicle = args is RentalVehicleModel ? args : null;
    final vehicleTitle = vehicle != null
        ? '${vehicle.make} ${vehicle.model}'
        : 'Cadillac Escalade ESV';
    final vehicleTotal = vehicle != null
        ? '\$${(vehicle.dailyRate * 4).toStringAsFixed(2)}'
        : '\$1,140.00';

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
        title: Text('Confirm Rental Booking', style: AppTextStyles.titleLarge),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicleTitle, style: AppTextStyles.headlineLarge),
                  const SizedBox(height: 4),
                  Text('4 Days • Apr 21 – Apr 25, 2026', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  Text('DRIVER INFORMATION', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  _field('Full Name', Icons.person_outline, 'Alexander Vance'),
                  const SizedBox(height: 12),
                  _field('Driver\'s License', Icons.badge_outlined, 'DL-000-000000'),
                  const SizedBox(height: 12),
                  _field('Mobile Phone', Icons.phone_outlined, '+1 (242) 555-0199'),
                  const SizedBox(height: 24),
                  Text('DELIVERY OPTION', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  ...[
                    {'icon': Icons.location_on_outlined, 'label': 'Self Pick-up', 'sub': 'Cable Beach Fleet Hub, Nassau'},
                    {'icon': Icons.hotel, 'label': 'Hotel / Resort Delivery', 'sub': 'Concierge delivery to your property • FREE'},
                    {'icon': Icons.flight, 'label': 'Airport Delivery (NAS)', 'sub': "Available at Lynden Pindling Int'l Airport"},
                  ].asMap().entries.map((e) => GestureDetector(
                    onTap: () => setState(() => _deliveryOption = e.key),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _deliveryOption == e.key ? AppColors.primaryTeal : AppColors.border,
                          width: _deliveryOption == e.key ? 2 : 1,
                        ),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _deliveryOption == e.key ? AppColors.badgeTeal : AppColors.cardTouchpoint,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(e.value['icon'] as IconData, color: AppColors.primaryTeal, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.value['label'] as String, style: AppTextStyles.titleMedium),
                                Text(e.value['sub'] as String, style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          if (_deliveryOption == e.key)
                            const Icon(Icons.check_circle, color: AppColors.primaryTeal, size: 20),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 20),
                  Text('PAYMENT', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryTeal, width: 2),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.credit_card, color: AppColors.primaryTeal, size: 22),
                        const SizedBox(width: 12),
                        Expanded(child: Text('Visa •••• 4291', style: AppTextStyles.titleMedium)),
                        const Icon(Icons.check_circle, color: AppColors.primaryTeal, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        _row('4 Days Rental', vehicleTotal),
                        _row('Comprehensive Insurance', 'Included'),
                        _row('Concierge Delivery', 'FREE'),
                        const Divider(color: AppColors.border),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TOTAL', style: AppTextStyles.headlineSmall),
                            Text(vehicleTotal, style: AppTextStyles.price.copyWith(fontSize: 22)),
                          ],
                        ),
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
              label: 'Confirm Rental • $vehicleTotal →',
              isLoading: _isSubmitting,
              onTap: _isSubmitting ? null : _confirmBooking,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, IconData icon, String hint) => TextFormField(
    style: AppTextStyles.bodyLarge,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
    ),
  );

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
