import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/widgets/gs_button.dart';

class DriverDocumentsScreen extends StatefulWidget {
  const DriverDocumentsScreen({super.key});

  @override
  State<DriverDocumentsScreen> createState() => _DriverDocumentsScreenState();
}

class _DriverDocumentsScreenState extends State<DriverDocumentsScreen> {
  final ProviderApplicationService _providerService = ProviderApplicationService();
  bool _isLoading = true;
  String _licenseNumber = 'BS-DL-4920';
  String _registrationNumber = 'REG-2026-NPA';
  String _insurancePolicy = 'BAH-INS-941';
  String _verificationStatus = 'Verified';

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
          if (p['driver_license_number'] != null && (p['driver_license_number'] as String).isNotEmpty) {
            _licenseNumber = p['driver_license_number'];
          }
          if (p['vehicle_registration_number'] != null && (p['vehicle_registration_number'] as String).isNotEmpty) {
            _registrationNumber = p['vehicle_registration_number'];
          }
          if (p['vehicle_insurance_policy'] != null && (p['vehicle_insurance_policy'] as String).isNotEmpty) {
            _insurancePolicy = p['vehicle_insurance_policy'];
          }
          final onb = p['onboarding_status']?.toString().toUpperCase();
          if (onb == 'COMPLETED') {
            _verificationStatus = 'Verified';
          } else if (onb == 'UNDER_REVIEW') {
            _verificationStatus = 'Under Review';
          }
        });
      }
    } catch (_) {} finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final docs = [
      {'title': 'Public Service Driver\'s License', 'number': _licenseNumber, 'status': _verificationStatus, 'expiry': 'Dec 2027', 'color': AppColors.green, 'bg': AppColors.greenLight},
      {'title': 'Vehicle Registration', 'number': _registrationNumber, 'status': _verificationStatus, 'expiry': 'Mar 2027', 'color': AppColors.green, 'bg': AppColors.greenLight},
      {'title': 'Vehicle Insurance', 'number': _insurancePolicy, 'status': _verificationStatus, 'expiry': 'Jun 2026', 'color': AppColors.green, 'bg': AppColors.greenLight},
      {'title': 'Background Check', 'number': 'Royal Bahamas Police Force Record', 'status': 'Approved', 'expiry': 'Annual', 'color': AppColors.cyan, 'bg': AppColors.cyanLight},
      {'title': 'Chauffeur Badge Photo', 'number': 'Executive Protocol Standard', 'status': 'Approved', 'expiry': 'Verified', 'color': AppColors.gold, 'bg': AppColors.goldLight},
    ];

    return Scaffold(
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
        title: Text('Documents & Credentials', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
          : RefreshIndicator(
              onRefresh: _loadProfile,
              color: AppColors.cyan,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Active licenses, regulatory permits, and insured transport documents registered with GO SWIFT Bahamas.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  ...docs.map((d) => Container(
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
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: d['bg'] as Color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.description_outlined, color: d['color'] as Color, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(d['title'] as String, style: AppTextStyles.titleMedium),
                                  const SizedBox(height: 2),
                                  Text(
                                    d['number'] as String,
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('Expires: ${d['expiry']}', style: AppTextStyles.caption),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: d['bg'] as Color,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    d['status'] as String,
                                    style: AppTextStyles.caption.copyWith(color: d['color'] as Color, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Icon(Icons.verified_outlined, color: AppColors.cyan, size: 20),
                              ],
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                  GSButton(
                    label: 'Sync Regulatory Documents',
                    isSecondary: true,
                    onTap: _loadProfile,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
