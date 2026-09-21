import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});
  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  int _vehicleType = 0;
  final _vehicles = ['Luxury SUV\nCadillac Escalade, Lincoln Navigator, Yukon Denali', 'Executive Sedan\nMercedes S-Class, BMW 7-Series, Genesis G90', 'VIP Sprinter / Van\nMercedes-Benz Sprinter Executive, Ford Transit VIP'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context),
            child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        ])),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF1A2B40), Color(0xFF0F1D2E)]), borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.cyan), const SizedBox(width: 6), Text('BAHAMAS CHAUFFEUR & PROVIDER NETWORK', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan))]),
              const SizedBox(height: 12),
              Text('Join As A Chauffeur\nPartner', style: AppTextStyles.displayMedium),
              const SizedBox(height: 8),
              Text("Drive with Nassau & Paradise Island's premier luxury mobility network.", style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Step 1 of 3: Account &\nCredentials', style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan)), const SizedBox(height: 4),
                  Row(children: [_stepTab('1. ACCOUNT', true), _stepTab('2.DOCUMENTS', false), _stepTab('3. VEHICLE', false)])]),
                Text('33%\nCompleted', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold)),
              ]),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: 0.33, backgroundColor: AppColors.border, color: AppColors.cyan),
            ])),
          const SizedBox(height: 24),
          // Photo upload
          Text('Your Photo', style: AppTextStyles.labelSmall),
          const SizedBox(height: 8),
          Container(height: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, style: BorderStyle.solid)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.add_photo_alternate_outlined, color: AppColors.textSecondary, size: 32),
              const SizedBox(height: 8), Text('Browse Gallery', style: AppTextStyles.bodyMedium)])),
          const SizedBox(height: 20),
          _buildField('Full Legal Name', 'As on official driver badge', 'e.g. Terrence Rolle', Icons.badge_outlined),
          const SizedBox(height: 16),
          _buildField('Email Address', null, 'e.g. terrence.rolle@swiftpartner.bs', Icons.mail_outline),
          const SizedBox(height: 16),
          _buildField('Mobile Phone Number', 'For instant VIP ride dispatch alerts & SMS verification.', '555-0188', Icons.phone_outlined, prefix: '🇧🇸 +1 (242) '),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Public Service Driver's License", style: AppTextStyles.labelSmall), Text('Required', style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold))]),
          const SizedBox(height: 8),
          TextFormField(style: AppTextStyles.bodyLarge, decoration: const InputDecoration(hintText: 'E.G. PSL-40291-NP',
            prefixIcon: Icon(Icons.verified_user_outlined, color: AppColors.cyan, size: 20))),
          const SizedBox(height: 6),
          Text('Bahamas Road Traffic Dept valid public service chauffeur endorsement.', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          Text('Vehicle Category', style: AppTextStyles.labelSmall),
          const SizedBox(height: 8),
          ..._vehicles.asMap().entries.map((e) => GestureDetector(onTap: () => setState(() => _vehicleType = e.key),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: _vehicleType == e.key ? AppColors.cyan : AppColors.border)),
              child: Row(children: [const Icon(Icons.directions_car, color: AppColors.textSecondary), const SizedBox(width: 12),
                Expanded(child: Text(e.value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))),
                Container(width: 22, height: 22, decoration: BoxDecoration(color: _vehicleType == e.key ? AppColors.cyan : Colors.transparent, shape: BoxShape.circle, border: Border.all(color: _vehicleType == e.key ? AppColors.cyan : AppColors.border)),
                  child: _vehicleType == e.key ? const Icon(Icons.check, size: 12, color: AppColors.background) : null)])))),
          const SizedBox(height: 16),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Checkbox(value: true, onChanged: (_) {}, activeColor: AppColors.cyan, checkColor: AppColors.background, side: const BorderSide(color: AppColors.border)),
            Expanded(child: RichText(text: TextSpan(text: 'I agree to the ', style: AppTextStyles.bodySmall,
              children: [TextSpan(text: 'GO SWIFT Provider Terms of Service', style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan)),
                const TextSpan(text: ', Chauffeur Code of Conduct, and Bahamian Road Traffic compliance guidelines.')])))]),
          const SizedBox(height: 20),
          GSButton(label: 'Continue to Driver profile →', onTap: () => Navigator.pushNamed(context, '/provider/driver/hub')),
          const SizedBox(height: 8),
          Center(child: Text('Next: Set up your Driver Profile, vehicle specs & payout account.', style: AppTextStyles.bodySmall, textAlign: TextAlign.center)),
          const SizedBox(height: 16),
          Center(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/login'),
            child: RichText(text: TextSpan(text: 'Already an approved GO SWIFT Provider? ', style: AppTextStyles.bodySmall,
              children: [TextSpan(text: 'Log In →', style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan))])))),
          const SizedBox(height: 32),
        ]))),
      ])),
    );
  }

  Widget _stepTab(String label, bool active) => Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: active ? AppColors.cyan.withOpacity(0.2) : Colors.transparent, borderRadius: BorderRadius.circular(20), border: Border.all(color: active ? AppColors.cyan : AppColors.border, width: 0.5)),
    child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: active ? AppColors.cyan : AppColors.textMuted)));

  Widget _buildField(String label, String? hint, String placeholder, IconData icon, {String? prefix}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.labelSmall),
      if (hint != null) ...[const SizedBox(height: 2), Text(hint, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted))],
      const SizedBox(height: 8),
      TextFormField(style: AppTextStyles.bodyLarge, decoration: InputDecoration(hintText: prefix != null ? null : placeholder,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        prefix: prefix != null ? Text(prefix, style: AppTextStyles.bodyLarge) : null)),
    ]);
  }
}
