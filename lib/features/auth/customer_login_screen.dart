import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/gs_button.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(email: email, password: password);

    if (!mounted) return;

    if (success) {
      final role = authProvider.userRole.toLowerCase();
      String destination = '/customer/hub';

      if (role.contains('driver') || role.contains('chauffeur')) {
        destination = '/provider/driver/hub';
      } else if (role.contains('courier')) {
        destination = '/provider/courier/hub';
      } else if (role.contains('restaurant')) {
        destination = '/provider/restaurant/orders';
      } else if (role.contains('rental')) {
        destination = '/provider/rental/fleet';
      } else if (role.contains('property')) {
        destination = '/provider/property/listings';
      }

      Navigator.pushNamedAndRemoveUntil(context, destination, (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Login failed. Please check credentials.'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
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
                        boxShadow: AppColors.softShadow,
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text('Customer Profile Sign In', style: AppTextStyles.titleLarge),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Lock icon
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.cyanLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.25), width: 1.5),
                        boxShadow: AppColors.softShadow,
                      ),
                      child: const Icon(Icons.lock_outline, color: AppColors.cyan, size: 32),
                    ),
                    const SizedBox(height: 20),
                    Text('Customer Sign In', style: AppTextStyles.displayMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome back to frictionless island transit and luxury living.',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Email field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Email Address', style: AppTextStyles.labelSmall),
                        Text('NASSAU • OUT ISLANDS', style: AppTextStyles.cyanLabel),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: 'alexander.vance@example.com',
                        prefixIcon: Icon(Icons.alternate_email, color: AppColors.textSecondary, size: 20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Password', style: AppTextStyles.labelSmall),
                        GestureDetector(
                          onTap: () {},
                          child: Text('Forgot password?', style: AppTextStyles.cyanLabel),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Enter your account password',
                        prefixIcon: const Icon(Icons.key_outlined, color: AppColors.textSecondary, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    GSButton(
                      label: authProvider.isLoading ? 'Signing In...' : 'Sign In →',
                      onTap: authProvider.isLoading ? () {} : _handleLogin,
                    ),
                    const SizedBox(height: 20),
                    // Register card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 0.8),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Don\'t have an account?', style: AppTextStyles.titleMedium),
                                const SizedBox(height: 2),
                                Text('Create your VIP customer profile', style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/customer/register'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.cyanLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
                              ),
                              child: Text('Register', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
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
