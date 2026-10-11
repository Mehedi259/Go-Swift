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
  List<dynamic> _apiFavorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final list = await _authService.getFavorites();
      if (mounted) {
        setState(() {
          _apiFavorites = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Text('Saved Favorites', style: AppTextStyles.headlineLarge),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Text('Your saved restaurants, drivers & properties', style: AppTextStyles.bodyMedium),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    if (_apiFavorites.isNotEmpty) ...[
                      _sectionHeader('Online Saved Items (${_apiFavorites.length})'),
                      const SizedBox(height: 10),
                      ..._apiFavorites.map((f) => _favCard(
                            context,
                            Icons.star_rounded,
                            f is Map ? (f['title'] ?? f['name'] ?? 'Favorite Item').toString() : f.toString(),
                            'Verified Favorite',
                            'Saved',
                            '/customer/hub',
                          )),
                      const SizedBox(height: 18),
                    ],
                    _sectionHeader('Saved Restaurants'),
                    const SizedBox(height: 10),
                    _favCard(context, Icons.restaurant, 'Dune by Jean-Georges', 'Ocean Club • 4.9 ★', '\$\$\$\$', '/customer/food/restaurant'),
                    _favCard(context, Icons.restaurant, 'Nobu Bahamas', 'Atlantis • 4.9 ★', '\$\$\$\$', '/customer/food/restaurant'),
                    const SizedBox(height: 18),
                    _sectionHeader('Saved Properties'),
                    const SizedBox(height: 10),
                    _favCard(context, Icons.villa, 'The Ocean Club Villa', 'Paradise Island • 4.98 ★', '\$1,850/night', '/customer/properties/details'),
                    _favCard(context, Icons.villa, 'Lyford Cay Estate', 'Lyford Cay • 5.0 ★', '\$4,500/night', '/customer/properties/details'),
                    const SizedBox(height: 18),
                    _sectionHeader('Saved Drivers'),
                    const SizedBox(height: 10),
                    _favCard(context, Icons.person, 'Captain Terrence Rolle', 'VIP Chauffeur • 4.98 ★', '620+ trips', '/customer/ride/booking'),
                    const SizedBox(height: 20),
                  ],
                ),
        ),
      ],
    );
    return widget.embedded ? content : Scaffold(backgroundColor: AppColors.background, body: SafeArea(child: content));
  }

  Widget _sectionHeader(String title) => Text(title, style: AppTextStyles.headlineSmall);

  Widget _favCard(BuildContext context, IconData icon, String name, String sub, String detail, String route) => GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: AppColors.badgeTeal, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: AppColors.primaryTeal, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 2),
                    Text(sub, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(detail, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Icon(Icons.favorite, color: AppColors.red, size: 20),
                ],
              ),
            ],
          ),
        ),
      );
}
