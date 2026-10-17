import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/services/food_service.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final RestaurantModel? restaurant;
  const RestaurantDetailsScreen({super.key, this.restaurant});

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  RestaurantModel? _restaurant;
  List<FoodItemModel> _menuItems = [];
  bool _isLoading = false;
  final Map<int, int> _cart = {}; // itemId -> quantity

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_restaurant == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is RestaurantModel) {
        _restaurant = args;
      }
      _fetchMenu();
    }
  }

  Future<void> _fetchMenu() async {
    final restId = _restaurant?.id ?? widget.restaurant?.id;
    if (restId == null) return;
    setState(() => _isLoading = true);
    try {
      final menu = await FoodService().getRestaurantMenu(restId);
      if (mounted) {
        setState(() {
          _menuItems = menu;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addItem(int itemId) {
    setState(() {
      _cart[itemId] = (_cart[itemId] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added to order cart'),
        duration: Duration(milliseconds: 1000),
        backgroundColor: AppColors.primaryTeal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rest = _restaurant ?? widget.restaurant;
    final restName = rest?.name ?? 'Dune by Jean-Georges';
    final cuisine = rest?.cuisineConcept ?? 'FRENCH-ASIAN FUSION • FINE DINING';
    final location = '${rest?.islandHub ?? "Ocean Club, Paradise Island"} • 3.2 miles';
    final prepWindow = rest?.averagePrepWindow ?? '30-40 min';

    final String heroPhoto = rest?.name.toLowerCase().contains('ocean club') == true || rest?.id == 1
        ? 'https://goswift-media-prod.s3.us-east-1.amazonaws.com/food/items/lobster.jpg'
        : 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Hero Banner
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFD6EDF4),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    heroPhoto,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.restaurant, color: AppColors.primaryTeal, size: 64),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
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
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: const Icon(Icons.favorite_border, color: AppColors.primaryTeal, size: 20),
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
                      child: Text('OCEAN CLUB • \$\$\$\$', style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(restName, style: AppTextStyles.headlineLarge)),
                        GSRatingRow(rating: rest?.rating ?? 4.9, reviews: 280),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(cuisine.toUpperCase(), style: AppTextStyles.bodySmall),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(child: Text(location, style: AppTextStyles.bodySmall)),
                        const SizedBox(width: 14),
                        const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(prepWindow, style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _badge('Free Yacht Delivery', AppColors.badgeCyan, AppColors.primaryTeal),
                        const SizedBox(width: 8),
                        _badge('Dockside Ready', AppColors.badgeTeal, AppColors.primaryTeal),
                        const SizedBox(width: 8),
                        _badge('Open Now', const Color(0xFFE8F7ED), AppColors.green),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Featured Menu', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    if (_isLoading)
                      const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: AppColors.primaryTeal)))
                    else
                      ...(_menuItems.isNotEmpty ? _menuItems : FoodService.defaultBahamianMenu).map((item) => _buildItemCard(
                        id: item.id,
                        name: item.name,
                        desc: item.description ?? 'Curated fresh island ingredients',
                        price: '\$${item.price.toStringAsFixed(0)}',
                        item: item,
                      )),
                    const SizedBox(height: 20),
                    GSButton(
                      label: _cart.isNotEmpty ? 'View Cart (${_cart.values.fold(0, (a, b) => a + b)}) →' : 'View Cart →',
                      onTap: () => Navigator.pushNamed(context, '/customer/food/cart', arguments: {
                        'restaurant': rest,
                        'cart': _cart,
                        'menu': _menuItems.isNotEmpty ? _menuItems : FoodService.defaultBahamianMenu,
                      }),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard({required int id, required String name, required String desc, required String price, FoodItemModel? item}) {
    final foodItem = item ?? FoodItemModel(
      id: id,
      name: name,
      description: desc,
      price: double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 38.0,
    );
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/customer/food/item',
        arguments: {
          'item': foodItem,
          'restaurant': _restaurant ?? widget.restaurant,
          'cart': _cart,
          'menu': _menuItems.isNotEmpty ? _menuItems : FoodService.defaultBahamianMenu,
        },
      ),
      child: Container(
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: foodItem.photo != null && foodItem.photo!.isNotEmpty
                  ? Image.network(
                      foodItem.photo!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.cardTouchpoint,
                        child: const Icon(Icons.set_meal, color: AppColors.primaryTeal, size: 26),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: AppColors.cardTouchpoint,
                      child: const Icon(Icons.set_meal, color: AppColors.primaryTeal, size: 26),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 2),
                  Text(desc, style: AppTextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => _addItem(id),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color bg, Color text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: text, fontWeight: FontWeight.bold)),
  );
}
