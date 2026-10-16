import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/widgets/gs_button.dart';

class RentalProviderProfileScreen extends StatefulWidget {
  final bool embedded;
  const RentalProviderProfileScreen({super.key, this.embedded = false});

  @override
  State<RentalProviderProfileScreen> createState() => _RentalProviderProfileScreenState();
}

class _RentalProviderProfileScreenState extends State<RentalProviderProfileScreen> {
  final ProviderApplicationService _providerService = ProviderApplicationService();
  String _name = 'Island Prestige Fleet';
  String _subtitle = 'Licensed Fleet Provider • Nassau';
  String _managerName = '';
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
            _managerName = p['operational_contact_name'];
            _subtitle = 'Managed by $_managerName';
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

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _name);
    final managerCtrl = TextEditingController(text: _managerName);
    final phoneCtrl = TextEditingController(text: _contact);
    final baseCtrl = TextEditingController(text: _base);
    final licenseCtrl = TextEditingController(text: _license.replaceAll(' (Verified)', ''));
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
                Text('Edit Fleet Profile', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 6),
                Text('Update rental agency details and primary operating base', style: AppTextStyles.bodySmall),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Fleet / Company Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: managerCtrl,
                  decoration: const InputDecoration(labelText: 'Operational Manager Name', hintText: 'e.g. Sterling Sands'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Business Contact Phone'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: baseCtrl,
                  decoration: const InputDecoration(labelText: 'Primary Operating Base', hintText: 'e.g. NAS Airport VIP Lounge'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: licenseCtrl,
                  decoration: const InputDecoration(labelText: 'Rental License Number', hintText: 'e.g. FL-8921-BAH'),
                ),
                const SizedBox(height: 20),
                GSButton(
                  label: 'Save Changes',
                  isLoading: isSaving,
                  onTap: () async {
                    setModalState(() => isSaving = true);
                    try {
                      await _providerService.updateRentalProfile(
                        companyOrHostLegalName: nameCtrl.text.trim(),
                        operationalContactName: managerCtrl.text.trim(),
                        businessContactNumber: phoneCtrl.text.trim(),
                        primaryOperatingBase: baseCtrl.text.trim(),
                        rentalLicenseNumber: licenseCtrl.text.trim(),
                      );
                      if (mounted) {
                        setState(() {
                          _name = nameCtrl.text.trim();
                          _managerName = managerCtrl.text.trim();
                          _subtitle = _managerName.isNotEmpty ? 'Managed by $_managerName' : 'Licensed Fleet Provider • Nassau';
                          _contact = phoneCtrl.text.trim();
                          _base = baseCtrl.text.trim();
                          _license = '${licenseCtrl.text.trim()} (Verified)';
                        });
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fleet profile updated successfully!'),
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
        title: Text('Fleet Owner Profile', style: AppTextStyles.titleLarge),
        centerTitle: false,
        automaticallyImplyLeading: !widget.embedded,
        leading: widget.embedded
            ? null
            : GestureDetector(
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
            GSButton(label: 'Edit Fleet Profile', isSecondary: true, onTap: _showEditProfileDialog),
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
