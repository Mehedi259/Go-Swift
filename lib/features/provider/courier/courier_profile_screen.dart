import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/courier_service.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/widgets/gs_button.dart';

class CourierProfileScreen extends StatefulWidget {
  final bool embedded;
  const CourierProfileScreen({super.key, this.embedded = false});

  @override
  State<CourierProfileScreen> createState() => _CourierProfileScreenState();
}

class _CourierProfileScreenState extends State<CourierProfileScreen> {
  String _name = 'Marcus Rolle';
  String _badge = 'Bonded Courier • #BC-182';
  String _rating = '4.92 ★';
  String _deliveries = '2,450';
  String _earned = '\$12,400';
  String _license = 'BL-94281-NP • Active';
  String _zone = 'Nassau • Paradise Island';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final p = await ProviderApplicationService().getCourierProfile();
      if (mounted && p.isNotEmpty) {
        setState(() {
          if (p['legal_name'] != null && (p['legal_name'] as String).isNotEmpty) {
            _name = p['legal_name'];
          }
          if (p['transport_mode'] != null) {
            _badge = 'Bonded Courier • ${p['transport_mode'].toString().toUpperCase()}';
          }
          if (p['driver_license_number'] != null) {
            _license = '${p['driver_license_number']} • Active';
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
                  child: const Icon(Icons.delivery_dining, color: AppColors.cyan, size: 44),
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
                    Text('$_rating rating • Bonded Logistics',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _statPill(_deliveries, 'Deliveries')),
                    const SizedBox(width: 10),
                    Expanded(child: _statPill(_earned, 'Earned')),
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
                _infoTile(Icons.badge_outlined, 'License No.', _license),
                _infoTile(Icons.payment, 'Payout Account', 'Bank of Bahamas • ••••8921'),
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
              title: Text('Courier Profile', style: AppTextStyles.titleLarge),
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
