import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/widgets/gs_button.dart';

class RentalProviderRegisterScreen extends StatefulWidget {
  const RentalProviderRegisterScreen({super.key});

  @override
  State<RentalProviderRegisterScreen> createState() => _RentalProviderRegisterScreenState();
}

class _RentalProviderRegisterScreenState extends State<RentalProviderRegisterScreen> {
  final _nameController = TextEditingController(text: 'James Thompson');
  final _emailController = TextEditingController(text: 'james.thompson@prestigefleet.bs');
  final _phoneController = TextEditingController(text: '+1 (242) 555-0144');
  final _licenseController = TextEditingController(text: 'CR-88210-NP');
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
      await ProviderApplicationService().updateRentalProfile(
        companyOrHostLegalName: 'Prestige Fleet Bahamas Ltd.',
        operationalContactName: _nameController.text.trim(),
        businessContactNumber: _phoneController.text.trim(),
        contactEmail: _emailController.text.trim(),
        rentalLicenseNumber: _licenseController.text.trim(),
        primaryOperatingBase: 'Downtown Nassau & Lynden Pindling FBO',
        estimatedActiveFleetSize: '5-15 vehicles',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Car rental partner application submitted successfully.'),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (_) {
      // Graceful fallback
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushNamedAndRemoveUntil(context, '/provider/rental/vehicles', (_) => false);
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
                'CAR RENTAL & FLEET OWNER',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text('Register Your Fleet', style: AppTextStyles.displayMedium),
            const SizedBox(height: 8),
            Text(
              'List prestige vehicles for vetted tourist and executive clients across the Bahamas.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 28),
            _field('Full Legal Name', Icons.person_outline, 'e.g. James Thompson', controller: _nameController),
            const SizedBox(height: 16),
            _field('Business / Email Address', Icons.mail_outline, 'business@example.bs', controller: _emailController),
            const SizedBox(height: 16),
            _field('Bahamas Mobile', Icons.phone_outlined, '+1 (242) 555-0000', controller: _phoneController),
            const SizedBox(height: 16),
            _field('Business License No.', Icons.badge_outlined, 'BL-000000-NP', controller: _licenseController),
            const SizedBox(height: 16),
            _field('Password', Icons.lock_outline, 'Create password', controller: _passwordController),
            const SizedBox(height: 24),
            GSButton(
              label: _isLoading ? 'Registering Fleet...' : 'Register & Continue →',
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
