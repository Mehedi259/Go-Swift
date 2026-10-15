import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/services/car_rental_service.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class RentalBookingManagementScreen extends StatefulWidget {
  final bool embedded;
  const RentalBookingManagementScreen({super.key, this.embedded = false});

  @override
  State<RentalBookingManagementScreen> createState() => _RentalBookingManagementScreenState();
}

class _RentalBookingManagementScreenState extends State<RentalBookingManagementScreen> {
  final CarRentalService _rentalService = CarRentalService();
  List<CarRentalBookingModel> _liveBookings = [];
  bool _isLoading = true;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchBookings(silent: true));
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchBookings({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: !widget.embedded,
        leading: widget.embedded
            ? null
            : GestureDetector(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryTeal),
            onPressed: () => _fetchBookings(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
          : RefreshIndicator(
              color: AppColors.primaryTeal,
              onRefresh: () => _fetchBookings(),
              child: _liveBookings.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: _liveBookings.length,
                      itemBuilder: (context, i) {
                        final b = _liveBookings[i];
                        final id = b.bookingNumber ?? '#CR-${b.id}';
                        final renter = b.customerName;
                        final vehicle = b.vehicleName ?? 'Luxury Fleet Vehicle';
                        final dates = '${b.startDate.split('T').first} – ${b.endDate.split('T').first}';
                        final total = '\$${b.totalPrice.toStringAsFixed(2)}';
                        final status = b.status.toUpperCase();
                        final color = status.contains('CONFIRMED') || status.contains('ACTIVE')
                            ? AppColors.green
                            : status.contains('CANCELLED')
                                ? AppColors.red
                                : AppColors.cyan;

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
                              Text(renter, style: AppTextStyles.headlineSmall),
                              const SizedBox(height: 4),
                              Text(vehicle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.cyan),
                                  const SizedBox(width: 6),
                                  Text(dates, style: AppTextStyles.bodySmall),
                                  const Spacer(),
                                  Text(
                                    total,
                                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              if (status == 'PENDING' || status == 'REQUESTED') ...[
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(color: AppColors.border, height: 1),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GSButton(
                                        label: 'Decline',
                                        isSecondary: true,
                                        onTap: () => _decline(b.id),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: GSButton(
                                        label: 'Confirm →',
                                        onTap: () => _confirm(b.id),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.directions_car_outlined, size: 38, color: AppColors.primaryTeal),
            ),
            const SizedBox(height: 20),
            Text('No Rental Bookings Found', style: AppTextStyles.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Customer vehicle bookings and concierge requests will appear here. Pull down to refresh.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GSButton(
              label: 'Refresh Bookings',
              isSecondary: true,
              onTap: () => _fetchBookings(),
            ),
          ],
        ),
      ),
    );
  }
}
