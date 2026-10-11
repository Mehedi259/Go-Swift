import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obs1 = true;
  bool _obs2 = true;
  bool _obs3 = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    final oldPass = _oldPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all password fields'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New passwords do not match'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.changePassword(
      oldPassword: oldPass,
      newPassword: newPass,
      confirmPassword: confirmPass,
    );

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Failed to update password'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.surface,
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
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(color: Color(0xFF1E3A4C), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  Text('Change\nPassword', textAlign: TextAlign.center, style: AppTextStyles.headlineMedium.copyWith(color: Colors.white, fontSize: 20, height: 1.2)),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.cyan, width: 2)),
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
                    Text('Current Password', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _oldPasswordController,
                      hint: 'Enter current password',
                      icon: Icons.key_outlined,
                      obscureText: _obs1,
                      onToggle: () => setState(() => _obs1 = !_obs1),
                    ),
                    const SizedBox(height: 24),

                    // New Password
                    Text('New Password', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _newPasswordController,
                      hint: 'Create new password',
                      icon: Icons.lock_reset,
                      obscureText: _obs2,
                      onToggle: () => setState(() => _obs2 = !_obs2),
                    ),
                    const SizedBox(height: 24),

                    // Confirm Password
                    Text('Confirm New Password', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _confirmPasswordController,
                      hint: 'Re-enter new password',
                      icon: Icons.verified_user_outlined,
                      obscureText: _obs3,
                      onToggle: () => setState(() => _obs3 = !_obs3),
                    ),
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
                          onTap: auth.isLoading ? null : _handleUpdate,
                          child: Center(
                            child: auth.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Update Password', style: AppTextStyles.titleMedium.copyWith(color: Colors.black, fontSize: 16)),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward, color: Colors.black, size: 20),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(color: const Color(0xFF1E3A4C), borderRadius: BorderRadius.circular(28)),
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

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF163040),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          prefixIcon: Icon(icon, color: AppColors.cyan, size: 20),
          prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          suffixIcon: GestureDetector(
            onTap: onToggle,
            child: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textSecondary, size: 20),
          ),
        ),
      ),
    );
  }
}

