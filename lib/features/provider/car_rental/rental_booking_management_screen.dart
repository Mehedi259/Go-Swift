import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/services/car_rental_service.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class RentalBookingManagementScreen extends StatefulWidget {
  const RentalBookingManagementScreen({super.key});

  @override
  State<RentalBookingManagementScreen> createState() => _RentalBookingManagementScreenState();
}

class _RentalBookingManagementScreenState extends State<RentalBookingManagementScreen> {
  final CarRentalService _rentalService = CarRentalService();
  List<CarRentalBookingModel> _liveBookings = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _fallbackBookings = [
    {'id': '#CR-5821', 'renter': 'Alexander Vance', 'vehicle': 'Cadillac Escalade ESV', 'dates': 'Apr 21 – Apr 25', 'total': '\$1,140.00', 'status': 'Active', 'color': AppColors.green},
    {'id': '#CR-5800', 'renter': 'Victoria Stubbs', 'vehicle': 'Range Rover Sport', 'dates': 'Apr 28 – May 2', 'total': '\$980.00', 'status': 'Upcoming', 'color': AppColors.cyan},
    {'id': '#CR-5756', 'renter': 'Marcus Thompson', 'vehicle': 'Cadillac Escalade ESV', 'dates': 'Apr 10 – Apr 14', 'total': '\$1,140.00', 'status': 'Completed', 'color': AppColors.textSecondary},
  ];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final list = await _rentalService.getFleetBookings();
      if (mounted) {
        setState(() {
          _liveBookings = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirm(int id) async {
    try {
      await _rentalService.confirmBooking(id);
      _fetchBookings();
    } catch (_) {}
  }

  Future<void> _decline(int id) async {
    try {
      await _rentalService.declineBooking(id);
      _fetchBookings();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final useLive = _liveBookings.isNotEmpty;
    final count = useLive ? _liveBookings.length : _fallbackBookings.length;

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
        title: Text('Booking Management', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: count,
              itemBuilder: (context, i) {
                final String id;
                final String renter;
                final String vehicle;
                final String dates;
                final String total;
                final String status;
                final Color color;
                int? bookingId;

                if (useLive) {
                  final b = _liveBookings[i];
                  bookingId = b.id;
                  id = '#CR-${b.id}';
                  renter = b.customerName;
                  vehicle = b.vehicleName ?? 'Luxury Fleet Vehicle';
                  dates = '${b.startDate.split('T').first} – ${b.endDate.split('T').first}';
                  total = '\$${b.totalPrice}';
                  status = b.status.toUpperCase();
                  color = status.contains('CONFIRMED') || status.contains('ACTIVE') ? AppColors.green : AppColors.cyan;
                } else {
                  final b = _fallbackBookings[i];
                  id = b['id'] as String;
                  renter = b['renter'] as String;
                  vehicle = b['vehicle'] as String;
                  dates = b['dates'] as String;
                  total = b['total'] as String;
                  status = b['status'] as String;
                  color = b['color'] as Color;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(id, style: AppTextStyles.cyanLabel),
                          GSStatusBadge(label: status, color: color),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 16, color: AppColors.cyan),
                          const SizedBox(width: 8),
                          Text(renter, style: AppTextStyles.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.directions_car, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(vehicle, style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(dates, style: AppTextStyles.bodySmall),
                          const Spacer(),
                          Text(
                            total,
                            style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (status.contains('REQUESTED') || status.contains('NEW'))
                        Row(
                          children: [
                            Expanded(
                              child: GSButton(
                                label: 'Decline',
                                isSecondary: true,
                                onTap: () => bookingId != null ? _decline(bookingId) : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: GSButton(
                                label: 'Confirm Booking →',
                                onTap: () => bookingId != null ? _confirm(bookingId) : null,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        GSButton(
                          label: 'Manage Active Rental →',
                          onTap: () => Navigator.pushNamed(context, '/provider/rental/active'),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
