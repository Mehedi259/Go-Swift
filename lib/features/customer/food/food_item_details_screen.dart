import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class FoodItemDetailsScreen extends StatefulWidget {
  const FoodItemDetailsScreen({super.key});
  @override State<FoodItemDetailsScreen> createState() => _FoodItemDetailsScreenState();
}

class _FoodItemDetailsScreenState extends State<FoodItemDetailsScreen> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
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
                  Center(child: Icon(Icons.set_meal, color: AppColors.primaryTeal.withValues(alpha: 0.4), size: 64)),
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
                      child: Text('CHEF CURATED SELECTION', style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    Text('Yellowfin Tuna Tartare', style: AppTextStyles.headlineLarge),
                    const SizedBox(height: 6),
                    Text(
                      'Bahamian wild-caught yellowfin tuna, avocado, crispy wonton chips, yuzu ponzu, microgreens, sesame oil, and island citrus zest.',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, size: 16, color: AppColors.gold),
                        const SizedBox(width: 4),
                        Text('320 cal', style: AppTextStyles.bodySmall),
                        const SizedBox(width: 16),
                        const Icon(Icons.eco, size: 16, color: AppColors.green),
                        const SizedBox(width: 4),
                        Text('Gluten-Free available', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Customize', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 12),
                    _option('Spice Level', ['Mild', 'Medium', 'Spicy']),
                    const SizedBox(height: 16),
                    _option('Add-ons', ['Extra Tuna (+\$12)', 'Truffle Oil (+\$8)', 'Caviar (+\$25)']),
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
              child: GSButton(label: 'Add to Order • \$${38 * _qty} →', onTap: () => Navigator.pushNamed(context, '/customer/food/cart')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(String title, List<String> opts) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: AppTextStyles.titleMedium),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: opts.map((o) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Text(o, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        )).toList(),
      ),
    ],
  );
}
