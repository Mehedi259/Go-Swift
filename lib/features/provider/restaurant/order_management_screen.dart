import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/food_service.dart';
import '../../../core/widgets/gs_button.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final FoodService _foodService = FoodService();
  String _status = 'PREPARING';
  bool _isUpdating = false;

  Future<void> _updateStatus(String newStatus, int orderId) async {
    setState(() => _isUpdating = true);
    try {
      await _foodService.updateOrderStatus(orderId, newStatus.toLowerCase());
      if (mounted) {
        setState(() => _status = newStatus.toUpperCase());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to $newStatus'),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (_) {
      if (mounted) setState(() => _status = newStatus.toUpperCase());
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final int orderId = args?['id'] ?? 2847;

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
        title: Text('Order #GS-$orderId', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.cyanLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
              ),
              child: Text(
                '$_status  •  ORDER #GS-$orderId',
                style: AppTextStyles.cyanLabel.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 14),
            Text('Alexander Vance', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.directions_boat_outlined, size: 16, color: AppColors.cyan),
                const SizedBox(width: 6),
                Text('Yacht delivery • Slip #12, Albany Marina',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 22),
            Text('Order Items', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            ...[
              {'name': 'Yellowfin Tuna Tartare', 'qty': 1, 'price': '\$38.00'},
              {'name': 'Crispy Black Cod Miso', 'qty': 1, 'price': '\$68.00'},
              {'name': 'Bahamian Lobster Bisque', 'qty': 2, 'price': '\$84.00'},
            ].map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
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
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '×${item['qty']} ${item['name']}',
                          style: AppTextStyles.titleMedium,
                        ),
                      ),
                      Text(
                        item['price'] as String,
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  _row('Subtotal', '\$190.00'),
                  _row('Courier Fee', 'Assigned (Paid)'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: AppColors.border),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL', style: AppTextStyles.headlineSmall),
                      Text(
                        '\$202.50',
                        style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GSButton(
              label: _isUpdating ? 'Updating Status...' : (_status == 'READY' ? 'Ready for Courier Pickup ✓' : 'Ready for Pickup →'),
              onTap: _isUpdating
                  ? () {}
                  : () async {
                      if (_status != 'READY') {
                        await _updateStatus('ready', orderId);
                      } else {
                        Navigator.pop(context);
                      }
                    },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyMedium),
            Text(value, style: AppTextStyles.titleMedium),
          ],
        ),
      );
}
