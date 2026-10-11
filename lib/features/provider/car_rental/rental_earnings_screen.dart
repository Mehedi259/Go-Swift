import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/car_rental_service.dart';

class RentalEarningsScreen extends StatefulWidget {
  const RentalEarningsScreen({super.key});

  @override
  State<RentalEarningsScreen> createState() => _RentalEarningsScreenState();
}

class _RentalEarningsScreenState extends State<RentalEarningsScreen> {
  final CarRentalService _rentalService = CarRentalService();
  String _totalMonthly = '\$4,200.00';
  String _activeRentals = '1';
  String _confirmedCount = '2';

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final s = await _rentalService.getProviderStats();
      if (mounted && s.isNotEmpty) {
        setState(() {
          if (s['confirmed_bookings'] != null) {
            _activeRentals = '${s['confirmed_bookings']}';
          }
          if (s['completed_bookings'] != null) {
            _confirmedCount = '${s['completed_bookings']}';
          }
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Fleet Earnings', style: AppTextStyles.titleLarge),
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
      body: SingleChildScrollView(
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
                children: [
                  Text('Total Earnings This Month', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 6),
                  Text(
                    _totalMonthly,
                    style: AppTextStyles.price.copyWith(color: AppColors.gold, fontSize: 36),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _statPill('Active Rentals', _activeRentals, AppColors.green)),
                      const SizedBox(width: 12),
                      Expanded(child: _statPill('Completed', _confirmedCount, AppColors.cyan)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Recent Rental Payouts', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            ...[
              {'vehicle': 'Cadillac Escalade ESV', 'dates': 'Apr 21 – 25', 'payout': '\$1,140.00', 'renter': 'Alexander Vance'},
              {'vehicle': 'Range Rover Sport', 'dates': 'Apr 14 – 18', 'payout': '\$980.00', 'renter': 'Victoria Stubbs'},
              {'vehicle': 'Lamborghini Urus', 'dates': 'Apr 02 – 05', 'payout': '\$2,550.00', 'renter': 'David Sterling'},
            ].map((p) => Container(
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
                            Text(p['vehicle']!, style: AppTextStyles.titleMedium),
                            const SizedBox(height: 2),
                            Text('${p['renter']} • ${p['dates']}', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Text(
                        p['payout']!,
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _statPill(String label, String value, Color color) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.titleLarge.copyWith(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      );
}
