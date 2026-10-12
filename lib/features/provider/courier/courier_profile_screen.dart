import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/courier_service.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/widgets/gs_button.dart';

class CourierProfileScreen extends StatefulWidget {
  final bool embedded;
  const CourierProfileScreen({super.key, this.embedded = false});

  @override
  State<CourierProfileScreen> createState() => _CourierProfileScreenState();
}

class _CourierProfileScreenState extends State<CourierProfileScreen> {
  final ProviderApplicationService _providerService = ProviderApplicationService();
  String _name = LocalStorage.getUser()?.fullName.isNotEmpty == true ? LocalStorage.getUser()!.fullName : 'Bonded Courier';
  String _badge = 'Bonded Courier • Verified';
  String _phone = LocalStorage.getUser()?.phone ?? '';
  String _rating = '5.00 ★';
  String _deliveries = '0';
  String _earned = '\$0.00';
  String _license = 'Verified Partner';
  String _licenseNumber = '';
  String _zone = 'Nassau & Paradise Island';
  String _transportMode = 'van';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final p = await _providerService.getCourierProfile();
      if (mounted && p.isNotEmpty) {
        setState(() {
          if (p['legal_name'] != null && (p['legal_name'] as String).isNotEmpty) {
            _name = p['legal_name'];
          }
          if (p['contact_phone'] != null && (p['contact_phone'] as String).isNotEmpty) {
            _phone = p['contact_phone'];
          }
          if (p['transport_mode'] != null) {
            _transportMode = p['transport_mode'].toString().toLowerCase();
            _badge = 'Bonded Courier • ${_transportMode.toUpperCase()}';
          }
          if (p['driver_license_number'] != null) {
            _licenseNumber = p['driver_license_number'];
            _license = '$_licenseNumber • Active';
          }
          if (p['operating_island_zone'] != null) {
            _zone = p['operating_island_zone'];
          }
        });
      }
    } catch (_) {}

    try {
      final stats = await CourierService().getProviderStats();
      if (mounted && stats.isNotEmpty) {
        setState(() {
          if (stats['total_earnings'] != null) {
            _earned = '\$${stats['total_earnings']}';
          }
          if (stats['average_rating'] != null) {
            _rating = '${stats['average_rating']} ★';
          }
          if (stats['completed_deliveries_today'] != null) {
            _deliveries = '${stats['completed_deliveries_today']}';
          }
        });
      }
    } catch (_) {}
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _name);
    final phoneCtrl = TextEditingController(text: _phone);
    final licenseCtrl = TextEditingController(text: _licenseNumber);
    final zoneCtrl = TextEditingController(text: _zone);
    String mode = _transportMode;
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
                Text('Edit Courier Profile', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 4),
                Text('Update your bonded courier credentials, contact phone, and operating zone.', style: AppTextStyles.bodySmall),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Legal Name', hintText: 'Enter legal full name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Direct Mobile Phone', hintText: '+1 (242) ...'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: licenseCtrl,
                  decoration: const InputDecoration(labelText: 'Driver / Courier License No.', hintText: 'e.g. BL-XXXXX-NP'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: zoneCtrl,
                  decoration: const InputDecoration(labelText: 'Operating Island Zone', hintText: 'Nassau • Paradise Island'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: mode,
                  decoration: const InputDecoration(labelText: 'Transport Mode'),
                  items: const [
                    DropdownMenuItem(value: 'motorcycle', child: Text('Motorcycle / Scooter')),
                    DropdownMenuItem(value: 'car', child: Text('Courier Car')),
                    DropdownMenuItem(value: 'van', child: Text('Cargo Van / SUV')),
                    DropdownMenuItem(value: 'truck', child: Text('Heavy Transport Truck')),
                  ],
                  onChanged: (val) => setModalState(() => mode = val ?? 'van'),
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
                            await _providerService.updateCourierProfile(
                              legalName: name,
                              contactPhone: phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : null,
                              driverLicenseNumber: licenseCtrl.text.trim().isNotEmpty ? licenseCtrl.text.trim() : null,
                              operatingIslandZone: zoneCtrl.text.trim().isNotEmpty ? zoneCtrl.text.trim() : null,
                              transportMode: mode,
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                            _loadProfile();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Courier profile updated successfully!'),
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
                    color: AppColors.badgeTeal,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryTeal, width: 2.5),
                  ),
                  child: const Icon(Icons.delivery_dining, color: AppColors.primaryTeal, size: 44),
                ),
                const SizedBox(height: 12),
                Text(_name, style: AppTextStyles.headlineMedium),
                const SizedBox(height: 2),
                Text(_badge, style: AppTextStyles.cyanLabel),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 16),
                    const SizedBox(width: 4),
                    Text('$_rating • Bonded & Insured Courier',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _statPill(_deliveries, 'Deliveries')),
                    const SizedBox(width: 10),
                    Expanded(child: _statPill(_earned, 'Earnings')),
                    const SizedBox(width: 10),
                    Expanded(child: _statPill(_rating, 'Rating')),
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
                Text('Courier Details', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 14),
                _infoTile(Icons.shield_outlined, 'Bonded Status', 'Active • Insured up to \$50,000'),
                _infoTile(Icons.phone_outlined, 'Direct Phone', _phone),
                _infoTile(Icons.badge_outlined, 'License No.', _license),
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
              title: Text('Courier Profile', style: AppTextStyles.titleLarge),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primaryTeal),
                  onPressed: _showEditProfileDialog,
                ),
              ],
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
