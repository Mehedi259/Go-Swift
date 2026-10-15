import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/services/food_service.dart';
import '../../../core/widgets/gs_card.dart';
import '../../../core/widgets/gs_bottom_nav.dart';

class FoodDiningScreen extends StatefulWidget {
  const FoodDiningScreen({super.key});
  @override State<FoodDiningScreen> createState() => _FoodDiningScreenState();
}

class _FoodDiningScreenState extends State<FoodDiningScreen> {
  int _cat = 0;
  final _cats = ['All Restaurants', 'Bahamian Seafood', 'Fine Dining', 'Japanese', 'Caribbean'];
  List<RestaurantModel> _liveRestaurants = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    setState(() => _isLoading = true);
    try {
      final list = await FoodService().getRestaurants();
      if (mounted) {
        setState(() {
          _liveRestaurants = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _displayList {
    if (_liveRestaurants.isNotEmpty) {
      return _liveRestaurants.map((r) => {
        'id': r.id,
        'name': r.name,
        'type': (r.cuisineConcept ?? 'FINE DINING').toUpperCase(),
        'location': '${r.islandHub ?? "Nassau"} • ${r.address ?? "Paradise Island"}',
        'rating': r.rating,
        'reviews': r.id == 1 ? 85 : 120,
        'time': r.averagePrepWindow ?? '20-30 min',
        'badge': r.id == 1 ? 'CHEF CURATED' : 'VERIFIED',
        'price': '\$\$\$\$',
        'special': 'Dockside Ready',
        'feature': 'Free Yacht Delivery',
        'model': r,
        'photo': r.id == 1
            ? 'https://goswift-media-prod.s3.us-east-1.amazonaws.com/food/items/lobster.jpg'
            : 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80',
      }).toList();
    }
    return _restaurants;
  }

  final _restaurants = [
    {
      'id': 1,
      'name': 'cheta',
      'type': 'FINE BAHAMIAN & HAUTE SEAFOOD',
      'location': 'Ocean Club Drive, Paradise Island • 1.2 miles',
      'rating': 5.0,
      'reviews': 85,
      'time': '20-30 min',
      'badge': 'CHEF CURATED',
      'price': '\$\$\$\$',
      'special': 'Dockside Ready',
      'feature': 'Free Yacht Delivery',
      'photo': 'https://goswift-media-prod.s3.us-east-1.amazonaws.com/food/items/lobster.jpg',
    },
    {
      'id': 2,
      'name': 'Dune by Jean-Georges',
      'type': 'FRENCH-ASIAN FUSION • FINE DINING',
      'location': 'Ocean Club, Paradise Island • 3.2 miles',
      'rating': 4.9,
      'reviews': 280,
      'time': '30-40 min',
      'badge': 'OCEAN CLUB',
      'price': '\$\$\$\$',
      'special': 'Dockside Ready',
      'feature': 'Free Yacht Delivery',
      'photo': 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80',
    },
    {
      'id': 3,
      'name': 'Nobu Bahamas',
      'type': 'JAPANESE • SUSHI & OMAKASE',
      'location': 'Atlantis, Paradise Island • 2.8 miles',
      'rating': 4.9,
      'reviews': 410,
      'time': '25-35 min',
      'badge': 'ATLANTIS RESORT',
      'price': '\$\$\$\$',
      'special': 'Thermal Vaulted',
      'feature': 'Omakase Available',
      'photo': 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=800&q=80',
    },
    {
      'id': 4,
      'name': 'Graycliff Restaurant',
      'type': 'HERITAGE CARIBBEAN • WINE CELLAR',
      'location': 'Downtown Nassau • 1.9 miles',
      'rating': 4.8,
      'reviews': 190,
      'time': '35-45 min',
      'badge': 'HISTORIC NASSAU',
      'price': '\$\$\$\$',
      'special': 'Sommelier Paired',
      'feature': 'Grand Award Cellar',
      'photo': 'https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?auto=format&fit=crop&w=800&q=80',
    },
    {
      'id': 5,
      'name': 'Sapodilla Estate',
      'type': 'BAHAMIAN CONTINENTAL • FINE DINING',
      'location': 'West Bay Street • 5.4 miles',
      'rating': 4.8,
      'reviews': 140,
      'time': '40-50 min',
      'badge': 'WEST BAY',
      'price': '\$\$\$\$',
      'special': 'Villa Catering Spec',
      'feature': 'Private Chef Kit',
      'photo': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80',
    },
    {
      'id': 6,
      'name': 'Katsuya Baha Mar',
      'type': 'MODERN JAPANESE & ROBATA',
      'location': 'Cable Beach • 4.1 miles',
      'rating': 4.7,
      'reviews': 220,
      'time': '30-40 min',
      'badge': 'BAHA MAR RESORT',
      'price': '\$\$\$',
      'special': 'Swift Priority',
      'feature': 'Cocktail Pairing',
      'photo': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Food & Dining', style: AppTextStyles.headlineLarge.copyWith(fontSize: 20)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 12, color: AppColors.primaryTeal),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Delivering to: Albany Marina ▾',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/customer/notifications'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: const Icon(Icons.notifications_none_outlined, color: AppColors.textPrimary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: AppTextStyles.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: 'Search restaurants, cuisines, dishes...',
                        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            // Yacht delivery banner
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.cardTouchpoint,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sailing, color: AppColors.primaryTeal, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Yacht Dock & Private Villa Delivery', style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          Text('White-glove Butler Handover • Climate Vaulted', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Category tabs
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                itemCount: _cats.length,
                itemBuilder: (c, i) => GestureDetector(
                  onTap: () => setState(() => _cat = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: _cat == i ? AppColors.primaryTeal : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _cat == i ? AppColors.primaryTeal : AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Center(
                      child: Text(
                        _cats[i],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _cat == i ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Filters
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _filter('Top Rated', Icons.star),
                    const SizedBox(width: 8),
                    _filter('Under 35m', Icons.access_time),
                    const SizedBox(width: 8),
                    _filter('Marina Delivery', Icons.sailing),
                  ],
                ),
              ),
            ),
            // Restaurant list
            Expanded(
              child: _isLoading && _liveRestaurants.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
                  : RefreshIndicator(
                      onRefresh: _fetchRestaurants,
                      color: AppColors.primaryTeal,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        itemCount: _displayList.length,
                        itemBuilder: (c, i) => _RestaurantCard(data: _displayList[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GSBottomNav(
        currentIndex: 0,
        onTap: (idx) {
          if (idx == 0) {
            Navigator.pop(context);
          } else if (idx == 1) {
            Navigator.pushNamed(context, '/customer/history');
          } else if (idx == 2) {
            Navigator.pushNamed(context, '/customer/favorites');
          } else if (idx == 3) {
            Navigator.pushNamed(context, '/customer/support');
          } else if (idx == 4) {
            Navigator.pushNamed(context, '/customer/profile');
          }
        },
      ),
    );
  }

  Widget _filter(String label, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.cardShadow,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.primaryTeal),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
      ],
    ),
  );
}

class _RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _RestaurantCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final photoUrl = data['photo'] as String?;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/customer/food/restaurant',
        arguments: data['model'] ?? data['id'],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image card header
            Container(
              height: 140,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (photoUrl != null && photoUrl.isNotEmpty)
                      Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xFFE8F4F8), Color(0xFFD6EDF4)]),
                          ),
                          child: const Icon(Icons.restaurant, color: AppColors.primaryTeal, size: 48),
                        ),
                      )
                    else
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFFE8F4F8), Color(0xFFD6EDF4)]),
                        ),
                        child: const Icon(Icons.restaurant, color: AppColors.primaryTeal, size: 48),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(data['badge'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 6),
                            Text(data['price'] as String, style: AppTextStyles.labelSmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Icon(Icons.favorite_border, color: AppColors.primaryTeal, size: 16),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(data['type'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: GSRatingRow(rating: data['rating'] as double, reviews: data['reviews'] as int),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(data['name'] as String, style: AppTextStyles.headlineSmall)),
                      const Icon(Icons.chevron_right, color: AppColors.primaryTeal, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(child: Text(data['location'] as String, style: AppTextStyles.bodySmall)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(data['time'] as String, style: AppTextStyles.bodySmall),
                      const SizedBox(width: 14),
                      const Icon(Icons.anchor, size: 14, color: AppColors.primaryTeal),
                      const SizedBox(width: 4),
                      Text(data['special'] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.restaurant_menu, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('Chef Curated: ${data['feature']}', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
