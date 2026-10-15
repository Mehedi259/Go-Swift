import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/services/food_service.dart';
import '../../../core/widgets/gs_button.dart';

class ProviderFoodItemDetailScreen extends StatefulWidget {
  final FoodItemModel item;
  final List<dynamic>? categories;

  const ProviderFoodItemDetailScreen({
    super.key,
    required this.item,
    this.categories,
  });

  @override
  State<ProviderFoodItemDetailScreen> createState() => _ProviderFoodItemDetailScreenState();
}

class _ProviderFoodItemDetailScreenState extends State<ProviderFoodItemDetailScreen> {
  final FoodService _foodService = FoodService();
  late FoodItemModel _item;
  late bool _availableToday;
  bool _isToggling = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _availableToday = widget.item.availableToday;
  }

  Future<void> _toggleAvailability(bool val) async {
    if (_isToggling) return;
    setState(() {
      _isToggling = true;
      _availableToday = val;
    });

    try {
      final updated = await _foodService.updateFoodItem(_item.id, isAvailable: val);
      if (mounted) {
        setState(() {
          _item = updated;
          _availableToday = updated.availableToday;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(val ? 'Dish is now Available for Orders' : 'Dish marked as Sold Out'),
            backgroundColor: val ? AppColors.primaryTeal : Colors.orange.shade800,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _availableToday = !val);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isToggling = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Culinary Dish?'),
        content: Text('Are you sure you want to remove "${_item.name}" from your active restaurant menu? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete Dish', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);
    try {
      await _foodService.deleteFoodItem(_item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dish removed from menu'),
            backgroundColor: AppColors.primaryTeal,
          ),
        );
        Navigator.pop(context, true); // true indicates changed/deleted
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDeleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  List<String> _extractIngredients(String description) {
    if (description.isEmpty) return [];
    // Split by commas or common culinary separators
    final rawParts = description
        .split(RegExp(r'[,;•\n]|(?:\band\b)'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && s.length > 2)
        .toList();
    return rawParts;
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = _extractIngredients(_item.description ?? '');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Hero Image Banner
                    Stack(
                      children: [
                        Container(
                          height: 280,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFE8F4F8), Color(0xFFD6EDF4)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: (_item.photo != null && _item.photo!.isNotEmpty)
                              ? Image.network(
                                  _item.photo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _buildFallbackHero(),
                                )
                              : _buildFallbackHero(),
                        ),
                        // Dark Gradient for header readability
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.55),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.70),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        // Back Button & Top Actions
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          left: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context, true),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                shape: BoxShape.circle,
                                boxShadow: AppColors.cardShadow,
                              ),
                              child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 22),
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          right: 16,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: _isDeleting ? null : _confirmDelete,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    shape: BoxShape.circle,
                                    boxShadow: AppColors.cardShadow,
                                  ),
                                  child: _isDeleting
                                      ? const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                                        )
                                      : const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Category and Status badge on Hero Image bottom
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryTeal,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: AppColors.cardShadow,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.restaurant, color: Colors.white, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      _item.categoryName ?? 'Culinary Specialty',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _availableToday ? const Color(0xFF10B981) : Colors.red.shade600,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: AppColors.cardShadow,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _availableToday ? Icons.check_circle : Icons.do_not_disturb_on,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _availableToday ? 'Available Today' : 'Sold Out',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Main Content Details
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Price Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  _item.name,
                                  style: AppTextStyles.headlineLarge.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFBBF7D0)),
                                ),
                                child: Text(
                                  '\$${_item.price.toStringAsFixed(2)}',
                                  style: AppTextStyles.price.copyWith(
                                    fontSize: 22,
                                    color: const Color(0xFF15803D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Quick Badges Row (Prep Time, Currency, Island Hub)
                          Row(
                            children: [
                              _buildMetricChip(
                                icon: Icons.timer_outlined,
                                label: _item.prepWindow?.isNotEmpty == true ? _item.prepWindow! : '15-20 mins',
                                color: AppColors.primaryTeal,
                              ),
                              const SizedBox(width: 10),
                              _buildMetricChip(
                                icon: Icons.monetization_on_outlined,
                                label: '${_item.currency} Currency',
                                color: const Color(0xFF8A5300),
                              ),
                              const SizedBox(width: 10),
                              _buildMetricChip(
                                icon: Icons.delivery_dining,
                                label: 'Yacht & Villa Dispatch',
                                color: const Color(0xFF0284C7),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Live Availability Switch Card
                          Container(
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
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: (_availableToday ? AppColors.primaryTeal : Colors.grey).withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _availableToday ? Icons.restaurant_menu : Icons.no_meals,
                                    color: _availableToday ? AppColors.primaryTeal : Colors.grey,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kitchen Ordering Status',
                                        style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _availableToday
                                            ? 'Currently active. Customers can order this dish.'
                                            : 'Marked 86/Sold out. Hidden from customer orders.',
                                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: _availableToday,
                                  activeColor: AppColors.primaryTeal,
                                  onChanged: _isToggling ? null : _toggleAvailability,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Culinary Description Section
                          Text('Culinary Concept & Description', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.format_quote, color: AppColors.primaryTeal.withValues(alpha: 0.7), size: 24),
                                    const SizedBox(width: 6),
                                    Text('Executive Chef Note', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _item.description?.isNotEmpty == true
                                      ? _item.description!
                                      : 'Specially crafted island dish featuring freshly sourced Bahamian ingredients, prepared with refined culinary expertise.',
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Ingredients Breakdown Section
                          Row(
                            children: [
                              Text('Key Ingredients & Composition', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.badgeTeal,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text('${ingredients.length} items', style: AppTextStyles.caption.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: ingredients.isNotEmpty
                                ? Column(
                                    children: ingredients.map((ing) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF0FDF4),
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: const Color(0xFFBBF7D0)),
                                              ),
                                              child: const Icon(Icons.check, size: 14, color: Color(0xFF15803D)),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                ing,
                                                style: AppTextStyles.bodyMedium.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8FAFC),
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                              ),
                                              child: Text('Fresh / Organic', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  )
                                : Row(
                                    children: [
                                      const Icon(Icons.info_outline, color: AppColors.textSecondary, size: 18),
                                      const SizedBox(width: 8),
                                      Text('Full ingredient list detailed in culinary description.', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 24),

                          // Dietary & Specialty Badges Section
                          if (_item.dietaryTags.isNotEmpty) ...[
                            Text('Dietary & Specialty Badges', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _item.dietaryTags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDFA),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFF99F6E4)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.verified, size: 14, color: AppColors.primaryTeal),
                                      const SizedBox(width: 6),
                                      Text(
                                        tag,
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: AppColors.primaryTeal,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Dispatch Information Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.soup_kitchen_outlined, color: AppColors.primaryTeal, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Temperature-Sealed Packaging', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Dispatched via temperature-controlled courier boxes to maintain presentation and thermal integrity.',
                                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Actions Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: AppColors.border)),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GSButton(
                      label: _availableToday ? 'Mark as Sold Out' : 'Mark Available',
                      isSecondary: true,
                      isLoading: _isToggling,
                      onTap: () => _toggleAvailability(!_availableToday),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GSButton(
                      label: 'Back to Menu',
                      onTap: () => Navigator.pop(context, true),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackHero() {
    return Container(
      color: const Color(0xFFE8F4F8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, color: AppColors.primaryTeal.withValues(alpha: 0.5), size: 64),
            const SizedBox(height: 8),
            Text(
              'Gourmet Culinary Offering',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryTeal.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip({required IconData icon, required String label, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
