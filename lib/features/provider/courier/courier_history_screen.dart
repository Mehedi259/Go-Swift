import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/courier_model.dart';
import '../../../core/services/courier_service.dart';
import '../../../core/widgets/gs_button.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoading = true);
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
    final content = _isLoading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
        : RefreshIndicator(
            color: AppColors.primaryTeal,
            onRefresh: _fetchHistory,
            child: _liveHistory.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: _liveHistory.length,
                    itemBuilder: (c, i) {
                      final item = _liveHistory[i];
                      final route = '${item.pickupAddress.split(',').first} → ${item.deliveryAddress.split(',').first}';
                      final id = '#CS-${item.id}';
                      final date = item.createdAt != null ? item.createdAt!.split('T').first : 'Delivered';
                      final fee = '\$${item.fee}';

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
                  ),
          );

    return widget.embedded
        ? SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
              title: Text('Delivery History', style: AppTextStyles.titleLarge),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.primaryTeal),
                  onPressed: _fetchHistory,
                ),
              ],
            ),
            body: content,
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
              child: const Icon(Icons.local_shipping_outlined, size: 38, color: AppColors.primaryTeal),
            ),
            const SizedBox(height: 20),
            Text('No Completed Deliveries Yet', style: AppTextStyles.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Your completed courier delivery trips and chain-of-custody handovers will be listed here.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GSButton(
              label: 'Refresh History',
              isSecondary: true,
              onTap: _fetchHistory,
            ),
          ],
        ),
      ),
    );
  }
}
