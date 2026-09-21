import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obs1 = true;
  bool _obs2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44, height: 44,
                      decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  Text('Change\nPassword', textAlign: TextAlign.center, style: AppTextStyles.headlineMedium.copyWith(color: Colors.white, fontSize: 20, height: 1.2)),
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.surface, width: 2)),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset('assets/images/user_avatar.jpg', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: AppColors.surface)),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Current Password', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                        Text('Forgot passcode?', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildField('Enter current password', Icons.key_outlined, _obs1, () => setState(() => _obs1 = !_obs1), true),
                    const SizedBox(height: 24),

                    // New Password
                    Text('New Password', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                    const SizedBox(height: 12),
                    _buildField('Create new passcode', Icons.lock_reset, _obs2, () => setState(() => _obs2 = !_obs2), true),
                    const SizedBox(height: 12),

                    // Entropy
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('PASSCODE ENTROPY', style: AppTextStyles.labelSmall.copyWith(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  Text('STRONG', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(2)))),
                              const SizedBox(width: 8),
                              Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(2)))),
                              const SizedBox(width: 8),
                              Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(2)))),
                              const SizedBox(width: 8),
                              Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Confirm Password
                    Text('Confirm New Password', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                    const SizedBox(height: 12),
                    _buildField('Re-enter new password', Icons.verified_user_outlined, true, null, false, trailingWidget: const Icon(Icons.check_circle, color: AppColors.cyan, size: 22)),
                    const SizedBox(height: 40),

                    // Buttons
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(28)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () => Navigator.pop(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Update Password', style: AppTextStyles.titleMedium.copyWith(color: AppColors.background, fontSize: 16)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, color: AppColors.background, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(28)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () => Navigator.pop(context),
                          child: Center(
                            child: Text('Cancel', style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 16)),
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
        ),
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, bool obscureText, VoidCallback? onToggle, bool isEye, {Widget? trailingWidget}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        obscureText: obscureText,
        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
          prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          suffixIcon: trailingWidget ?? (isEye ? GestureDetector(
            onTap: onToggle,
            child: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textSecondary, size: 20),
          ) : null),
        ),
      ),
    );
  }
}
