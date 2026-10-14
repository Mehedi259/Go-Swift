import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/auth_service.dart';

class FavoritesScreen extends StatefulWidget {
  final bool embedded;
  const FavoritesScreen({super.key, this.embedded = false});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final AuthService _authService = AuthService();
  Map<String, List<dynamic>> _favorites = {
    'rides': [],
    'food': [],
    'courier': [],
    'car_rentals': [],
    'properties': [],
  };
  bool _isLoading = true;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      final data = await _authService.getFavorites();
      if (mounted) {
        setState(() {
          _favorites = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFavorite(String serviceType, int objectId, String title) async {
    try {
      await _authService.toggleFavorite(serviceType: serviceType, objectId: objectId);
      if (mounted) {
        setState(() {
          _favorites[serviceType]?.removeWhere((item) => (item['id'] ?? item['object_id']) == objectId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed "$title" from favorites'),
            backgroundColor: AppColors.primaryNavy,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not update favorite: $e'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  int get _totalCount {
    return _favorites.values.fold<int>(0, (prev, list) => prev + list.length);
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Saved Favorites', style: AppTextStyles.headlineLarge),
                    const SizedBox(height: 2),
                    Text(
                      'Your verified island chauffeurs, dining & villas',
                      style: AppTextStyles.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryTeal),
                onPressed: _loadFavorites,
                tooltip: 'Refresh Favorites',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _filterChip('all', 'All ($_totalCount)'),
              const SizedBox(width: 8),
              _filterChip('rides', 'Rides (${_favorites['rides']?.length ?? 0})'),
              const SizedBox(width: 8),
              _filterChip('food', 'Dining (${_favorites['food']?.length ?? 0})'),
              const SizedBox(width: 8),
              _filterChip('properties', 'Villas (${_favorites['properties']?.length ?? 0})'),
              const SizedBox(width: 8),
              _filterChip('car_rentals', 'Fleet (${_favorites['car_rentals']?.length ?? 0})'),
              const SizedBox(width: 8),
              _filterChip('courier', 'Courier (${_favorites['courier']?.length ?? 0})'),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  color: AppColors.primaryTeal,
                  child: _totalCount == 0 ? _buildEmptyState() : _buildFavoritesList(),
                ),
        ),
      ],
    );

    return widget.embedded
        ? content
        : Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(child: content),
          );
  }

  Widget _filterChip(String key, String label) {
    final isSelected = _selectedCategory == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTeal : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primaryTeal : AppColors.border),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primaryTeal.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 2))] : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.badgeTeal,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_border_rounded, color: AppColors.primaryTeal, size: 40),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'No Saved Favorites Yet',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Bookmark your favorite chauffeurs, luxury dining, villas, and vehicle rentals to access them instantly.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/customer/hub'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Explore Concierge Services', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 36),
        Text('POPULAR TO EXPLORE', style: AppTextStyles.labelSmall),
        const SizedBox(height: 12),
        _suggestedTile(Icons.restaurant, 'Dune by Jean-Georges', 'Ocean Club • Fine French Dining', '/customer/food'),
        _suggestedTile(Icons.villa, 'The Ocean Club Villa', 'Paradise Island • Oceanfront Villa', '/customer/properties/search'),
        _suggestedTile(Icons.directions_car, 'Executive Sovereign Chauffeur', 'Cadillac Escalade ESV • Vetted Chauffeurs', '/customer/ride/booking'),
      ],
    );
  }

  Widget _suggestedTile(IconData icon, String title, String sub, String route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.badgeTeal, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primaryTeal, size: 22),
        ),
        title: Text(title, style: AppTextStyles.titleMedium),
        subtitle: Text(sub, style: AppTextStyles.bodySmall),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }

  Widget _buildFavoritesList() {
    final List<Widget> items = [];

    // Rides
    if (_selectedCategory == 'all' || _selectedCategory == 'rides') {
      final rides = _favorites['rides'] ?? [];
      if (rides.isNotEmpty) {
        items.add(_sectionTitle('Saved Chauffeurs & Drivers (${rides.length})'));
        for (final r in rides) {
          final id = (r['id'] is int ? r['id'] : int.tryParse('${r['id']}')) ?? 0;
          final title = r['display_name'] ?? r['business_name'] ?? r['legal_name'] ?? 'Executive Driver';
          final vehicle = '${r['vehicle_make'] ?? ''} ${r['vehicle_model'] ?? ''}'.trim();
          final sub = vehicle.isNotEmpty ? '$vehicle • VIP Chauffeur' : 'VIP Chauffeur';
          items.add(_liveFavCard(
            icon: Icons.person_rounded,
            title: title,
            subtitle: sub,
            detail: r['vehicle_category'] ?? 'Verified',
            serviceType: 'rides',
            objectId: id,
            onTap: () => Navigator.pushNamed(context, '/customer/ride/booking'),
          ));
        }
      }
    }

    // Food
    if (_selectedCategory == 'all' || _selectedCategory == 'food') {
      final food = _favorites['food'] ?? [];
      if (food.isNotEmpty) {
        items.add(_sectionTitle('Saved Dining & Delicacies (${food.length})'));
        for (final f in food) {
          final id = (f['id'] is int ? f['id'] : int.tryParse('${f['id']}')) ?? 0;
          final title = f['name'] ?? 'Delicacy Item';
          final rest = f['restaurant'] is Map ? (f['restaurant']['restaurant_name'] ?? 'Restaurant') : 'Gourmet Dining';
          final price = f['price'] != null ? '\$${f['price']}' : '';
          items.add(_liveFavCard(
            icon: Icons.restaurant_rounded,
            title: title,
            subtitle: '$rest',
            detail: price,
            serviceType: 'food',
            objectId: id,
            onTap: () => Navigator.pushNamed(context, '/customer/food'),
          ));
        }
      }
    }

    // Properties
    if (_selectedCategory == 'all' || _selectedCategory == 'properties') {
      final props = _favorites['properties'] ?? [];
      if (props.isNotEmpty) {
        items.add(_sectionTitle('Saved Villas & Properties (${props.length})'));
        for (final p in props) {
          final id = (p['id'] is int ? p['id'] : int.tryParse('${p['id']}')) ?? 0;
          final title = p['title'] ?? 'Luxury Property';
          final region = p['island_region'] ?? 'Nassau & Paradise Island';
          final rate = p['nightly_base_rate'] != null ? '\$${p['nightly_base_rate']}/night' : 'Luxury Stay';
          items.add(_liveFavCard(
            icon: Icons.villa_rounded,
            title: title,
            subtitle: '$region • ${p['bedrooms'] ?? 3} Beds',
            detail: rate,
            serviceType: 'properties',
            objectId: id,
            onTap: () => Navigator.pushNamed(context, '/customer/properties/search'),
          ));
        }
      }
    }

    // Car Rentals
    if (_selectedCategory == 'all' || _selectedCategory == 'car_rentals') {
      final cars = _favorites['car_rentals'] ?? [];
      if (cars.isNotEmpty) {
        items.add(_sectionTitle('Saved Luxury Fleet (${cars.length})'));
        for (final c in cars) {
          final id = (c['id'] is int ? c['id'] : int.tryParse('${c['id']}')) ?? 0;
          final title = c['name'] ?? '${c['make'] ?? ''} ${c['model'] ?? ''}'.trim();
          final loc = c['location'] ?? 'Cable Beach Fleet Hub';
          final rate = c['daily_rate'] != null ? '\$${c['daily_rate']}/day' : 'Fleet';
          items.add(_liveFavCard(
            icon: Icons.directions_car_filled_rounded,
            title: title.isNotEmpty ? title : 'Luxury Vehicle',
            subtitle: '$loc',
            detail: rate,
            serviceType: 'car_rentals',
            objectId: id,
            onTap: () => Navigator.pushNamed(context, '/customer/car-rental/search'),
          ));
        }
      }
    }

    // Courier
    if (_selectedCategory == 'all' || _selectedCategory == 'courier') {
      final couriers = _favorites['courier'] ?? [];
      if (couriers.isNotEmpty) {
        items.add(_sectionTitle('Saved Courier Couriers (${couriers.length})'));
        for (final c in couriers) {
          final id = (c['id'] is int ? c['id'] : int.tryParse('${c['id']}')) ?? 0;
          final title = c['display_name'] ?? c['business_name'] ?? 'Express Courier';
          final zone = c['operating_island_zone'] ?? 'Nassau Zone';
          items.add(_liveFavCard(
            icon: Icons.local_shipping_rounded,
            title: title,
            subtitle: '$zone • ${c['transport_mode'] ?? 'Express'}',
            detail: 'Bonded',
            serviceType: 'courier',
            objectId: id,
            onTap: () => Navigator.pushNamed(context, '/customer/courier/request'),
          ));
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: items,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Text(title, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
    );
  }

  Widget _liveFavCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String detail,
    required String serviceType,
    required int objectId,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.badgeTeal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primaryTeal, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (detail.isNotEmpty)
                      Text(
                        detail,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => _removeFavorite(serviceType, objectId, title),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.red.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_rounded, color: AppColors.red, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
