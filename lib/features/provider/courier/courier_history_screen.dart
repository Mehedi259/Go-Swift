import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/courier_model.dart';
import '../../../core/services/courier_service.dart';

class CourierHistoryScreen extends StatefulWidget {
  final bool embedded;
  const CourierHistoryScreen({super.key, this.embedded = false});

  @override
  State<CourierHistoryScreen> createState() => _CourierHistoryScreenState();
}

class _CourierHistoryScreenState extends State<CourierHistoryScreen> {
  final CourierService _courierService = CourierService();
  List<CourierOrderModel> _liveHistory = [];
  bool _isLoading = true;

  final List<Map<String, String>> _fallbackHistory = [
    {'route': 'Graycliff Boutique → Ocean Club', 'id': '#CS-3180', 'date': 'Apr 20, 2:10 PM', 'fee': '\$42.00'},
    {'route': 'Baha Mar Shops → Atlantis', 'id': '#CS-3170', 'date': 'Apr 19, 11:30 AM', 'fee': '\$38.00'},
    {'route': 'Bay St. Legal → Lyford Cay', 'id': '#CS-3160', 'date': 'Apr 18, 4:00 PM', 'fee': '\$65.00'},
    {'route': 'Paradise Island → NAS Airport', 'id': '#CS-3150', 'date': 'Apr 17, 9:00 AM', 'fee': '\$45.00'},
    {'route': 'Downtown Nassau → Cable Beach', 'id': '#CS-3140', 'date': 'Apr 16, 3:20 PM', 'fee': '\$35.00'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final list = await _courierService.getProviderHistory();
      if (mounted) {
        setState(() {
          _liveHistory = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final useLive = _liveHistory.isNotEmpty;
    final count = useLive ? _liveHistory.length : _fallbackHistory.length;

    final content = _isLoading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: count,
            itemBuilder: (c, i) {
              final String route;
              final String id;
              final String date;
              final String fee;

              if (useLive) {
                final item = _liveHistory[i];
                route = '${item.pickupAddress.split(',').first} → ${item.deliveryAddress.split(',').first}';
                id = '#CS-${item.id}';
                date = item.createdAt != null ? item.createdAt!.split('T').first : 'Delivered';
                fee = '\$${item.fee}';
              } else {
                final item = _fallbackHistory[i];
                route = item['route']!;
                id = item['id']!;
                date = item['date']!;
                fee = item['fee']!;
              }

              return Container(
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
                      child: const Icon(Icons.delivery_dining, color: AppColors.cyan, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(route, style: AppTextStyles.titleMedium),
                          const SizedBox(height: 2),
                          Text('$id  •  $date', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Text(
                      fee,
                      style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          );

    return widget.embedded
        ? SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text('Delivery History', style: AppTextStyles.headlineLarge),
                ),
                Expanded(child: content),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Text('Delivery History', style: AppTextStyles.titleLarge),
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
            body: content,
          );
  }
}
