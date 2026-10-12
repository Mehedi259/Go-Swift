import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/widgets/gs_button.dart';

class CourierRegisterScreen extends StatefulWidget {
  const CourierRegisterScreen({super.key});

  @override
  State<CourierRegisterScreen> createState() => _CourierRegisterScreenState();
}

class _CourierRegisterScreenState extends State<CourierRegisterScreen> {
  final _nameController = TextEditingController();
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
      if (user.fullName.isNotEmpty) _nameController.text = user.fullName;
      if (user.email.isNotEmpty) _emailController.text = user.email;
      if (user.phone.isNotEmpty) _phoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final license = _licenseController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your full legal name.'),
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
        await ProviderApplicationService().updateCourierProfile(
          legalName: name,
          contactEmail: email,
          contactPhone: formattedPhone,
          driverLicenseNumber: license,
          operatingIslandZone: 'New Providence & Paradise Island',
          transportMode: 'car',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Courier profile configured successfully.'),
              backgroundColor: AppColors.green,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/provider/courier/hub', (_) => false);
        }
      } else {
        final authProvider = context.read<AuthProvider>();
        final phoneForApi = phone.isNotEmpty
            ? (phone.startsWith('+') ? phone : '+1242$phone')
            : null;

        final success = await authProvider.initiateRegistration(
          fullName: name,
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
            'destination': '/provider/courier/hub',
            'providerType': 'courier',
            'providerData': {
              'legal_name': name,
              'contact_email': email,
              'contact_phone': formattedPhone,
              'driver_license_number': license,
              'operating_island_zone': 'New Providence & Paradise Island',
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
                'BONDED LOGISTICS NETWORK',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text('Join As A Courier Partner', style: AppTextStyles.displayMedium),
            const SizedBox(height: 8),
            Text(
              'Dispatch bonded parcels, luxury retail, and legal documents across Nassau & Paradise Island.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 28),
            _field('Full Legal Name', Icons.person_outline, 'e.g. Full Legal Name', controller: _nameController),
            const SizedBox(height: 16),
            _field('Business / Email Address', Icons.mail_outline, 'business@example.bs', controller: _emailController),
            const SizedBox(height: 16),
            _field('Bahamas Mobile', Icons.phone_outlined, '+1 (242) 555-0000', controller: _phoneController),
            const SizedBox(height: 16),
            _field('Driver / Business License No.', Icons.badge_outlined, 'BL-000000-NP', controller: _licenseController),
            const SizedBox(height: 16),
            _field('Password', Icons.lock_outline, 'Create password', controller: _passwordController),
            const SizedBox(height: 24),
            GSButton(
              label: _isLoading ? 'Registering Partner...' : 'Register & Continue →',
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
