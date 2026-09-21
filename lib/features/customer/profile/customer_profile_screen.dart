import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class CustomerProfileScreen extends StatelessWidget {
  final bool embedded;
  const CustomerProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        // App Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile', style: AppTextStyles.headlineLarge.copyWith(color: Colors.white)),
              Row(
                children: [
                  const Icon(Icons.notifications_none_outlined, color: AppColors.textSecondary, size: 24),
                  const SizedBox(width: 16),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.cyan, width: 1.5)),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset('assets/images/user_avatar.jpg', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: AppColors.surface)),
                  ),
                ],
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
                // Profile Info Box
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 72, height: 72,
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.cyan, width: 2)),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset('assets/images/user_avatar.jpg', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: AppColors.surface)),
                              ),
                              Positioned(
                                bottom: 0, right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle, border: Border.all(color: AppColors.background, width: 2)),
                                  child: const Icon(Icons.camera_alt, color: AppColors.background, size: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Marcus Pendelton', style: AppTextStyles.headlineMedium.copyWith(color: Colors.white, fontSize: 20)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, color: AppColors.cyan, size: 14),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text('Nassau & Paradise Island, The Bahamas', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: AppColors.border, height: 1)),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, color: AppColors.cyan, size: 16),
                          const SizedBox(width: 12),
                          Text('marcus.p@luxurybahamas.com', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.phone_android_outlined, color: AppColors.cyan, size: 16),
                          const SizedBox(width: 12),
                          Text('+1 (242) 555-0192', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Wallet & Currency
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, color: AppColors.cyan, size: 20),
                    const SizedBox(width: 10),
                    Text('Wallet & Currency', style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AVAILABLE SWIFT BALANCE', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$450.00', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.cyan, fontSize: 36)),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text('BSD', style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'RTD Regulated Bahamian Dollar Escrow Protection active for all charter rides and villa pre-holds.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add, color: AppColors.background, size: 18),
                                  const SizedBox(width: 6),
                                  Text('Top Up BSD', style: AppTextStyles.titleMedium.copyWith(color: AppColors.background)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
                              alignment: Alignment.center,
                              child: Text('Auto-Reload', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Cards
                Text('PAYMENT CARDS', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.surface.withOpacity(0.3), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                  child: Row(
                    children: [
                      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.credit_card, color: AppColors.cyan, size: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Visa •••• 4242', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.cyan.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                                  child: Text('DEFAULT', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Expires 09/28 • Swift Pay One-Tap', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.surface.withOpacity(0.3), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                  child: Row(
                    children: [
                      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.contactless_outlined, color: Colors.white, size: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Apple Pay', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                            const SizedBox(height: 4),
                            Text('Connected via Secure Enclave', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle_outline, color: AppColors.cyan, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(26)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(26),
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.credit_card, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text('Add New Payment Method', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Security
                Row(
                  children: [
                    const Icon(Icons.security_outlined, color: AppColors.cyan, size: 20),
                    const SizedBox(width: 10),
                    Text('Security', style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/customer/profile/change-password'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.surface.withOpacity(0.3), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_reset, color: AppColors.cyan, size: 24),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Change Password', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                              const SizedBox(height: 4),
                              Text('Update your VIP authentication passcode', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Privacy
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(color: AppColors.surface.withOpacity(0.3), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                    child: Row(
                      children: [
                        const Icon(Icons.privacy_tip_outlined, color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: 16),
                        Expanded(child: Text('Privacy & Terms of Service', style: AppTextStyles.titleMedium.copyWith(color: Colors.white))),
                        const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sign Out
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(color: AppColors.red.withOpacity(0.8), borderRadius: BorderRadius.circular(28)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/choose-account', (_) => false),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Text('Sign Out of GO SWIFT VIP', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );

    return embedded ? content : Scaffold(body: SafeArea(child: content));
  }
}
