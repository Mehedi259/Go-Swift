import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/services/car_rental_service.dart';

class RentalEarningsScreen extends StatefulWidget {
  const RentalEarningsScreen({super.key});

  @override
  State<RentalEarningsScreen> createState() => _RentalEarningsScreenState();
}

class _RentalEarningsScreenState extends State<RentalEarningsScreen> {
  final CarRentalService _rentalService = CarRentalService();
  bool _isLoading = true;
  String _totalMonthly = '\$0.00';
  String _activeRentals = '0';
  String _confirmedCount = '0';
  List<CarRentalBookingModel> _liveBookings = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _rentalService.getProviderStats().catchError((_) => <String, dynamic>{}),
        _rentalService.getFleetBookings().catchError((_) => <CarRentalBookingModel>[]),
      ]);

      if (mounted) {
        final s = results[0] as Map<String, dynamic>;
        final bookings = results[1] as List<CarRentalBookingModel>;

        setState(() {
          _liveBookings = bookings;
          _isLoading = false;

          if (s['confirmed_bookings'] != null) {
            _activeRentals = '${s['confirmed_bookings']}';
          }
          if (s['completed_bookings'] != null) {
            _confirmedCount = '${s['completed_bookings']}';
          }

          if (bookings.isNotEmpty) {
            double total = 0.0;
            int active = 0;
            int completed = 0;
            for (final b in bookings) {
              final st = b.status.toLowerCase();
              if (st != 'cancelled') {
                total += b.totalPrice;
              }
              if (st.contains('confirm') || st.contains('active')) {
                active++;
              }
              if (st.contains('complete')) {
                completed++;
              }
            }
            _totalMonthly = '\$${total.toStringAsFixed(2)}';
            if (active > 0) _activeRentals = '$active';
            if (completed > 0) _confirmedCount = '$completed';
          } else {
            _totalMonthly = '\$0.00';
            _activeRentals = '0';
            _confirmedCount = '0';
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
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
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Text('Fleet Revenue', style: AppTextStyles.titleLarge),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryTeal),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
          : RefreshIndicator(
              color: AppColors.primaryTeal,
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero revenue card
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('FLEET REVENUE', style: AppTextStyles.caption.copyWith(letterSpacing: 1.2)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.goldLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text('BAHAMAS DISPATCH', style: AppTextStyles.goldLabel),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _totalMonthly,
                            style: AppTextStyles.price.copyWith(fontSize: 42, color: AppColors.gold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Net payout deposited directly to Bahamas bank account',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(color: AppColors.border, height: 1),
                          ),
                          Row(
                            children: [
                              Expanded(child: _subStat('ACTIVE RENTALS', _activeRentals)),
                              Expanded(child: _subStat('COMPLETED', _confirmedCount)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Fleet Performance', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    _breakdownRow('Rental Daily Base Fees', _totalMonthly),
                    _breakdownRow('Concierge Fleet Handover Fees', '\$0.00'),
                    _breakdownRow('Insurance Reimbursements', 'Included'),
                    const SizedBox(height: 24),
                    Text('Rental Payouts & Bookings', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    if (_liveBookings.isNotEmpty)
                      ..._liveBookings.map((b) => Container(
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
                                  child: const Icon(Icons.directions_car, color: AppColors.cyan, size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(b.vehicleName ?? 'Luxury Fleet Vehicle', style: AppTextStyles.titleMedium),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${b.customerName} • ${b.startDate.split("T").first} – ${b.endDate.split("T").first}',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${b.totalPrice.toStringAsFixed(2)}',
                                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ))
                    else
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(Icons.receipt_long_outlined, size: 36, color: AppColors.textSecondary),
                              const SizedBox(height: 8),
                              Text('No Rental Payouts Recorded Yet', style: AppTextStyles.titleMedium),
                              const SizedBox(height: 4),
                              Text('Confirmed rental bookings will stream into your fleet ledger here.', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
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

  Widget _subStat(String l, String v) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l, style: AppTextStyles.caption.copyWith(letterSpacing: 1)),
          const SizedBox(height: 2),
          Text(v, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        ],
      );

  Widget _breakdownRow(String l, String v) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l, style: AppTextStyles.bodyMedium),
            Text(v, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          ],
        ),
      );
}
