import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/widgets/gs_button.dart';

class RestaurantRegisterScreen extends StatefulWidget {
  const RestaurantRegisterScreen({super.key});

  @override
  State<RestaurantRegisterScreen> createState() => _RestaurantRegisterScreenState();
}

class _RestaurantRegisterScreenState extends State<RestaurantRegisterScreen> {
  final _restaurantNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = LocalStorage.getUser();
    if (user != null) {
      if (user.fullName.isNotEmpty) _ownerNameController.text = user.fullName;
      if (user.email.isNotEmpty) _emailController.text = user.email;
      if (user.phone.isNotEmpty) _phoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final restaurantName = _restaurantNameController.text.trim();
    final ownerName = _ownerNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final license = _licenseController.text.trim();
    final password = _passwordController.text;

    if (ownerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter owner / head chef name.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters long.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final formattedPhone = phone.isNotEmpty
          ? (phone.startsWith('+') ? phone : '+1 (242) $phone')
          : null;

      if (LocalStorage.isLoggedIn) {
        await ProviderApplicationService().updateRestaurantProfile(
          restaurantName: restaurantName.isNotEmpty ? restaurantName : 'Bespoke Dining Nassau',
          managerOrHeadChefName: ownerName,
          contactEmail: email,
          contactPhone: formattedPhone,
          commercialLine: formattedPhone,
          businessLicenseNumber: license,
          islandServiceHub: 'Paradise Island & Ocean Club',
          cuisineConcept: 'French-Asian Island Fine Dining',
          averagePrepWindow: '25-35 min',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Culinary partner profile configured successfully.'),
              backgroundColor: AppColors.green,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/provider/restaurant/orders', (_) => false);
        }
      } else {
        final authProvider = context.read<AuthProvider>();
        final phoneForApi = phone.isNotEmpty
            ? (phone.startsWith('+') ? phone : '+1242$phone')
            : null;

        final success = await authProvider.initiateRegistration(
          fullName: ownerName,
          email: email,
          password: password,
          confirmPassword: password,
          phoneNumber: phoneForApi,
        );

        if (!mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification code sent to $email. Please enter your OTP.'),
              backgroundColor: AppColors.green,
            ),
          );

          Navigator.pushNamed(context, '/verify-code', arguments: {
            'email': email,
            'destination': '/provider/restaurant/orders',
            'providerType': 'restaurant',
            'providerData': {
              'restaurant_name': restaurantName.isNotEmpty ? restaurantName : 'Bespoke Dining Nassau',
              'manager_or_head_chef_name': ownerName,
              'contact_email': email,
              'contact_phone': formattedPhone,
              'commercial_line': formattedPhone,
              'business_license_number': license,
              'island_service_hub': 'Paradise Island & Ocean Club',
              'cuisine_concept': 'French-Asian Island Fine Dining',
            },
          });
        } else {
          final errMsg = authProvider.errorMessage ?? 'Registration failed. If already registered, please Log In.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errMsg),
              backgroundColor: AppColors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration error: $e'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.badgeTeal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'FINE DINING & CULINARY DISPATCH',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text('Join As Restaurant Partner', style: AppTextStyles.displayMedium),
            const SizedBox(height: 8),
            Text(
              'List your gourmet menu and receive yacht berth and villa delivery orders.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 28),
            _field('Restaurant Name', Icons.restaurant, 'e.g. Dune by Jean-Georges', controller: _restaurantNameController),
            const SizedBox(height: 16),
            _field('Owner / Contact Name', Icons.person_outline, 'e.g. Jean-Georges', controller: _ownerNameController),
            const SizedBox(height: 16),
            _field('Email Address', Icons.mail_outline, 'contact@restaurant.bs', controller: _emailController),
            const SizedBox(height: 16),
            _field('Bahamas Mobile', Icons.phone_outlined, '+1 (242) 555-0000', controller: _phoneController),
            const SizedBox(height: 16),
            _field('Business License No.', Icons.badge_outlined, 'BL-000000-NP', controller: _licenseController),
            const SizedBox(height: 16),
            _field('Password', Icons.lock_outline, 'Create password', controller: _passwordController),
            const SizedBox(height: 24),
            GSButton(
              label: _isLoading ? 'Registering Restaurant...' : 'Register & Continue →',
              onTap: _isLoading ? () {} : _handleRegister,
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/customer/login'),
                child: RichText(
                  text: TextSpan(
                    text: 'Already registered? ',
                    style: AppTextStyles.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Log In →',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
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
    );
  }

  Widget _field(String label, IconData icon, String hint, {TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.labelSmall),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: AppTextStyles.bodyLarge,
          obscureText: label.contains('Password'),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primaryTeal, size: 20),
          ),
        ),
      ],
    );
  }
}
