import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

// Courier Provider Screens

class CourierAvailabilityScreen extends StatefulWidget {
  const CourierAvailabilityScreen({super.key});
  @override State<CourierAvailabilityScreen> createState() => _CourierAvailabilityScreenState();
}
class _CourierAvailabilityScreenState extends State<CourierAvailabilityScreen> {
  bool _online = true;
  int _nav = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Row(children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.bolt, color: AppColors.background, size: 20)),
          const SizedBox(width: 8), Text('Courier Hub', style: AppTextStyles.titleLarge.copyWith(color: AppColors.cyan)), const Spacer(),
        ])),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Status card
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0A2030), Color(0xFF0D1117)]), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.cyan.withOpacity(0.2))),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Marcus Rolle', style: AppTextStyles.headlineMedium), Text('Bonded Courier  •  #BC-182', style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan))]),
                Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle, border: Border.all(color: AppColors.cyan.withOpacity(0.4), width: 3)), child: const Icon(Icons.delivery_dining, color: AppColors.background, size: 28)),
              ]),
              const SizedBox(height: 16),
              Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.3), borderRadius: BorderRadius.circular(14)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_online ? 'ONLINE' : 'OFFLINE', style: AppTextStyles.labelSmall.copyWith(color: _online ? AppColors.green : AppColors.textMuted)), Text(_online ? 'Ready for parcels' : 'Not accepting jobs', style: AppTextStyles.titleMedium)]),
                  GestureDetector(onTap: () => setState(() => _online = !_online),
                    child: AnimatedContainer(duration: const Duration(milliseconds: 300), width: 64, height: 36, decoration: BoxDecoration(color: _online ? AppColors.green : AppColors.surface, borderRadius: BorderRadius.circular(20)),
                      child: AnimatedAlign(duration: const Duration(milliseconds: 300), alignment: _online ? Alignment.centerRight : Alignment.centerLeft, child: Container(width: 28, height: 28, margin: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))))),
                ])),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _stat('Today', '\$182.00', AppColors.gold)),
                const SizedBox(width: 12), Expanded(child: _stat('Deliveries', '6', AppColors.cyan)),
              ]),
            ])),
          const SizedBox(height: 24),
          Text('Incoming Parcel Request', style: AppTextStyles.headlineSmall), const SizedBox(height: 12),
          // Request card
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
            child: Column(children: [
              Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text('BONDED PARCEL', style: AppTextStyles.goldLabel)), const Spacer(), Text('\$42.00', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold))]),
              const SizedBox(height: 12),
              Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.cyan, size: 16), const SizedBox(width: 8), Text('Graycliff Boutique, Nassau', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))]),
              const SizedBox(height: 4),
              Row(children: [const Icon(Icons.flag_outlined, color: AppColors.gold, size: 16), const SizedBox(width: 8), Text('The Ocean Club, Paradise Island', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))]),
              const SizedBox(height: 12),
              Row(children: [Expanded(child: GSButton(label: 'Decline', isSecondary: true, onTap: () {})), const SizedBox(width: 12), Expanded(flex: 2, child: GSButton(label: 'Accept →', onTap: () => Navigator.pushNamed(context, '/provider/courier/active')))]),
            ])),
        ]))),
      ])),
      bottomNavigationBar: _nav_(context),
    );
  }
  Widget _stat(String l, String v, Color color) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.3), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: AppTextStyles.bodySmall), const SizedBox(height: 4), Text(v, style: AppTextStyles.headlineSmall.copyWith(color: color))]));
  Widget _nav_(BuildContext context) => Container(decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.border, width: 0.5))), child: SafeArea(top: false, child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
    _ni(Icons.home_outlined, 'Home', 0), _ni(Icons.receipt_long_outlined, 'History', 1), _ni(Icons.attach_money, 'Earnings', 2), _ni(Icons.person_outline, 'Profile', 3)]))));
  Widget _ni(IconData icon, String label, int idx) => GestureDetector(onTap: () => setState(() => _nav = idx), behavior: HitTestBehavior.opaque, child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: _nav == idx ? AppColors.cyan : AppColors.textMuted, size: 24), const SizedBox(height: 4), Text(label, style: AppTextStyles.caption.copyWith(color: _nav == idx ? AppColors.cyan : AppColors.textMuted))]));
}
