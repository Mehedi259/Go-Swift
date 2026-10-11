import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/widgets/gs_button.dart';

class DriverProfileScreen extends StatefulWidget {
  final bool embedded;
  const DriverProfileScreen({super.key, this.embedded = false});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  final ProviderApplicationService _providerService = ProviderApplicationService();
  String _name = 'Captain Terrence Rolle';
  String _role = 'VIP Chauffeur • LUXURY SEDAN';
  String _phone = '+1 (242) 555-0402';
  String _license = 'PSL-40291-NP • Active';
  String _vehicle = 'Cadillac Escalade ESV • BS-942-EX';
  String _zone = 'Nassau • Paradise Island • Cable Beach';
  String _vehicleMake = 'Cadillac';
  String _vehicleModel = 'Escalade ESV';
  String _licensePlate = 'BS-942-EX';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final p = await _providerService.getRideProfile();
      if (mounted && p.isNotEmpty) {
        setState(() {
          if (p['legal_name'] != null && (p['legal_name'] as String).isNotEmpty) {
            _name = p['legal_name'];
          }
          if (p['contact_phone'] != null && (p['contact_phone'] as String).isNotEmpty) {
            _phone = p['contact_phone'];
          }
          if (p['vehicle_category'] != null) {
            _role = 'VIP Chauffeur • ${p['vehicle_category'].toString().toUpperCase()}';
          }
          if (p['public_service_driver_license'] != null) {
            _license = '${p['public_service_driver_license']} • Active';
          }
          if (p['vehicle_make'] != null) _vehicleMake = p['vehicle_make'];
          if (p['vehicle_model'] != null) _vehicleModel = p['vehicle_model'];
          if (p['license_plate'] != null) _licensePlate = p['license_plate'];
          _vehicle = '$_vehicleMake $_vehicleModel • $_licensePlate'.trim();
          if (p['city'] != null && (p['city'] as String).isNotEmpty) {
            _zone = p['city'];
          }
        });
      }
    } catch (_) {}
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _name);
    final phoneCtrl = TextEditingController(text: _phone);
    final makeCtrl = TextEditingController(text: _vehicleMake);
    final modelCtrl = TextEditingController(text: _vehicleModel);
    final plateCtrl = TextEditingController(text: _licensePlate);
    final zoneCtrl = TextEditingController(text: _zone);
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Edit Chauffeur Profile', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 4),
                Text('Update your legal name, registered vehicle, and dispatch contact details.', style: AppTextStyles.bodySmall),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Legal Name', hintText: 'Captain Terrence Rolle'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Direct Mobile Phone', hintText: '+1 (242) 555-0402'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: makeCtrl,
                        decoration: const InputDecoration(labelText: 'Vehicle Make', hintText: 'Cadillac'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: modelCtrl,
                        decoration: const InputDecoration(labelText: 'Vehicle Model', hintText: 'Escalade ESV'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: plateCtrl,
                  decoration: const InputDecoration(labelText: 'License Plate', hintText: 'BS-942-EX'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: zoneCtrl,
                  decoration: const InputDecoration(labelText: 'Operating Island Zone', hintText: 'Nassau & Paradise Island'),
                ),
                const SizedBox(height: 24),
                GSButton(
                  label: isSaving ? 'Saving Changes...' : 'Save Profile Changes',
                  onTap: isSaving
                      ? () {}
                      : () async {
                          final name = nameCtrl.text.trim();
                          if (name.isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
                            return;
                          }
                          setModalState(() => isSaving = true);
                          try {
                            await _providerService.updateRideProfile(
                              legalName: name,
                              contactPhone: phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : null,
                              vehicleMake: makeCtrl.text.trim().isNotEmpty ? makeCtrl.text.trim() : null,
                              vehicleModel: modelCtrl.text.trim().isNotEmpty ? modelCtrl.text.trim() : null,
                              licensePlate: plateCtrl.text.trim().isNotEmpty ? plateCtrl.text.trim() : null,
                              city: zoneCtrl.text.trim().isNotEmpty ? zoneCtrl.text.trim() : null,
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                            _loadProfile();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Chauffeur profile updated successfully!'),
                                  backgroundColor: AppColors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            setModalState(() => isSaving = false);
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text('Error updating: $e'), backgroundColor: AppColors.red),
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
    final content = SingleChildScrollView(
      child: Column(
        children: [
          // Header Card in Sovereign Light Theme
          Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.card,
              border: Border(bottom: BorderSide(color: AppColors.border)),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              children: [
                if (widget.embedded)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Profile', style: AppTextStyles.headlineLarge),
                      GestureDetector(
                        onTap: _showEditProfileDialog,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: const Icon(Icons.edit_outlined, color: AppColors.primaryTeal, size: 20),
                        ),
                      ),
                    ],
                  ),
                if (widget.embedded) const SizedBox(height: 20),
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppColors.cyanLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cyan, width: 2.5),
                  ),
                  child: const Icon(Icons.person, color: AppColors.cyan, size: 44),
                ),
                const SizedBox(height: 12),
                Text(_name, style: AppTextStyles.headlineMedium),
                const SizedBox(height: 2),
                Text(_role, style: AppTextStyles.cyanLabel),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 16),
                    const SizedBox(width: 4),
                    Text('4.98 rating • Verified Sovereign Chauffeur',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _statPill('Active', 'Status')),
                    const SizedBox(width: 10),
                    Expanded(child: _statPill('Bahamas', 'Licensing')),
                    const SizedBox(width: 10),
                    Expanded(child: _statPill('4.98 ★', 'Rating')),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Driver Details', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 14),
                _infoTile(Icons.badge_outlined, 'License', _license),
                _infoTile(Icons.phone_outlined, 'Direct Phone', _phone),
                _infoTile(Icons.directions_car, 'Vehicle', _vehicle),
                _infoTile(Icons.payment, 'Payout Account', 'Bank of Bahamas • ••••8921'),
                _infoTile(Icons.location_on_outlined, 'Service Zone', _zone),
                const SizedBox(height: 24),
                GSButton(label: 'Edit Profile Details', isSecondary: true, onTap: _showEditProfileDialog),
                const SizedBox(height: 12),
                GSButton(
                  label: 'Sign Out',
                  isSecondary: true,
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/choose-account', (_) => false),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );

    return widget.embedded
        ? content
        : Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
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
              title: Text('Driver Profile', style: AppTextStyles.titleLarge),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primaryTeal),
                  onPressed: _showEditProfileDialog,
                ),
              ],
            ),
            body: content,
          );
  }

  Widget _statPill(String value, String label) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      );

  Widget _infoTile(IconData icon, String label, String value) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
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
                  Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      );
}
