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

  double _totalWeek = 1284.50;
  double _totalToday = 284.00;
  double _totalMonth = 4820.00;

  final List<Map<String, String>> _fallbackTransactions = [
    {'id': '#SW-8521', 'from': 'NAS Airport', 'to': 'Ocean Club', 'fare': '\$118.50', 'date': 'Today 4:18 PM'},
    {'id': '#SW-8498', 'from': 'Atlantis', 'to': 'Cable Beach', 'fare': '\$65.00', 'date': 'Today 2:00 PM'},
    {'id': '#SW-8471', 'from': 'Baha Mar', 'to': 'NAS Airport', 'fare': '\$98.00', 'date': 'Yesterday 9:00 AM'},
    {'id': '#SW-8450', 'from': 'Lyford Cay', 'to': 'Paradise Island', 'fare': '\$145.00', 'date': 'Apr 19, 3:00 PM'},
  ];

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  Future<void> _loadEarnings() async {
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
            if (weekSum > 0) _totalWeek = weekSum;
            if (todaySum > 0) _totalToday = todaySum;
            if (monthSum > 0) _totalMonth = monthSum;
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final useLive = _rides.isNotEmpty;

    final content = _isLoading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
        : RefreshIndicator(
            onRefresh: _loadEarnings,
            color: AppColors.cyan,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.embedded) ...[
                    Text('Earnings', style: AppTextStyles.headlineLarge),
                    const SizedBox(height: 16),
                  ],
                  // Hero Stats Card in Sovereign Light Theme
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Total Earnings This Week', style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 6),
                        Text(
                          '\$${_totalWeek.toStringAsFixed(2)}',
                          style: AppTextStyles.price.copyWith(color: AppColors.gold, fontSize: 36),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _eBox('Today', '\$${_totalToday.toStringAsFixed(2)}', AppColors.cyan)),
                            const SizedBox(width: 12),
                            Expanded(child: _eBox('This Month', '\$${_totalMonth.toStringAsFixed(2)}', AppColors.gold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Transaction History', style: AppTextStyles.headlineSmall),
                      if (useLive)
                        Text('${_rides.length} trips', style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (useLive)
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
                                    Text(
                                      '${r.pickupAddress.split(',').first} → ${r.destinationAddress.split(',').first}',
                                      style: AppTextStyles.titleMedium,
                                    ),
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
                    ..._fallbackTransactions.map((t) => Container(
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
                                    Text('${t['from']} → ${t['to']}', style: AppTextStyles.titleMedium),
                                    const SizedBox(height: 2),
                                    Text('${t['id']}  •  ${t['date']}', style: AppTextStyles.bodySmall),
                                  ],
                                ),
                              ),
                              Text(
                                t['fare']!,
                                style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          );

    return widget.embedded
        ? content
        : Scaffold(
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
              title: Text('Earnings', style: AppTextStyles.titleLarge),
              centerTitle: false,
            ),
            body: content,
          );
  }

  Widget _eBox(String l, String v, Color color) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l, style: AppTextStyles.bodySmall),
            const SizedBox(height: 4),
            Text(v, style: AppTextStyles.headlineSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      );
}
