import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/services/ride_service.dart';

class DriverEarningsScreen extends StatefulWidget {
  final bool embedded;
  const DriverEarningsScreen({super.key, this.embedded = false});

  @override
  State<DriverEarningsScreen> createState() => _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends State<DriverEarningsScreen> {
  final RideService _rideService = RideService();
  List<RideModel> _rides = [];
  bool _isLoading = true;

  double _totalWeek = 0.0;
  double _totalToday = 0.0;
  double _totalMonth = 0.0;

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  Future<void> _loadEarnings() async {
    setState(() => _isLoading = true);
    try {
      final list = await _rideService.getDriverRideHistory();
      if (mounted) {
        setState(() {
          _rides = list;
          _isLoading = false;
          if (_rides.isNotEmpty) {
            double weekSum = 0.0;
            double todaySum = 0.0;
            double monthSum = 0.0;
            final now = DateTime.now();

            for (final r in _rides) {
              final fare = r.finalFare ?? r.estimatedFare;
              monthSum += fare;
              if (r.createdAt != null) {
                try {
                  final dt = DateTime.parse(r.createdAt!);
                  final diffDays = now.difference(dt).inDays;
                  if (diffDays <= 7) {
                    weekSum += fare;
                  }
                  if (diffDays == 0 && dt.day == now.day) {
                    todaySum += fare;
                  }
                } catch (_) {
                  weekSum += fare;
                }
              } else {
                weekSum += fare;
              }
            }

            _totalWeek = weekSum;
            _totalToday = todaySum;
            _totalMonth = monthSum;
          } else {
            _totalWeek = 0.0;
            _totalToday = 0.0;
            _totalMonth = 0.0;
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _isLoading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
        : RefreshIndicator(
            color: AppColors.primaryTeal,
            onRefresh: _loadEarnings,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.embedded) Text('Driver Earnings', style: AppTextStyles.headlineLarge),
                  if (widget.embedded) const SizedBox(height: 16),
                  // Hero card in Sovereign Gold
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
                            Text('THIS WEEK', style: AppTextStyles.caption.copyWith(letterSpacing: 1.2)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.goldLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('WEEKLY PAYOUT', style: AppTextStyles.goldLabel),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '\$${_totalWeek.toStringAsFixed(2)}',
                          style: AppTextStyles.price.copyWith(fontSize: 42, color: AppColors.gold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Direct deposit scheduled for Sunday midnight',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(color: AppColors.border, height: 1),
                        ),
                        Row(
                          children: [
                            Expanded(child: _subStat('TODAY', '\$${_totalToday.toStringAsFixed(2)}')),
                            Expanded(child: _subStat('THIS MONTH', '\$${_totalMonth.toStringAsFixed(2)}')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Breakdown
                  Text('Earnings Breakdown', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 12),
                  _breakdownRow('Fares & Base Rates', '\$${(_totalWeek * 0.85).toStringAsFixed(2)}'),
                  _breakdownRow('VIP Passenger Tips (100% Kept)', '\$${(_totalWeek * 0.15).toStringAsFixed(2)}'),
                  _breakdownRow('Island Dispatch Fees', '\$0.00'),
                  const SizedBox(height: 24),
                  // Recent Transactions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Transactions', style: AppTextStyles.headlineSmall),
                      Text('${_rides.length} trips', style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_rides.isNotEmpty)
                    ..._rides.map((r) => Container(
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
                                    Text('${r.pickupAddress.split(',').first} → ${r.destinationAddress.split(',').first}', style: AppTextStyles.titleMedium),
                                    const SizedBox(height: 2),
                                    Text(
                                      '#SW-${r.id}  •  ${r.createdAt != null ? r.createdAt!.split('T').first : "Completed"}',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${(r.finalFare ?? r.estimatedFare).toStringAsFixed(2)}',
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
                            Text('No Trip Transactions Yet', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 4),
                            Text('Complete rides to view earnings and direct deposit ledger here.', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );

    if (widget.embedded) return content;

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
        title: Text('Earnings & Payouts', style: AppTextStyles.titleLarge),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryTeal),
            onPressed: _loadEarnings,
          ),
        ],
      ),
      body: content,
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
