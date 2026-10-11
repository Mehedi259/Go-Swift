import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/widgets/gs_button.dart';

class RentalProviderProfileScreen extends StatefulWidget {
  const RentalProviderProfileScreen({super.key});

  @override
  State<RentalProviderProfileScreen> createState() => _RentalProviderProfileScreenState();
}

class _RentalProviderProfileScreenState extends State<RentalProviderProfileScreen> {
  final ProviderApplicationService _providerService = ProviderApplicationService();
  String _name = 'Island Prestige Fleet';
  String _subtitle = 'Licensed Fleet Provider • Nassau';
  String _license = 'FL-8921-BAH (Verified)';
  String _contact = '+1 (242) 555-0144';
  String _base = 'NAS Airport VIP Parking Lounge';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final p = await _providerService.getRentalProfile();
      if (mounted && p.isNotEmpty) {
        setState(() {
          if (p['company_or_host_legal_name'] != null && (p['company_or_host_legal_name'] as String).isNotEmpty) {
            _name = p['company_or_host_legal_name'];
          }
          if (p['operational_contact_name'] != null) {
            _subtitle = 'Managed by ${p['operational_contact_name']}';
          }
          if (p['rental_license_number'] != null) {
            _license = '${p['rental_license_number']} (Verified)';
          }
          if (p['business_contact_number'] != null) {
            _contact = p['business_contact_number'];
          }
          if (p['primary_operating_base'] != null) {
            _base = p['primary_operating_base'];
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
        title: Text('Fleet Owner Profile', style: AppTextStyles.titleLarge),
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
                    child: const Icon(Icons.directions_car, color: AppColors.cyan, size: 36),
                  ),
                  const SizedBox(height: 12),
                  Text(_name, style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 2),
                  Text(_subtitle, style: AppTextStyles.cyanLabel),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 16),
                      const SizedBox(width: 4),
                      Text('4.96 ★ • Luxury Fleet Verified', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _infoTile(Icons.badge_outlined, 'Fleet License', _license),
            _infoTile(Icons.phone_outlined, 'Business Phone', _contact),
            _infoTile(Icons.shield_outlined, 'Commercial Insurance', 'Royal Fidelity • Full Fleet'),
            _infoTile(Icons.payment, 'Direct Deposit', 'Scotiabank Bahamas • ••••5512'),
            _infoTile(Icons.location_on_outlined, 'Pickup Hub', _base),
            const SizedBox(height: 24),
            GSButton(label: 'Edit Fleet Profile', isSecondary: true, onTap: () {}),
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
