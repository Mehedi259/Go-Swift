import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/widgets/gs_button.dart';

class FoodCartScreen extends StatefulWidget {
  const FoodCartScreen({super.key});

  @override
  State<FoodCartScreen> createState() => _FoodCartScreenState();
}

class _FoodCartScreenState extends State<FoodCartScreen> {
  RestaurantModel? _restaurant;
  Map<int, int> _cart = {};
  List<FoodItemModel> _menu = [];
  bool _initialized = false;
  final TextEditingController _instructionCtrl = TextEditingController();

  final List<Map<String, dynamic>> _fallbackItems = [
    {'id': 1, 'name': 'Yellowfin Tuna Tartare', 'price': 38.0, 'qty': 1},
    {'id': 2, 'name': 'Crispy Black Cod Miso', 'price': 68.0, 'qty': 1},
    {'id': 3, 'name': 'Bahamian Lobster Bisque', 'price': 42.0, 'qty': 2},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        if (args['restaurant'] is RestaurantModel) {
          _restaurant = args['restaurant'] as RestaurantModel;
        }
        if (args['cart'] is Map<int, int>) {
          _cart = Map<int, int>.from(args['cart'] as Map<int, int>);
        }
        if (args['menu'] is List<FoodItemModel>) {
          _menu = List<FoodItemModel>.from(args['menu'] as List<FoodItemModel>);
        }
      }
    }
  }

  @override
  void dispose() {
    _instructionCtrl.dispose();
    super.dispose();
  }

  double get _subtotal {
    if (_cart.isNotEmpty && _menu.isNotEmpty) {
      double total = 0.0;
      for (final entry in _cart.entries) {
        final item = _menu.firstWhere(
          (m) => m.id == entry.key,
          orElse: () => FoodItemModel(id: entry.key, name: 'Item #${entry.key}', price: 38.0),
        );
        total += item.price * entry.value;
      }
      return total;
    }
    return _fallbackItems.fold(0.0, (sum, i) => sum + (i['price'] as double) * (i['qty'] as int));
  }

  double get _serviceFee => 12.50;
  double get _deliveryFee => 0.00; // Free yacht delivery included
  double get _total => _subtotal + _serviceFee + _deliveryFee;

  void _increment(int itemId) {
    setState(() {
      _cart[itemId] = (_cart[itemId] ?? 0) + 1;
    });
  }

  void _decrement(int itemId) {
    setState(() {
      final current = _cart[itemId] ?? 0;
      if (current > 1) {
        _cart[itemId] = current - 1;
      } else {
        _cart.remove(itemId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final restName = _restaurant?.name ?? 'Dune by Jean-Georges';
    final restHub = _restaurant?.islandHub ?? 'Ocean Club, Paradise Island';
    final hasRealCart = _cart.isNotEmpty && _menu.isNotEmpty;

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
        title: Text('Your Order Cart', style: AppTextStyles.titleLarge),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restName, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primaryTeal)),
                  const SizedBox(height: 4),
                  Text(restHub, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 20),
                  if (hasRealCart)
                    ..._cart.entries.map((entry) {
                      final item = _menu.firstWhere(
                        (m) => m.id == entry.key,
                        orElse: () => FoodItemModel(id: entry.key, name: 'Dish #${entry.key}', price: 38.0),
                      );
                      return _buildCartRow(
                        name: item.name,
                        qty: entry.value,
                        price: item.price * entry.value,
                        onAdd: () => _increment(item.id),
                        onRemove: () => _decrement(item.id),
                      );
                    })
                  else
                    ..._fallbackItems.map((item) => _buildCartRow(
                          name: item['name'] as String,
                          qty: item['qty'] as int,
                          price: (item['price'] as double) * (item['qty'] as int),
                          onAdd: () {},
                          onRemove: () {},
                        )),
                  const SizedBox(height: 16),
                  // Delivery note
                  TextFormField(
                    controller: _instructionCtrl,
                    maxLines: 2,
                    style: AppTextStyles.bodyMedium,
                    decoration: const InputDecoration(
                      hintText: 'Special instructions for your chef or delivery (e.g. yacht slip #12)',
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
                        _row('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
                        _row('Delivery Fee', '\$0.00', sub: 'FREE (Yacht delivery included)'),
                        _row('Service Fee', '\$${_serviceFee.toStringAsFixed(2)}'),
                        const Divider(color: AppColors.border, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TOTAL', style: AppTextStyles.headlineSmall),
                            Text('\$${_total.toStringAsFixed(2)}', style: AppTextStyles.price.copyWith(fontSize: 22)),
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
              label: 'Proceed to Checkout →',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/customer/food/checkout',
                  arguments: {
                    'restaurant': _restaurant,
                    'cart': _cart,
                    'menu': _menu,
                    'subtotal': _subtotal,
                    'total': _total,
                    'note': _instructionCtrl.text.trim(),
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartRow({
    required String name,
    required int qty,
    required double price,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.cardTouchpoint, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.set_meal, color: AppColors.primaryTeal, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.titleMedium),
                Text('×$qty', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 20, color: AppColors.textSecondary),
                onPressed: onRemove,
              ),
              Text('$qty', style: AppTextStyles.titleMedium),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20, color: AppColors.primaryTeal),
                onPressed: onAdd,
              ),
            ],
          ),
          const SizedBox(width: 8),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _row(String l, String v, {String? sub}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l, style: AppTextStyles.bodyMedium),
                if (sub != null) Text(sub, style: AppTextStyles.bodySmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            Text(v, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      );
}
