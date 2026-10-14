import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/services/food_service.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/widgets/gs_button.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  final FoodService _foodService = FoodService();
  final ProviderApplicationService _providerService = ProviderApplicationService();
  List<FoodOrderModel> _liveOrders = [];
  bool _isLoading = true;
  bool _acceptingOrders = true;
  Timer? _pollTimer;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchData(silent: true));
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);

    try {
      final p = await _providerService.getRestaurantProfile();
      if (mounted && p.isNotEmpty && p['accepting_orders'] != null) {
        setState(() {
          _acceptingOrders = p['accepting_orders'] == true;
        });
      }
    } catch (_) {}

    try {
      final list = await _foodService.getProviderOrders();
      if (mounted) {
        setState(() {
          _liveOrders = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleAcceptingOrders() async {
    final next = !_acceptingOrders;
    setState(() => _acceptingOrders = next);
    try {
      await _providerService.updateRestaurantProfile(acceptingOrders: next);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next ? 'Kitchen is now ACCEPTING orders' : 'Kitchen is now CLOSED for new orders'),
            backgroundColor: next ? AppColors.green : AppColors.gold,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      if (mounted) setState(() => _acceptingOrders = !next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit Go-Swift'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cyanLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.restaurant, color: AppColors.cyan, size: 20),
          ),
          title: Text('Kitchen Orders', style: AppTextStyles.titleLarge),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book, color: AppColors.cyan),
            tooltip: 'Menu Management',
            onPressed: () => Navigator.pushNamed(context, '/provider/restaurant/menu'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.cyan),
            tooltip: 'Profile',
            onPressed: () => Navigator.pushNamed(context, '/provider/restaurant/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.cyan),
            tooltip: 'Refresh',
            onPressed: () => _fetchData(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Acceptance status bar
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _acceptingOrders ? AppColors.green : AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _acceptingOrders ? 'Accepting Delivery Orders' : 'Kitchen Closed for Dispatch',
                      style: AppTextStyles.titleMedium,
                    ),
                  ],
                ),
                Switch(
                  value: _acceptingOrders,
                  activeThumbColor: AppColors.green,
                  onChanged: (_) => _toggleAcceptingOrders(),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
                : RefreshIndicator(
                    color: AppColors.primaryTeal,
                    onRefresh: () => _fetchData(),
                    child: _liveOrders.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _liveOrders.length,
                            itemBuilder: (c, i) {
                              final o = _liveOrders[i];
                              final id = o.orderNumber ?? '#GS-${o.id}';
                              final customer = o.customerName;
                              final items = o.items.isNotEmpty
                                  ? '${o.items.length} items • ${o.items.first.name}'
                                  : (o.deliveryAddress ?? 'Yacht / Villa Delivery');
                              final total = '\$${o.totalAmount.toStringAsFixed(2)}';
                              final status = o.status.toUpperCase();

                              final Color statusColor;
                              final Color statusBg;
                              if (status.contains('NEW') || status.contains('PLACED') || status.contains('PENDING')) {
                                statusColor = AppColors.gold;
                                statusBg = AppColors.goldLight;
                              } else if (status.contains('PREPARING')) {
                                statusColor = AppColors.cyan;
                                statusBg = AppColors.cyanLight;
                              } else {
                                statusColor = AppColors.green;
                                statusBg = AppColors.greenLight;
                              }

                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/provider/restaurant/order-detail',
                                  arguments: {'id': o.id, 'order': o},
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 14),
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
                                          Text(id, style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: statusBg,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(status, style: AppTextStyles.labelSmall.copyWith(color: statusColor, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(customer, style: AppTextStyles.headlineSmall),
                                      const SizedBox(height: 4),
                                      Text(items, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: Divider(color: AppColors.border, height: 1),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('TOTAL', style: AppTextStyles.caption.copyWith(letterSpacing: 1)),
                                          Text(total, style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
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
              child: const Icon(Icons.restaurant_menu_outlined, size: 38, color: AppColors.primaryTeal),
            ),
            const SizedBox(height: 20),
            Text('No Pending Kitchen Orders', style: AppTextStyles.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'New guest culinary orders will stream in automatically when placed. Pull down to refresh.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GSButton(
              label: 'Refresh Orders',
              isSecondary: true,
              onTap: () => _fetchData(),
            ),
          ],
        ),
      ),
    );
  }
}
