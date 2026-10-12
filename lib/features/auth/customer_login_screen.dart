import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/storage/local_storage.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (LocalStorage.isLoggedIn && mounted) {
        final role = (LocalStorage.getUserRole() ?? 'customer').toLowerCase();
        final activePortal = LocalStorage.getActivePortal();
        String destination = '/customer/hub';

        if (role == 'service_provider' || role.contains('provider') || activePortal == 'provider') {
          String? category = LocalStorage.getProviderCategory();
          if (category == null || category.isEmpty) {
            category = await ProviderApplicationService().detectActiveProviderCategory();
          }
          switch (category.toLowerCase()) {
            case 'driver':
            case 'chauffeur':
              destination = '/provider/driver/hub';
              break;
            case 'courier':
              destination = '/provider/courier/hub';
              break;
            case 'restaurant':
              destination = '/provider/restaurant/orders';
              break;
            case 'rental':
              destination = '/provider/rental/vehicles';
              break;
            case 'property':
            default:
              destination = '/provider/property/listings';
              break;
          }
        }
        if (mounted) Navigator.pushReplacementNamed(context, destination);
      }
    });
  }

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

      if (role == 'service_provider' || role.contains('provider')) {
        await LocalStorage.saveActivePortal('provider');
        String? category = LocalStorage.getProviderCategory();
        if (category == null || category.isEmpty) {
          category = await ProviderApplicationService().detectActiveProviderCategory();
        }
        switch (category.toLowerCase()) {
          case 'driver':
          case 'chauffeur':
            destination = '/provider/driver/hub';
            break;
          case 'courier':
            destination = '/provider/courier/hub';
            break;
          case 'restaurant':
            destination = '/provider/restaurant/orders';
            break;
          case 'rental':
            destination = '/provider/rental/vehicles';
            break;
          case 'property':
          default:
            destination = '/provider/property/listings';
            break;
        }
      } else {
        await LocalStorage.saveActivePortal('customer');
        destination = '/customer/hub';
      }

      if (!mounted) return;
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
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/customer/register'),
                      child: RichText(
                        text: TextSpan(
                          text: 'New to GO SWIFT Bahamas? ',
                          style: AppTextStyles.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Create Account',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryTeal,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Quick Role Switcher for seamless simulator & QA testing
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.explore_outlined, color: AppColors.cyan, size: 18),
                              const SizedBox(width: 8),
                              Text('EXPLORE ROLES (TESTING MODE)', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('1-Tap to inspect screens across all provider domains:', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _demoChip('Customer Hub', Icons.person, () => Navigator.pushNamed(context, '/customer/hub')),
                              _demoChip('Chauffeur Driver', Icons.directions_car, () => Navigator.pushNamed(context, '/provider/driver/hub')),
                              _demoChip('Restaurant Partner', Icons.restaurant, () => Navigator.pushNamed(context, '/provider/restaurant/orders')),
                              _demoChip('Island Courier', Icons.delivery_dining, () => Navigator.pushNamed(context, '/provider/courier/hub')),
                              _demoChip('Car Rental Host', Icons.car_rental, () => Navigator.pushNamed(context, '/provider/rental/vehicles')),
                              _demoChip('Property Host', Icons.villa, () => Navigator.pushNamed(context, '/provider/property/listings')),
                            ],
                          ),
                        ],
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

  Widget _demoChip(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.cyan, size: 14),
            const SizedBox(width: 5),
            Text(title, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
