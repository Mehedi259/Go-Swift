import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/widgets/gs_button.dart';

class RestaurantProfileScreen extends StatefulWidget {
  const RestaurantProfileScreen({super.key});

  @override
  State<RestaurantProfileScreen> createState() => _RestaurantProfileScreenState();
}

class _RestaurantProfileScreenState extends State<RestaurantProfileScreen> {
  final ProviderApplicationService _providerService = ProviderApplicationService();
  String _name = 'Dune by Jean-Georges';
  String _concept = 'Fine French-Asian Dining';
  String _location = 'Ocean Club, Paradise Island';
  String _phone = '+1 (242) 363-2501';
  String _hours = 'Open Daily: 11:30 AM – 11:00 PM';
  String _vat = 'BAH-VAT-89214-FS';
  bool _accepting = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final p = await _providerService.getRestaurantProfile();
      if (mounted && p.isNotEmpty) {
        setState(() {
          if (p['restaurant_name'] != null && (p['restaurant_name'] as String).isNotEmpty) {
            _name = p['restaurant_name'];
          }
          if (p['cuisine_concept'] != null) {
            _concept = p['cuisine_concept'];
          }
          if (p['island_service_hub'] != null) {
            _location = p['island_service_hub'];
          }
          if (p['commercial_line'] != null) {
            _phone = p['commercial_line'];
          }
          if (p['business_license_number'] != null) {
            _vat = p['business_license_number'];
          }
          if (p['accepting_orders'] != null) {
            _accepting = p['accepting_orders'] == true;
          }
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Restaurant Profile', style: AppTextStyles.titleLarge),
        centerTitle: false,
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.cyanLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cyan, width: 2),
                    ),
                    child: const Icon(Icons.restaurant, color: AppColors.cyan, size: 36),
                  ),
                  const SizedBox(height: 12),
                  Text(_name, style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 2),
                  Text(_concept, style: AppTextStyles.cyanLabel),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 16),
                      const SizedBox(width: 4),
                      Text('4.9 ★ • $_location', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _infoTile(Icons.power_settings_new, 'Dispatch Status', _accepting ? 'Live & Accepting Orders' : 'Paused / Offline'),
            _infoTile(Icons.storefront_outlined, 'Business Hours', _hours),
            _infoTile(Icons.phone_outlined, 'Commercial Line', _phone),
            _infoTile(Icons.payment, 'Payout Account', 'FirstCaribbean Bank • ••••4102'),
            _infoTile(Icons.receipt_long_outlined, 'Business License / VAT', _vat),
            const SizedBox(height: 24),
            GSButton(label: 'Edit Restaurant Info', isSecondary: true, onTap: () {}),
            const SizedBox(height: 12),
            GSButton(
              label: 'Sign Out',
              isSecondary: true,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/choose-account', (_) => false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String val) => Container(
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
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.cyan, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 2),
                  Text(val, style: AppTextStyles.titleMedium),
                ],
              ),
            ),
          ],
        ),
      );
}
