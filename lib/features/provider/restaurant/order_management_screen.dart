import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
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
  FoodOrderModel? _liveOrder;
  bool _isLoading = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args?['order'] is FoodOrderModel) {
        _liveOrder = args!['order'] as FoodOrderModel;
        _status = _liveOrder!.status.toUpperCase();
        _isLoading = false;
      }
      final int orderId = args?['id'] ?? _liveOrder?.id ?? 1;
      _loadOrderDetail(orderId);
    }
  }

  Future<void> _loadOrderDetail(int orderId) async {
    try {
      final order = await _foodService.getProviderOrderDetail(orderId);
      if (mounted) {
        setState(() {
          _liveOrder = order;
          _status = order.status.toUpperCase();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
    final int orderId = args?['id'] ?? _liveOrder?.id ?? 1;

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
          : SingleChildScrollView(
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
                  Text(_liveOrder?.customerName ?? 'VIP Guest', style: AppTextStyles.headlineLarge),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.cyan),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _liveOrder?.deliveryAddress ?? 'Ocean Club Suite Delivery, Paradise Island',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text('Order Items', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 12),
                  if (_liveOrder != null && _liveOrder!.items.isNotEmpty)
                    ..._liveOrder!.items.map((item) => Container(
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
                                  '×${item.quantity} ${item.name}',
                                  style: AppTextStyles.titleMedium,
                                ),
                              ),
                              Text(
                                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ))
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text('Curated chef order items being prepared by kitchen.', style: AppTextStyles.bodyMedium),
                    ),
                  const SizedBox(height: 24),
                  // Total summary card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TOTAL REVENUE', style: AppTextStyles.titleMedium),
                        Text(
                          '\$${(_liveOrder?.totalAmount ?? 118.0).toStringAsFixed(2)}',
                          style: AppTextStyles.price.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Update Order Progression', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: ['PREPARING', 'READY FOR COURIER', 'IN TRANSIT', 'DELIVERED'].map((s) {
                      final isCurrent = _status == s;
                      return GestureDetector(
                        onTap: () => _updateStatus(s, orderId),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isCurrent ? AppColors.cyan : AppColors.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isCurrent ? AppColors.cyan : AppColors.border),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Text(
                            s,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isCurrent ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  GSButton(
                    label: _isUpdating ? 'Updating Kitchen Status...' : 'Advance Status →',
                    isLoading: _isUpdating,
                    onTap: () {
                      final next = _status == 'PREPARING'
                          ? 'READY FOR COURIER'
                          : _status == 'READY FOR COURIER'
                              ? 'IN TRANSIT'
                              : 'DELIVERED';
                      _updateStatus(next, orderId);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
