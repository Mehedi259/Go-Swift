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
  String _name = 'Captain Terrence Rolle';
  String _role = 'VIP Chauffeur • #CH-402';
  String _license = 'PSL-40291-NP  •  Expires Dec 2027';
  String _vehicle = 'Cadillac Escalade ESV  •  BS-942-EX';
  String _zone = 'Nassau  •  Paradise Island  •  Cable Beach';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final p = await ProviderApplicationService().getRideProfile();
      if (mounted && p.isNotEmpty) {
        setState(() {
          if (p['legal_name'] != null && (p['legal_name'] as String).isNotEmpty) {
            _name = p['legal_name'];
          }
          if (p['vehicle_category'] != null) {
            _role = 'VIP Chauffeur • ${p['vehicle_category'].toString().toUpperCase()}';
          }
          if (p['public_service_driver_license'] != null) {
            _license = '${p['public_service_driver_license']} • Active';
          }
          if (p['vehicle_make'] != null || p['vehicle_model'] != null) {
            _vehicle = '${p['vehicle_make'] ?? ''} ${p['vehicle_model'] ?? ''} • ${p['license_plate'] ?? 'BS-NP'}'.trim();
          }
        });
      }
    } catch (_) {}
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
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Icon(Icons.settings_outlined, color: AppColors.textSecondary, size: 20),
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
                    Text('4.98 rating  •  620 completed trips',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _statPill('620', 'Trips')),
                    const SizedBox(width: 10),
                    Expanded(child: _statPill('\$28,400', 'Earned')),
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
                _infoTile(Icons.directions_car, 'Vehicle', _vehicle),
                _infoTile(Icons.payment, 'Payout Account', 'Bank of Bahamas  •  ••••8921'),
                _infoTile(Icons.location_on_outlined, 'Service Zone', _zone),
                const SizedBox(height: 24),
                GSButton(label: 'Edit Profile', isSecondary: true, onTap: () {}),
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
