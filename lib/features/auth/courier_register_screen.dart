import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

// Simple registration screens for other provider types

class CourierRegisterScreen extends StatelessWidget {
  const CourierRegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => _ProviderRegForm(
    title: 'Join As A Courier Partner', subtitle: 'BONDED LOGISTICS NETWORK',
    desc: 'Dispatch bonded parcels, luxury retail, and legal documents across Nassau.', nextRoute: '/provider/courier/hub');
}

class RentalProviderRegisterScreen extends StatelessWidget {
  const RentalProviderRegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => _ProviderRegForm(
    title: 'Register Your Fleet', subtitle: 'CAR RENTAL & FLEET OWNER',
    desc: 'List prestige vehicles for vetted tourist and executive clients across the Bahamas.', nextRoute: '/provider/rental/vehicles');
}

class RestaurantRegisterScreen extends StatelessWidget {
  const RestaurantRegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => _ProviderRegForm(
    title: 'Join As Restaurant Partner', subtitle: 'FINE DINING & CULINARY DISPATCH',
    desc: 'List your gourmet menu and receive yacht berth and villa delivery orders.', nextRoute: '/provider/restaurant/menu');
}

class PropertyOwnerRegisterScreen extends StatelessWidget {
  const PropertyOwnerRegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => _ProviderRegForm(
    title: 'List Your Property', subtitle: 'LUXURY VILLA & RESORT CONCIERGE',
    desc: 'Offer oceanfront villas, penthouses, and private estates to elite island travelers.', nextRoute: '/provider/property/listings');
}

class _ProviderRegForm extends StatelessWidget {
  final String title, subtitle, desc, nextRoute;
  const _ProviderRegForm({required this.title, required this.subtitle, required this.desc, required this.nextRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background,
        leading: GestureDetector(onTap: () => Navigator.pop(context),
          child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(subtitle, style: AppTextStyles.cyanLabel),
        const SizedBox(height: 8),
        Text(title, style: AppTextStyles.displayMedium),
        const SizedBox(height: 8),
        Text(desc, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 28),
        _field('Full Legal Name', Icons.person_outline, 'e.g. James Thompson'),
        const SizedBox(height: 16),
        _field('Business / Email Address', Icons.mail_outline, 'business@example.bs'),
        const SizedBox(height: 16),
        _field('Bahamas Mobile', Icons.phone_outlined, '+1 (242) 555-0000'),
        const SizedBox(height: 16),
        _field('Business License No.', Icons.badge_outlined, 'BL-000000-NP'),
        const SizedBox(height: 16),
        _field('Password', Icons.lock_outline, ''),
        const SizedBox(height: 24),
        GSButton(label: 'Register & Continue →', onTap: () => Navigator.pushNamedAndRemoveUntil(context, nextRoute, (_) => false)),
        const SizedBox(height: 16),
        Center(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/login'),
          child: RichText(text: TextSpan(text: 'Already registered? ', style: AppTextStyles.bodyMedium,
            children: [TextSpan(text: 'Log In →', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan))])))),
        const SizedBox(height: 32),
      ])),
    );
  }

  Widget _field(String label, IconData icon, String hint) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: AppTextStyles.labelSmall),
      const SizedBox(height: 8),
      TextFormField(style: AppTextStyles.bodyLarge, obscureText: label.contains('Password'),
        decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20))),
    ]);
  }
}
