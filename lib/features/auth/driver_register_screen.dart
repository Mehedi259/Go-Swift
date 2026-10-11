import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});
  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  int _vehicleType = 0;
  final _vehicles = [
    'Luxury SUV\nCadillac Escalade, Lincoln Navigator, Yukon Denali',
    'Executive Sedan\nMercedes S-Class, BMW 7-Series, Genesis G90',
    'VIP Sprinter / Van\nMercedes-Benz Sprinter Executive, Ford Transit VIP'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
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
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.badgeTeal,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.primaryTeal),
                                const SizedBox(width: 6),
                                Text(
                                  'BAHAMAS CHAUFFEUR & PROVIDER NETWORK',
                                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text('Join As A Chauffeur\nPartner', style: AppTextStyles.displayMedium),
                          const SizedBox(height: 8),
                          Text("Drive with Nassau & Paradise Island's premier luxury mobility network.", style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Step 1 of 3: Account & Credentials',
                                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: [
                                        _stepTab('1. ACCOUNT', true),
                                        _stepTab('2. DOCUMENTS', false),
                                        _stepTab('3. VEHICLE', false),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.badgeGold,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text('33% Done',
                                    style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 0.33,
                              minHeight: 6,
                              backgroundColor: AppColors.cardTouchpoint,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Photo upload
                    Text('Your Photo', style: AppTextStyles.labelSmall),
                    const SizedBox(height: 8),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_photo_alternate_outlined, color: AppColors.primaryTeal, size: 32),
                          const SizedBox(height: 8),
                          Text('Browse Gallery or Take Photo', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildField('Full Legal Name', 'As on official driver badge', 'e.g. Terrence Rolle', Icons.badge_outlined),
                    const SizedBox(height: 16),
                    _buildField('Email Address', null, 'e.g. terrence.rolle@swiftpartner.bs', Icons.mail_outline),
                    const SizedBox(height: 16),
                    _buildField('Mobile Phone Number', 'For instant VIP ride dispatch alerts & SMS verification.', '555-0188', Icons.phone_outlined, prefix: '🇧🇸 +1 (242) '),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Public Service Driver's License", style: AppTextStyles.labelSmall),
                        Text('Required', style: AppTextStyles.labelSmall.copyWith(color: const Color(0xFFB87800), fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: AppTextStyles.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: 'E.G. PSL-40291-NP',
                        prefixIcon: Icon(Icons.verified_user_outlined, color: AppColors.primaryTeal, size: 20),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('Bahamas Road Traffic Dept valid public service chauffeur endorsement.', style: AppTextStyles.bodySmall),
                    const SizedBox(height: 20),

                    Text('Vehicle Category', style: AppTextStyles.labelSmall),
                    const SizedBox(height: 8),
                    ..._vehicles.asMap().entries.map((e) => GestureDetector(
                      onTap: () => setState(() => _vehicleType = e.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _vehicleType == e.key ? AppColors.primaryTeal : AppColors.border,
                            width: _vehicleType == e.key ? 2 : 1,
                          ),
                          boxShadow: _vehicleType == e.key ? AppColors.softShadow : AppColors.cardShadow,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _vehicleType == e.key ? AppColors.badgeTeal : AppColors.cardTouchpoint,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.directions_car, color: _vehicleType == e.key ? AppColors.primaryTeal : AppColors.textSecondary, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(e.value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: _vehicleType == e.key ? AppColors.primaryTeal : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(color: _vehicleType == e.key ? AppColors.primaryTeal : AppColors.border, width: 1.5),
                              ),
                              child: _vehicleType == e.key ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (_) {},
                          activeColor: AppColors.primaryTeal,
                          checkColor: Colors.white,
                          side: const BorderSide(color: AppColors.border),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: AppTextStyles.bodySmall,
                              children: [
                                TextSpan(text: 'GO SWIFT Provider Terms of Service', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w600)),
                                const TextSpan(text: ', Chauffeur Code of Conduct, and Bahamian Road Traffic compliance guidelines.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GSButton(label: 'Continue to Driver Profile →', onTap: () => Navigator.pushNamed(context, '/provider/driver/hub')),
                    const SizedBox(height: 10),
                    Center(child: Text('Next: Set up your Driver Profile, vehicle specs & payout account.', style: AppTextStyles.bodySmall, textAlign: TextAlign.center)),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/customer/login'),
                        child: RichText(
                          text: TextSpan(
                            text: 'Already an approved GO SWIFT Provider? ',
                            style: AppTextStyles.bodySmall,
                            children: [
                              TextSpan(text: 'Log In →', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepTab(String label, bool active) => Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: active ? AppColors.badgeTeal : AppColors.cardTouchpoint,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: active ? AppColors.primaryTeal : AppColors.border, width: 0.5),
    ),
    child: Text(
      label,
      style: AppTextStyles.labelSmall.copyWith(color: active ? AppColors.primaryTeal : AppColors.textMuted, fontWeight: active ? FontWeight.bold : FontWeight.normal),
    ),
  );

  Widget _buildField(String label, String? hint, String placeholder, IconData icon, {String? prefix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSmall),
        if (hint != null) ...[const SizedBox(height: 2), Text(hint, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted))],
        const SizedBox(height: 8),
        TextFormField(
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: prefix != null ? null : placeholder,
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
            prefix: prefix != null ? Text(prefix, style: AppTextStyles.bodyLarge) : null,
          ),
        ),
      ],
    );
  }
}
