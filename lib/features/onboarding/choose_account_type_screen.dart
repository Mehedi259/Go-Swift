import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/gs_button.dart';

class ChooseAccountTypeScreen extends StatefulWidget {
  const ChooseAccountTypeScreen({super.key});

  @override
  State<ChooseAccountTypeScreen> createState() => _ChooseAccountTypeScreenState();
}

class _ChooseAccountTypeScreenState extends State<ChooseAccountTypeScreen> {
  int _selected = 0; // 0 = User, 1 = Provider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Back
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
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
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_user, size: 14, color: AppColors.cyan),
                          const SizedBox(width: 6),
                          Text('OFFICIAL PROTOCOL GATEWAY', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Choose Your Portal', style: AppTextStyles.displayMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Select your operational tier to unlock private transit, luxury maritime deliveries, or livery operations across the Commonwealth.',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    // User Card
                    _PortalCard(
                      icon: Icons.diamond_outlined,
                      title: 'User',
                      badgeLabel: 'ELITE ISLAND MOBILITY',
                      description: 'On-demand chauffeur & luxury island fleet',
                      features: const [
                        'On-demand chauffeur & luxury island fleet',
                        'Yacht berth drop-offs & fine dining liaison',
                        'Instant zero-fee escrow settlement & digital waybills',
                      ],
                      buttonLabel: 'Continue as User',
                      isSelected: _selected == 0,
                      onSelect: () => setState(() => _selected = 0),
                      onContinue: () => Navigator.pushNamed(context, '/customer/login'),
                    ),
                    const SizedBox(height: 16),

                    // Provider Card
                    _PortalCard(
                      icon: Icons.speed,
                      title: 'Service Provider',
                      badgeLabel: 'FBO AVIATION & RESORT DISPATCH',
                      description: 'Guaranteed escrow payouts (1:1 BSD / USD)',
                      features: const [
                        'Guaranteed escrow payouts (1:1 BSD / USD)',
                        'VIP private aviation & high-end resort dispatch network',
                        'Flexible schedule with verified Nassau fleet tracking',
                      ],
                      buttonLabel: 'Apply as Service Provider',
                      isSelected: _selected == 1,
                      onSelect: () => setState(() => _selected = 1),
                      onContinue: () => Navigator.pushNamed(context, '/provider/service-category'),
                      isPrimary: false,
                    ),
                    const SizedBox(height: 24),

                    // Login link
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/customer/login'),
                        child: RichText(
                          text: TextSpan(
                            text: 'Already an authenticated member? ',
                            style: AppTextStyles.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'Log In',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.cyan,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String badgeLabel;
  final String description;
  final List<String> features;
  final String buttonLabel;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onContinue;
  final bool isPrimary;

  const _PortalCard({
    required this.icon,
    required this.title,
    required this.badgeLabel,
    required this.description,
    required this.features,
    required this.buttonLabel,
    required this.isSelected,
    required this.onSelect,
    required this.onContinue,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.cyan : AppColors.border,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.cyan, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: AppTextStyles.headlineMedium)),
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.cyan : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? AppColors.cyan : AppColors.border),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: AppColors.background)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Image placeholder
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A2B40), Color(0xFF0F1D2E)],
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car, color: AppColors.cyan, size: 32),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 60, height: 6, decoration: BoxDecoration(color: AppColors.cyan.withOpacity(0.3), borderRadius: BorderRadius.circular(3))),
                        const SizedBox(height: 6),
                        Container(width: 80, height: 6, decoration: BoxDecoration(color: AppColors.textMuted, borderRadius: BorderRadius.circular(3))),
                        const SizedBox(height: 6),
                        Container(width: 50, height: 6, decoration: BoxDecoration(color: AppColors.textMuted, borderRadius: BorderRadius.circular(3))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Badge
            Row(
              children: [
                Icon(Icons.add_circle_outline, size: 14, color: AppColors.cyan),
                const SizedBox(width: 6),
                Text(badgeLabel, style: AppTextStyles.cyanLabel),
              ],
            ),
            const SizedBox(height: 10),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(f, style: AppTextStyles.bodySmall)),
                ],
              ),
            )),
            const SizedBox(height: 16),
            GSButton(label: buttonLabel, onTap: onContinue, isSecondary: !isPrimary),
          ],
        ),
      ),
    );
  }
}
