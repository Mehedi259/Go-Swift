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
          if (p['operating_hours'] != null && (p['operating_hours'] as String).isNotEmpty) {
            _hours = p['operating_hours'];
          }
        });
      }
    } catch (_) {}
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _name);
    final conceptCtrl = TextEditingController(text: _concept);
    final locationCtrl = TextEditingController(text: _location);
    final phoneCtrl = TextEditingController(text: _phone);
    final hoursCtrl = TextEditingController(text: _hours);
    bool accepting = _accepting;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (modalContext, setModalState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Edit Restaurant Profile', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 6),
                Text('Update culinary operations and customer contact info', style: AppTextStyles.bodySmall),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Restaurant Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: conceptCtrl,
                  decoration: const InputDecoration(labelText: 'Cuisine Concept', hintText: 'e.g. Fine French-Asian Dining'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationCtrl,
                  decoration: const InputDecoration(labelText: 'Island Hub / Location', hintText: 'e.g. Ocean Club, Paradise Island'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Commercial Phone'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hoursCtrl,
                  decoration: const InputDecoration(labelText: 'Business Hours', hintText: 'e.g. Open Daily: 11:30 AM – 11:00 PM'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.cyan,
                  title: Text('Accepting Dispatch Orders', style: AppTextStyles.titleMedium),
                  subtitle: Text('Toggle availability in the customer food catalog', style: AppTextStyles.bodySmall),
                  value: accepting,
                  onChanged: (val) => setModalState(() => accepting = val),
                ),
                const SizedBox(height: 20),
                GSButton(
                  label: 'Save Changes',
                  isLoading: isSaving,
                  onTap: () async {
                    setModalState(() => isSaving = true);
                    try {
                      await _providerService.updateRestaurantProfile(
                        restaurantName: nameCtrl.text.trim(),
                        cuisineConcept: conceptCtrl.text.trim(),
                        islandServiceHub: locationCtrl.text.trim(),
                        commercialLine: phoneCtrl.text.trim(),
                        contactPhone: phoneCtrl.text.trim(),
                        operatingHours: hoursCtrl.text.trim(),
                        acceptingOrders: accepting,
                      );
                      if (mounted) {
                        setState(() {
                          _name = nameCtrl.text.trim();
                          _concept = conceptCtrl.text.trim();
                          _location = locationCtrl.text.trim();
                          _phone = phoneCtrl.text.trim();
                          _hours = hoursCtrl.text.trim();
                          _accepting = accepting;
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Restaurant profile updated successfully!'),
                            backgroundColor: AppColors.cyan,
                          ),
                        );
                        _loadProfile();
                      }
                    } catch (e) {
                      setModalState(() => isSaving = false);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update: $e'),
                            backgroundColor: AppColors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
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
            GSButton(label: 'Edit Restaurant Info', isSecondary: true, onTap: _showEditProfileDialog),
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
