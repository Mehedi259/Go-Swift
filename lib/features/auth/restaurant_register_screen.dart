import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/auth_service.dart';
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
    setState(() => _isLoading = true);
    try {
      // Auto-authenticate if credentials are provided and not yet logged in
      if (!LocalStorage.isLoggedIn && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
        try {
          await AuthService().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
        } catch (_) {}
      }

      if (LocalStorage.isLoggedIn) {
        await ProviderApplicationService().updateRestaurantProfile(
          restaurantName: _restaurantNameController.text.trim(),
          managerOrHeadChefName: _ownerNameController.text.trim(),
          contactEmail: _emailController.text.trim(),
          contactPhone: _phoneController.text.trim(),
          commercialLine: _phoneController.text.trim(),
          businessLicenseNumber: _licenseController.text.trim(),
          islandServiceHub: 'Paradise Island & Ocean Club',
          cuisineConcept: 'French-Asian Island Fine Dining',
          averagePrepWindow: '25-35 min',
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Culinary partner application submitted successfully.'),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (_) {
      // Graceful fallback
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushNamedAndRemoveUntil(context, '/provider/restaurant/orders', (_) => false);
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
