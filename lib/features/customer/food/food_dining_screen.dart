import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/food_service.dart';
import '../../../core/widgets/gs_card.dart';
import '../../../core/widgets/gs_bottom_nav.dart';

class FoodDiningScreen extends StatefulWidget {
  const FoodDiningScreen({super.key});
  @override
  State<FoodDiningScreen> createState() => _FoodDiningScreenState();
}

class _FoodDiningScreenState extends State<FoodDiningScreen> {
  int _cat = 0;
  final _cats = ['All Restaurants', 'Bahamian Seafood', 'Fine Dining', 'Japanese', 'Caribbean'];
  List<RestaurantModel> _liveRestaurants = [];
  bool _isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  bool _filterTopRated = false;
  bool _filterUnder35m = false;
  bool _filterMarinaDelivery = false;

  final Set<int> _favoriteIds = {};
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final q = _searchController.text.trim().toLowerCase();
      if (q != _searchQuery) {
        setState(() => _searchQuery = q);
      }
    });
    _fetchRestaurants();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  Future<void> _loadFavorites() async {
    try {
      final favs = await _authService.getFavorites();
      final foodFavs = favs['food'] ?? [];
      final Set<int> ids = {};
      for (final f in foodFavs) {
        final id = f['id'] is int ? f['id'] as int : int.tryParse(f['id']?.toString() ?? '') ?? 0;
        if (id > 0) ids.add(id);
        if (f['restaurant'] is Map && f['restaurant']['id'] != null) {
          final restId = f['restaurant']['id'] is int
              ? f['restaurant']['id'] as int
              : int.tryParse(f['restaurant']['id'].toString()) ?? 0;
          if (restId > 0) ids.add(restId);
        }
      }
      if (mounted) {
        setState(() => _favoriteIds.addAll(ids));
      }
    } catch (_) {}
  }

  Future<void> _toggleFavorite(int id, String name) async {
    final wasFavorited = _favoriteIds.contains(id);
    setState(() {
      if (wasFavorited) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });

    try {
      final res = await _authService.toggleFavorite(
        serviceType: 'food',
        objectId: id,
      );
      final isFav = res['is_favorited'] == true;
      if (mounted) {
        setState(() {
          if (isFav) {
            _favoriteIds.add(id);
          } else {
            _favoriteIds.remove(id);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFav ? 'Added "$name" to favorites' : 'Removed "$name" from favorites'),
            backgroundColor: isFav ? AppColors.primaryTeal : AppColors.textSecondary,
            duration: const Duration(milliseconds: 1400),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (wasFavorited) {
            _favoriteIds.add(id);
          } else {
            _favoriteIds.remove(id);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update favorite: $e'),
            backgroundColor: AppColors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> get _displayList {
    final fallbackPhotos = [
      'https://goswift-media-prod.s3.us-east-1.amazonaws.com/food/items/lobster.jpg',
      'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80',
    ];

    final source = _liveRestaurants.isNotEmpty
        ? _liveRestaurants.map((r) {
            final locParts = [
              if (r.islandHub != null && r.islandHub!.trim().isNotEmpty) r.islandHub!.trim(),
              if (r.address != null && r.address!.trim().isNotEmpty) r.address!.trim(),
            ];
            final location = locParts.isNotEmpty ? locParts.join(' • ') : 'Nassau & Paradise Island';

            final isChefCurated = r.id == 1 || r.name.toLowerCase().contains('ocean club');
            final badge = isChefCurated ? 'CHEF CURATED' : 'VERIFIED';
            final concept = (r.cuisineConcept != null && r.cuisineConcept!.trim().isNotEmpty)
                ? r.cuisineConcept!.trim().toUpperCase()
                : 'FINE BAHAMIAN & HAUTE DINING';
            final prepTime = (r.averagePrepWindow != null && r.averagePrepWindow!.trim().isNotEmpty)
                ? r.averagePrepWindow!.trim()
                : '20-30 min';

            final double rating = r.rating > 0.0 ? r.rating : (isChefCurated ? 5.0 : 0.0);
            final int reviews = r.reviewsCount > 0 ? r.reviewsCount : (isChefCurated ? 85 : 0);

            final photoUrl = (r.photo != null && r.photo!.trim().isNotEmpty)
                ? r.photo!
                : fallbackPhotos[r.id % fallbackPhotos.length];

            return {
              'id': r.id,
              'name': r.name.isNotEmpty ? r.name : 'Exclusive Dining',
              'type': concept,
              'location': location,
              'rating': rating,
              'reviews': reviews,
              'time': prepTime,
              'badge': badge,
              'price': '\$\$\$\$',
              'special': 'Dockside Ready',
              'feature': 'Free Yacht Delivery',
              'model': r,
              'photo': photoUrl,
            };
          }).toList()
        : _restaurants;

    return source.where((item) {
      final name = (item['name'] as String? ?? '').toLowerCase();
      final type = (item['type'] as String? ?? '').toLowerCase();
      final loc = (item['location'] as String? ?? '').toLowerCase();
      final time = (item['time'] as String? ?? '').toLowerCase();
      final special = (item['special'] as String? ?? '').toLowerCase();
      final feature = (item['feature'] as String? ?? '').toLowerCase();
      final double rating = (item['rating'] as num? ?? 0.0).toDouble();
      final int reviews = (item['reviews'] as num? ?? 0).toInt();

      // Search bar filter
      if (_searchQuery.isNotEmpty) {
        final matches = name.contains(_searchQuery) ||
            type.contains(_searchQuery) ||
            loc.contains(_searchQuery) ||
            time.contains(_searchQuery) ||
            special.contains(_searchQuery) ||
            feature.contains(_searchQuery);
        if (!matches) return false;
      }

      // Category filter
      if (_cat > 0 && _cat < _cats.length) {
        final catKey = _cats[_cat].toLowerCase();
        if (catKey.contains('seafood')) {
          if (!type.contains('seafood') && !name.contains('seafood') && !type.contains('bahamian')) return false;
        } else if (catKey.contains('fine dining')) {
          if (!type.contains('fine dining') && !type.contains('haute') && !type.contains('chef')) return false;
        } else if (catKey.contains('japanese')) {
          if (!type.contains('japanese') && !type.contains('sushi') && !type.contains('asian')) return false;
        } else if (catKey.contains('caribbean')) {
          if (!type.contains('caribbean') && !type.contains('island') && !loc.contains('nassau')) return false;
        }
      }

      // Quick filter chips
      if (_filterTopRated) {
        if (rating < 4.8 && reviews == 0 && item['badge'] != 'CHEF CURATED') return false;
      }
      if (_filterUnder35m) {
        final isFast = time.contains('10') || time.contains('15') || time.contains('20') || time.contains('25') || time.contains('30');
        if (!isFast) return false;
      }
      if (_filterMarinaDelivery) {
        final isMarina = special.contains('dockside') || feature.contains('yacht') || loc.contains('paradise') || loc.contains('marina');
        if (!isMarina) return false;
      }

      return true;
    }).toList();
  }

  final _restaurants = [
    {
      'id': 1,
      'name': 'The Ocean Club Restaurant',
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
    final list = _displayList;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header (Back button, Title, Notification icon - profile avatar removed per user request)
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
                ],
              ),
            ),
            // Search Bar (full-width functional search with clear button, settings/tune icon removed per user request)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: TextFormField(
                controller: _searchController,
                style: AppTextStyles.bodyLarge,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search restaurants, cuisines, dishes...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: const Icon(Icons.close, color: AppColors.textSecondary, size: 18),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
                  ),
                ),
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
            // Filter chips row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _filterChip(
                      label: 'Top Rated',
                      icon: Icons.star,
                      isActive: _filterTopRated,
                      onTap: () => setState(() => _filterTopRated = !_filterTopRated),
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      label: 'Under 35m',
                      icon: Icons.access_time,
                      isActive: _filterUnder35m,
                      onTap: () => setState(() => _filterUnder35m = !_filterUnder35m),
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      label: 'Marina Delivery',
                      icon: Icons.sailing,
                      isActive: _filterMarinaDelivery,
                      onTap: () => setState(() => _filterMarinaDelivery = !_filterMarinaDelivery),
                    ),
                    if (_filterTopRated || _filterUnder35m || _filterMarinaDelivery || _cat > 0 || _searchQuery.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _filterTopRated = false;
                            _filterUnder35m = false;
                            _filterMarinaDelivery = false;
                            _cat = 0;
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.clear_all, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text('Reset', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Restaurant list or empty state
            Expanded(
              child: _isLoading && _liveRestaurants.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
                  : RefreshIndicator(
                      onRefresh: () async {
                        await _fetchRestaurants();
                        await _loadFavorites();
                      },
                      color: AppColors.primaryTeal,
                      child: list.isEmpty
                          ? ListView(
                              padding: const EdgeInsets.all(32),
                              children: [
                                const SizedBox(height: 48),
                                Center(
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryTeal.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.restaurant_outlined, size: 32, color: AppColors.primaryTeal),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: Text('No Restaurants Found', style: AppTextStyles.headlineSmall),
                                ),
                                const SizedBox(height: 8),
                                Center(
                                  child: Text(
                                    _searchQuery.isNotEmpty
                                        ? 'No dining options match "$_searchQuery".'
                                        : 'No restaurants match the active filters.',
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = '';
                                        _cat = 0;
                                        _filterTopRated = false;
                                        _filterUnder35m = false;
                                        _filterMarinaDelivery = false;
                                      });
                                    },
                                    icon: const Icon(Icons.refresh, size: 16, color: AppColors.primaryTeal),
                                    label: Text('Reset Filters', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal)),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                              itemCount: list.length,
                              itemBuilder: (c, i) {
                                final data = list[i];
                                final int rid = data['id'] as int;
                                final bool isFav = _favoriteIds.contains(rid);
                                return _RestaurantCard(
                                  data: data,
                                  isFavorited: isFav,
                                  onToggleFavorite: () => _toggleFavorite(rid, data['name'] as String),
                                );
                              },
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

  Widget _filterChip({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryTeal : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? AppColors.primaryTeal : AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isActive ? Colors.white : AppColors.primaryTeal),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isActive ? Colors.white : AppColors.textPrimary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

class _RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isFavorited;
  final VoidCallback onToggleFavorite;

  const _RestaurantCard({
    required this.data,
    required this.isFavorited,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final photoUrl = data['photo'] as String?;
    final double rating = (data['rating'] as num? ?? 0.0).toDouble();
    final int reviews = (data['reviews'] as num? ?? 0).toInt();

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
                        errorBuilder: (_, __, _) => Container(
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
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onToggleFavorite,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            shape: BoxShape.circle,
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Center(
                            child: Icon(
                              isFavorited ? Icons.favorite : Icons.favorite_border,
                              color: isFavorited ? const Color(0xFFE53935) : AppColors.primaryTeal,
                              size: 18,
                            ),
                          ),
                        ),
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
                        child: GSRatingRow(rating: rating, reviews: reviews),
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
