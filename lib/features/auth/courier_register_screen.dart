import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/widgets/gs_button.dart';

class CourierRegisterScreen extends StatefulWidget {
  const CourierRegisterScreen({super.key});

  @override
  State<CourierRegisterScreen> createState() => _CourierRegisterScreenState();
}

class _CourierRegisterScreenState extends State<CourierRegisterScreen> {
  final _nameController = TextEditingController(text: 'Marcus Rolle');
  final _emailController = TextEditingController(text: 'marcus.rolle@swiftcourier.bs');
  final _phoneController = TextEditingController(text: '+1 (242) 555-0182');
  final _licenseController = TextEditingController(text: 'BL-94281-NP');
  final _passwordController = TextEditingController();
  bool _isLoading = false;

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
    setState(() => _isLoading = true);
    try {
      await ProviderApplicationService().updateCourierProfile(
        legalName: _nameController.text.trim(),
        contactEmail: _emailController.text.trim(),
        contactPhone: _phoneController.text.trim(),
        driverLicenseNumber: _licenseController.text.trim(),
        operatingIslandZone: 'New Providence & Paradise Island',
        transportMode: 'car',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Courier application submitted successfully.'),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (_) {
      // Allow seamless mock progression
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushNamedAndRemoveUntil(context, '/provider/courier/hub', (_) => false);
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
            _field('Full Legal Name', Icons.person_outline, 'e.g. James Thompson', controller: _nameController),
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
