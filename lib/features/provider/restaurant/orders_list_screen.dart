import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/services/food_service.dart';
import '../../../core/services/provider_application_service.dart';

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

  final List<Map<String, String>> _fallbackOrders = [
    {'id': '#GS-2847', 'customer': 'Alexander Vance', 'items': '3 items • Black Cod Miso', 'total': '\$202.50', 'status': 'Preparing', 'time': '1:15 PM'},
    {'id': '#GS-2840', 'customer': 'Victoria Stubbs', 'items': '5 items • Bahamian Lobster', 'total': '\$312.00', 'status': 'New', 'time': '12:58 PM'},
    {'id': '#GS-2821', 'customer': 'Marcus Thompson', 'items': '2 items • Wagyu Tenderloin', 'total': '\$98.00', 'status': 'Ready', 'time': '12:30 PM'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
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
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final useLive = _liveOrders.isNotEmpty;
    final count = useLive ? _liveOrders.length : _fallbackOrders.length;

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
                  activeColor: AppColors.green,
                  onChanged: (_) => _toggleAcceptingOrders(),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: count,
                    itemBuilder: (c, i) {
                      final String id;
                      final String customer;
                      final String items;
                      final String total;
                      final String status;
                      int? orderId;

                      if (useLive) {
                        final o = _liveOrders[i];
                        orderId = o.id;
                        id = '#GS-${o.id}';
                        customer = o.customerName;
                        items = '${o.items.length} items • ${o.deliveryAddress}';
                        total = '\$${o.totalAmount}';
                        status = o.status.toUpperCase();
                      } else {
                        final o = _fallbackOrders[i];
                        id = o['id']!;
                        customer = o['customer']!;
                        items = o['items']!;
                        total = o['total']!;
                        status = o['status']!;
                      }

                      final Color statusColor;
                      final Color statusBg;
                      if (status.contains('NEW') || status.contains('PENDING')) {
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
                        onTap: () => Navigator.pushNamed(context, '/provider/restaurant/order-detail', arguments: {'id': orderId ?? 2847}),
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
                                children: [
                                  Text(id, style: AppTextStyles.cyanLabel),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusBg,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      status,
                                      style: AppTextStyles.labelSmall.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.person_outline, size: 16, color: AppColors.cyan),
                                  const SizedBox(width: 8),
                                  Text(customer, style: AppTextStyles.headlineSmall.copyWith(fontSize: 17)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.receipt_outlined, size: 16, color: AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(items, style: AppTextStyles.bodySmall)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(total, style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
                                  const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
