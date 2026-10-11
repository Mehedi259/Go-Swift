import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/storage/local_storage.dart';
import '../../core/widgets/gs_button.dart';

class ChooseAccountTypeScreen extends StatefulWidget {
  const ChooseAccountTypeScreen({super.key});

  @override
  State<ChooseAccountTypeScreen> createState() => _ChooseAccountTypeScreenState();
}

class _ChooseAccountTypeScreenState extends State<ChooseAccountTypeScreen> {
  int _selected = 0; // 0 = User, 1 = Provider

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (LocalStorage.isLoggedIn && mounted) {
        final role = (LocalStorage.getUserRole() ?? 'customer').toLowerCase();
        String destination = '/customer/hub';
        if (role.contains('driver') || role.contains('chauffeur')) {
          destination = '/provider/driver/hub';
        } else if (role.contains('courier')) {
          destination = '/provider/courier/hub';
        } else if (role.contains('restaurant')) {
          destination = '/provider/restaurant/orders';
        } else if (role.contains('rental')) {
          destination = '/provider/rental/vehicles';
        } else if (role.contains('property')) {
          destination = '/provider/property/listings';
        }
        Navigator.pushReplacementNamed(context, destination);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.badgeTeal,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_user, size: 14, color: AppColors.primaryTeal),
                          const SizedBox(width: 8),
                          Text('OFFICIAL PROTOCOL GATEWAY',
                              style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w700)),
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
                      imagePath: 'assets/images/usercard.png',
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
                      imagePath: 'assets/images/service provider card.png',
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
                                  color: AppColors.primaryTeal,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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
  final String imagePath;

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
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppColors.softShadow : AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.badgeTeal : AppColors.cardTouchpoint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primaryTeal, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: AppTextStyles.headlineMedium)),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryTeal : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primaryTeal : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Image
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.badgeCyan,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_circle_outline, size: 14, color: AppColors.primaryTeal),
                  const SizedBox(width: 6),
                  Text(badgeLabel, style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primaryTeal),
                  const SizedBox(width: 8),
                  Expanded(child: Text(f, style: AppTextStyles.bodySmall)),
                ],
              ),
            )),
            const SizedBox(height: 18),
            GSButton(label: buttonLabel, onTap: onContinue, isSecondary: !isPrimary),
          ],
        ),
      ),
    );
  }
}
