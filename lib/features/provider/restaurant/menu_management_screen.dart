import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/services/food_service.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/widgets/gs_button.dart';

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
  int? _activeCategoryId;

  @override
  void initState() {
    super.initState();
    _loadMenuData();
  }

  Future<void> _loadMenuData() async {
    setState(() => _isLoading = true);
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
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, color: AppColors.cyan),
            tooltip: 'Orders',
            onPressed: () => Navigator.pushNamed(context, '/provider/restaurant/orders'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
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
                    Text('Add Item', style: AppTextStyles.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    _statCard('${_liveItems.length}', 'Menu Items'),
                    const SizedBox(width: 10),
                    _statCard('Active', 'Kitchen Status'),
                    const SizedBox(width: 10),
                    _statCard('4.9 ★', 'Guest Rating'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
                : RefreshIndicator(
                    color: AppColors.primaryTeal,
                    onRefresh: _loadMenuData,
                    child: _liveItems.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _liveItems.length,
                            itemBuilder: (c, i) {
                              final item = _liveItems[i];
                              final name = item.name;
                              final price = '\$${item.price.toStringAsFixed(2)}';
                              final available = item.isAvailable;

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
                                          Text(price, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: available ? AppColors.greenLight : AppColors.goldLight,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        available ? 'Available' : 'Sold Out',
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: available ? AppColors.green : AppColors.gold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
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
              child: const Icon(Icons.menu_book_outlined, size: 38, color: AppColors.primaryTeal),
            ),
            const SizedBox(height: 20),
            Text('No Menu Items Yet', style: AppTextStyles.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Add signature dishes, appetizers, and beverages for guests across Nassau & Paradise Island.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GSButton(
              label: 'Add First Dish →',
              onTap: _showAddItemDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String val, String lbl) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Text(val, style: AppTextStyles.titleLarge.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(lbl, style: AppTextStyles.caption),
            ],
          ),
        ),
      );
}
