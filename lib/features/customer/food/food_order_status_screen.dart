import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/services/food_service.dart';
import '../../../core/widgets/gs_button.dart';

class FoodOrderStatusScreen extends StatefulWidget {
  final FoodOrderModel? order;
  const FoodOrderStatusScreen({super.key, this.order});

  @override
  State<FoodOrderStatusScreen> createState() => _FoodOrderStatusScreenState();
}

class _FoodOrderStatusScreenState extends State<FoodOrderStatusScreen> {
  final FoodService _foodService = FoodService();
  FoodOrderModel? _order;
  Timer? _pollTimer;
  bool _initialized = false;
  bool _isCancelling = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is FoodOrderModel) {
        _order = args;
        _startPolling();
      } else if (args is int) {
        _loadOrderById(args);
      } else if (widget.order != null) {
        _order = widget.order;
        _startPolling();
      } else {
        _fetchActiveOrder();
      }
    }
  }

  Future<void> _loadOrderById(int orderId) async {
    try {
      final ord = await _foodService.getOrderDetail(orderId);
      if (mounted) {
        setState(() => _order = ord);
        _startPolling();
      }
    } catch (_) {}
  }

  Future<void> _fetchActiveOrder() async {
    try {
      final orders = await _foodService.getMyOrders();
      if (mounted && orders.isNotEmpty) {
        FoodOrderModel? active;
        for (final o in orders) {
          final s = o.status.toLowerCase();
          if (s != 'cancelled' && s != 'delivered') {
            active = o;
            break;
          }
        }
        active ??= orders.first;
        setState(() => _order = active);
        _startPolling();
      }
    } catch (_) {}
  }

  void _startPolling() {
    final orderId = _order?.id;
    if (orderId == null) return;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      try {
        final updated = await _foodService.getOrderDetail(orderId);
        if (!mounted) return;
        setState(() {
          _order = updated;
        });
        final s = updated.status.toLowerCase();
        if (s == 'delivered' || s == 'cancelled') {
          _pollTimer?.cancel();
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleCancelOrder() async {
    final orderId = _order?.id;
    if (orderId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel Food Order?', style: AppTextStyles.titleLarge),
        content: Text(
          'Are you sure you want to cancel your order #${_order?.orderNumber ?? orderId}? This cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Keep Order', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isCancelling = true);
    try {
      await _foodService.cancelOrder(orderId, reason: 'Customer requested cancellation');
      _pollTimer?.cancel();
      final refreshed = await _foodService.getOrderDetail(orderId);
      if (mounted) {
        setState(() {
          _order = refreshed;
          _isCancelling = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order has been cancelled.'), backgroundColor: AppColors.red),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isCancelling = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order cancelled successfully.'), backgroundColor: AppColors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;
    final orderNum = order?.orderNumber ?? (order != null ? '#GS-${order.id}' : '#GS-ORDER');
    final restName = (order?.restaurantName ?? 'Culinary Kitchen').toUpperCase();
    final status = order?.status.toLowerCase() ?? 'placed';

    final isCancelled = status == 'cancelled';
    final isDelivered = status == 'delivered';
    final isInTransit = status == 'in_transit' || status == 'out_for_delivery';
    final isPreparing = status == 'preparing' || status == 'ready' || isInTransit || isDelivered;
    final isConfirmed = status != 'cancelled';

    final steps = [
      {'label': 'Order Confirmed', 'sub': '$restName acknowledged', 'done': isConfirmed},
      {'label': 'Chef Preparing', 'sub': 'Kitchen crafted with fresh ingredients', 'done': isPreparing},
      {'label': 'Out for Delivery', 'sub': 'Courier dispatch en route', 'done': isInTransit || isDelivered},
      {'label': 'Delivered', 'sub': 'Handed over at dock or villa', 'done': isDelivered},
    ];

    final etaText = isCancelled
        ? 'Order Cancelled'
        : isDelivered
            ? 'Delivered • Enjoy your meal!'
            : isInTransit
                ? 'Expected delivery: 15-20 min remaining'
                : 'Expected delivery: 30-40 min remaining';

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Text('Order Status', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryTeal),
            onPressed: () async {
              if (order?.id != null) {
                final upd = await _foodService.getOrderDetail(order!.id);
                if (mounted) setState(() => _order = upd);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isCancelled ? AppColors.red.withValues(alpha: 0.15) : AppColors.badgeTeal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isCancelled ? AppColors.red : AppColors.primaryTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'ORDER $orderNum • $restName',
                    style: AppTextStyles.cyanLabel.copyWith(
                      color: isCancelled ? AppColors.red : AppColors.primaryTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isCancelled
                  ? 'Order Cancelled'
                  : isDelivered
                      ? 'Meal Delivered!'
                      : 'Your Order is\nOn Its Way!',
              style: AppTextStyles.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(etaText, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            // Progress
            if (!isCancelled)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: steps.asMap().entries.map((e) => _step(
                    e.value['label'] as String,
                    e.value['sub'] as String,
                    e.value['done'] as bool,
                    e.key == steps.length - 1,
                  )).toList(),
                ),
              ),
            if (isCancelled)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cancel_outlined, color: AppColors.red, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order Cancelled', style: AppTextStyles.titleMedium.copyWith(color: AppColors.red)),
                          Text('Any preauthorized charges will be refunded to your card.', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            // Order Items & Delivery Summary
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery Details', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primaryTeal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order?.deliveryAddress ?? 'Designated Delivery Destination',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  if (order != null && order.items.isNotEmpty) ...[
                    const Divider(color: AppColors.border, height: 24),
                    Text('Dishes Ordered', style: AppTextStyles.titleMedium),
                    const SizedBox(height: 8),
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.quantity}× ${item.name}', style: AppTextStyles.bodyMedium),
                          Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                  ],
                  const Divider(color: AppColors.border, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount', style: AppTextStyles.titleLarge),
                      Text(
                        '\$${(order?.totalAmount ?? 0.0).toStringAsFixed(2)}',
                        style: AppTextStyles.price.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Courier info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.badgeTeal, shape: BoxShape.circle),
                    child: const Icon(Icons.delivery_dining, color: AppColors.primaryTeal, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Assigned Chilled Dispatcher', style: AppTextStyles.titleLarge),
                        Text('VIP Dining Chauffeur • Escort', style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.cardTouchpoint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.phone_outlined, color: AppColors.primaryTeal, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (!isCancelled && !isDelivered) ...[
              GSButton(
                label: _isCancelling ? 'Cancelling Order...' : 'Cancel Order',
                isSecondary: true,
                isLoading: _isCancelling,
                onTap: _isCancelling ? () {} : _handleCancelOrder,
              ),
              const SizedBox(height: 12),
            ],
            GSButton(
              label: 'Return to Hub',
              isSecondary: isCancelled || isDelivered,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _step(String label, String sub, bool done, bool isLast) => Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: done ? AppColors.primaryTeal : AppColors.cardTouchpoint,
                  shape: BoxShape.circle,
                  border: Border.all(color: done ? AppColors.primaryTeal : AppColors.border),
                ),
                child: Icon(done ? Icons.check : Icons.radio_button_unchecked, size: 14, color: done ? Colors.white : AppColors.textMuted),
              ),
              if (!isLast) Container(width: 2, height: 32, color: done ? AppColors.primaryTeal.withValues(alpha: 0.4) : AppColors.border),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.titleMedium.copyWith(color: done ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: done ? FontWeight.bold : FontWeight.normal)),
                  Text(sub, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
