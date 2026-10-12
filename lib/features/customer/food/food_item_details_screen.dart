import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/widgets/gs_button.dart';

class FoodItemDetailsScreen extends StatefulWidget {
  const FoodItemDetailsScreen({super.key});
  @override
  State<FoodItemDetailsScreen> createState() => _FoodItemDetailsScreenState();
}

class _FoodItemDetailsScreenState extends State<FoodItemDetailsScreen> {
  int _qty = 1;
  String _selectedSpice = 'Mild';
  final Set<String> _selectedAddons = {};

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    FoodItemModel? item;
    RestaurantModel? restaurant;
    Map<int, int> cart = {};
    List<FoodItemModel> menu = [];

    if (args is FoodItemModel) {
      item = args;
    } else if (args is Map<String, dynamic>) {
      if (args['item'] is FoodItemModel) item = args['item'] as FoodItemModel;
      if (args['restaurant'] is RestaurantModel) restaurant = args['restaurant'] as RestaurantModel;
      if (args['cart'] is Map<int, int>) cart = Map<int, int>.from(args['cart'] as Map<int, int>);
      if (args['menu'] is List<FoodItemModel>) menu = List<FoodItemModel>.from(args['menu'] as List<FoodItemModel>);
    }

    final itemName = item?.name ?? 'Yellowfin Tuna Tartare';
    final itemCategory = (item?.categoryName ?? 'Chef Curated Selection').toUpperCase();
    final itemDesc = item?.description ??
        'Bahamian wild-caught yellowfin tuna, avocado, crispy wonton chips, yuzu ponzu, microgreens, sesame oil, and island citrus zest.';
    final unitPrice = item?.price ?? 38.0;
    final currency = item?.currency ?? 'BSD';
    final prepWindow = item?.prepWindow ?? '25-35 min';
    final tags = (item?.dietaryTags != null && item!.dietaryTags.isNotEmpty)
        ? item.dietaryTags
        : ['Gluten-Free Available', 'Wild-Caught Bahamian'];

    double addonExtra = 0.0;
    if (_selectedAddons.contains('Extra Portion (+\$12)')) addonExtra += 12.0;
    if (_selectedAddons.contains('Truffle Oil Infusion (+\$8)')) addonExtra += 8.0;
    if (_selectedAddons.contains('Island Caviar Garnish (+\$25)')) addonExtra += 25.0;

    final totalPrice = (unitPrice + addonExtra) * _qty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE8F4F8), Color(0xFFD6EDF4)],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.set_meal,
                      color: AppColors.primaryTeal.withValues(alpha: 0.4),
                      size: 64,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                  ),
                  if (restaurant != null)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          restaurant.name,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.badgeTeal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        itemCategory,
                        style: AppTextStyles.cyanLabel.copyWith(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(itemName, style: AppTextStyles.headlineLarge),
                        ),
                        Text(
                          '\$${unitPrice.toStringAsFixed(0)}',
                          style: AppTextStyles.price.copyWith(fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(itemDesc, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: AppColors.primaryTeal),
                        const SizedBox(width: 4),
                        Text(prepWindow, style: AppTextStyles.bodySmall),
                        const SizedBox(width: 16),
                        const Icon(Icons.monetization_on_outlined, size: 16, color: AppColors.gold),
                        const SizedBox(width: 4),
                        Text(currency, style: AppTextStyles.bodySmall),
                      ],
                    ),
                    if (tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: tags.map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F7ED),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            t,
                            style: AppTextStyles.caption.copyWith(color: AppColors.green, fontWeight: FontWeight.bold),
                          ),
                        )).toList(),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text('Customize Spice Level', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: ['Mild', 'Medium', 'Spicy', 'Island Calypso Hot'].map((s) {
                        final isSel = _selectedSpice == s;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSpice = s),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.badgeTeal : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSel ? AppColors.primaryTeal : AppColors.border),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: Text(
                              s,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isSel ? AppColors.primaryTeal : AppColors.textPrimary,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text('Curated Add-ons', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Extra Portion (+\$12)', 'Truffle Oil Infusion (+\$8)', 'Island Caviar Garnish (+\$25)'].map((addon) {
                        final isSel = _selectedAddons.contains(addon);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSel) {
                                _selectedAddons.remove(addon);
                              } else {
                                _selectedAddons.add(addon);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.badgeTeal : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSel ? AppColors.primaryTeal : AppColors.border),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSel ? Icons.check_circle : Icons.add_circle_outline,
                                  size: 16,
                                  color: isSel ? AppColors.primaryTeal : AppColors.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  addon,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isSel ? AppColors.primaryTeal : AppColors.textPrimary,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text('Quantity', style: AppTextStyles.titleLarge),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() => _qty = (_qty - 1).clamp(1, 10)),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: const Icon(Icons.remove, color: AppColors.textPrimary, size: 18),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text('$_qty', style: AppTextStyles.headlineSmall),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => setState(() => _qty++),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle),
                            child: const Icon(Icons.add, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GSButton(
                label: 'Add to Order • \$${totalPrice.toStringAsFixed(0)} →',
                onTap: () {
                  final targetId = item?.id ?? 1;
                  cart[targetId] = (cart[targetId] ?? 0) + _qty;
                  if (item != null && !menu.any((m) => m.id == item!.id)) {
                    menu.add(item);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added $_qty × $itemName to order'),
                      backgroundColor: AppColors.primaryTeal,
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );

                  Navigator.pushNamed(
                    context,
                    '/customer/food/cart',
                    arguments: {
                      'restaurant': restaurant,
                      'cart': cart,
                      'menu': menu,
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
