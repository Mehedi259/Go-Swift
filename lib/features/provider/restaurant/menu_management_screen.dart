import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/services/food_service.dart';
import '../../../core/services/provider_application_service.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final FoodService _foodService = FoodService();
  final ProviderApplicationService _providerService = ProviderApplicationService();
  List<FoodItemModel> _liveItems = [];
  bool _isLoading = true;
  String _restaurantName = 'Dune by Jean-Georges';
  String _restaurantLocation = 'Ocean Club, Paradise Island';

  final List<Map<String, dynamic>> _fallbackItems = [
    {'name': 'Yellowfin Tuna Tartare', 'price': '\$38.00', 'available': true},
    {'name': 'Crispy Black Cod Miso', 'price': '\$68.00', 'available': true},
    {'name': 'Wagyu Beef Tenderloin', 'price': '\$145.00', 'available': false},
    {'name': 'Bahamian Lobster Bisque', 'price': '\$42.00', 'available': true},
    {'name': 'Truffle Risotto', 'price': '\$55.00', 'available': true},
  ];

  @override
  void initState() {
    super.initState();
    _loadMenuData();
  }

  int? _activeCategoryId;

  Future<void> _loadMenuData() async {
    try {
      final p = await _providerService.getRestaurantProfile();
      if (mounted && p.isNotEmpty) {
        setState(() {
          if (p['restaurant_name'] != null && (p['restaurant_name'] as String).isNotEmpty) {
            _restaurantName = p['restaurant_name'];
          }
          if (p['island_service_hub'] != null) {
            _restaurantLocation = p['island_service_hub'];
          }
        });
      }
    } catch (_) {}

    try {
      final cats = await _foodService.getCategories();
      if (cats.isNotEmpty && cats.first['id'] != null) {
        _activeCategoryId = cats.first['id'] is int ? cats.first['id'] as int : int.tryParse(cats.first['id'].toString());
      }
    } catch (_) {}

    try {
      final items = await _foodService.getProviderMenuItems();
      if (mounted) {
        setState(() {
          _liveItems = items;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddItemDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Add Gourmet Item', style: AppTextStyles.headlineSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Dish Name', hintText: 'e.g. Grilled Bahamian Snapper'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price (\$)', hintText: '48.00'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Description', hintText: 'Island spices, lemongrass reduction'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyan, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
              if (name.isNotEmpty && price > 0) {
                Navigator.pop(ctx);
                try {
                  int? catId = _activeCategoryId;
                  if (catId == null) {
                    final created = await _foodService.createCategory(name: 'Main Menu', description: 'Chef Curated Island Specialties');
                    if (created['id'] != null) {
                      catId = created['id'] is int ? created['id'] as int : int.tryParse(created['id'].toString());
                      _activeCategoryId = catId;
                    }
                  }
                  await _foodService.createFoodItem(
                    categoryId: catId,
                    name: name,
                    description: descCtrl.text.trim(),
                    price: price,
                  );
                  _loadMenuData();
                } catch (_) {}
              }
            },
            child: const Text('Save Item', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useLive = _liveItems.isNotEmpty;
    final count = useLive ? _liveItems.length : _fallbackItems.length;

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
        title: Text('Menu Management', style: AppTextStyles.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _showAddItemDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Add Item',
                      style: AppTextStyles.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_restaurantName, style: AppTextStyles.headlineLarge.copyWith(color: AppColors.cyan)),
                const SizedBox(height: 2),
                Text(_restaurantLocation, style: AppTextStyles.bodySmall),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _statCard('$count', 'Menu Items'),
                    const SizedBox(width: 10),
                    _statCard('8', 'Active Orders'),
                    const SizedBox(width: 10),
                    _statCard('4.9 ★', 'Rating'),
                  ],
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
                      final String name;
                      final String price;
                      final bool available;

                      if (useLive) {
                        final item = _liveItems[i];
                        name = item.name;
                        price = '\$${item.price}';
                        available = item.isAvailable;
                      } else {
                        final item = _fallbackItems[i];
                        name = item['name'] as String;
                        price = item['price'] as String;
                        available = item['available'] as bool;
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
                              child: const Icon(Icons.restaurant_menu, color: AppColors.cyan, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, style: AppTextStyles.titleMedium),
                                  const SizedBox(height: 2),
                                  Text(price, style: AppTextStyles.cyanLabel),
                                ],
                              ),
                            ),
                            Switch(
                              value: available,
                              activeColor: AppColors.cyan,
                              onChanged: (_) {},
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String val, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardTouchpoint,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Text(val, style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      );
}
