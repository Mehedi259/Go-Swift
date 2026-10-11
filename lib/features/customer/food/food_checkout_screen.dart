import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/food_service.dart';
import '../../../core/widgets/gs_button.dart';

class FoodCheckoutScreen extends StatefulWidget {
  const FoodCheckoutScreen({super.key});

  @override
  State<FoodCheckoutScreen> createState() => _FoodCheckoutScreenState();
}

class _FoodCheckoutScreenState extends State<FoodCheckoutScreen> {
  bool _isSubmitting = false;
  String _deliveryAddress = 'One Ocean Drive, Paradise Island, Bahamas';
  int _selectedSlot = 0;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null && user.streetAddress != null && user.streetAddress!.trim().isNotEmpty) {
        final city = (user.city != null && user.city!.trim().isNotEmpty) ? ', ${user.city}' : '';
        _deliveryAddress = '${user.streetAddress}$city';
      }
    }
  }

  void _showEditAddressDialog() {
    final addrCtrl = TextEditingController(text: _deliveryAddress);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Update Delivery Address', style: AppTextStyles.titleMedium),
        content: TextField(
          controller: addrCtrl,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Enter villa, suite, yacht slip, or street address',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
            onPressed: () {
              if (addrCtrl.text.trim().isNotEmpty) {
                setState(() => _deliveryAddress = addrCtrl.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Apply', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    setState(() => _isSubmitting = true);
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      int restId = 1;
      List<Map<String, dynamic>> orderItems = [
        {'food_item_id': 1, 'quantity': 1, 'notes': 'Butler handover requested'},
      ];

      if (args is Map) {
        if (args['restaurant'] is RestaurantModel) {
          restId = (args['restaurant'] as RestaurantModel).id;
        } else if (args['restaurant_id'] is int) {
          restId = args['restaurant_id'] as int;
        }
        if (args['cart'] is Map<int, int>) {
          final cart = args['cart'] as Map<int, int>;
          if (cart.isNotEmpty) {
            orderItems = cart.entries.map((e) => {
              'food_item_id': e.key,
              'quantity': e.value,
              'notes': 'Prepared fresh',
            }).toList();
          }
        }
      }

      final order = await FoodService().createOrder(
        restaurantId: restId,
        items: orderItems,
        deliveryAddress: _deliveryAddress,
        deliveryLatitude: 25.0772,
        deliveryLongitude: -77.3031,
        deliveryNotes: 'Climate-sealed transport requested',
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.pushNamed(context, '/customer/food/order-status', arguments: order);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order dispatched or demo fallback: $e'),
            backgroundColor: AppColors.primaryNavy,
          ),
        );
        Navigator.pushNamed(context, '/customer/food/order-status');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Checkout', style: AppTextStyles.titleLarge),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DELIVERY ADDRESS', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _showEditAddressDialog,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.primaryTeal, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Delivery Destination', style: AppTextStyles.titleMedium),
                                const SizedBox(height: 2),
                                Text(_deliveryAddress, style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.cardTouchpoint,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.edit_outlined, color: AppColors.primaryTeal, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('DELIVERY SLOT', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _slot('ASAP', '30-40 min', _selectedSlot == 0, 0),
                      const SizedBox(width: 10),
                      _slot('12:00 PM', 'Scheduled', _selectedSlot == 1, 1),
                      const SizedBox(width: 10),
                      _slot('7:00 PM', 'Evening', _selectedSlot == 2, 2),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('PAYMENT METHOD', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryTeal, width: 2),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.credit_card, color: AppColors.primaryTeal, size: 22),
                        const SizedBox(width: 12),
                        Expanded(child: Text('Visa •••• 4291', style: AppTextStyles.titleMedium)),
                        const Icon(Icons.check_circle, color: AppColors.primaryTeal, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Icon(Icons.add_circle_outline, color: AppColors.primaryTeal, size: 18),
                        const SizedBox(width: 8),
                        Text('Add payment method', style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      children: [
                        _row('Subtotal', '\$190.00'),
                        _row('Delivery', 'FREE'),
                        _row('Service Fee', '\$12.50'),
                        const Divider(color: AppColors.border, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TOTAL', style: AppTextStyles.headlineSmall),
                            Text('\$202.50', style: AppTextStyles.price.copyWith(fontSize: 22)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GSButton(
              label: 'Place Order • \$202.50 →',
              isLoading: _isSubmitting,
              onTap: _isSubmitting ? null : _placeOrder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _slot(String time, String label, bool active, int index) => Expanded(
    child: GestureDetector(
      onTap: () => setState(() => _selectedSlot = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.cyanPill : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? AppColors.primaryTeal : AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Text(time, style: AppTextStyles.titleMedium.copyWith(color: active ? AppColors.primaryTeal : AppColors.textPrimary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.caption.copyWith(color: active ? AppColors.primaryTeal : AppColors.textMuted)),
          ],
        ),
      ),
    ),
  );

  Widget _row(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: AppTextStyles.bodyMedium),
        Text(v, style: AppTextStyles.titleMedium.copyWith(color: v == 'FREE' ? AppColors.green : AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
