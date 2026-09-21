import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class SupportScreen extends StatelessWidget {
  final bool embedded;
  const SupportScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final _faqs = [
      {'q': 'How do I cancel a ride?', 'a': 'You can cancel a ride from the active ride screen before the driver arrives. Cancellations may incur a fee after driver acceptance.'},
      {'q': 'How is the fare calculated?', 'a': 'Fares are calculated based on distance, vehicle type, and island traffic conditions. All prices are in BSD/USD (1:1).'},
      {'q': 'Is my data secure?', 'a': 'All personal data is encrypted and stored securely in compliance with Bahamian data protection laws.'},
      {'q': 'How do I contact a driver?', 'a': 'Once a driver is assigned, you can call or message them directly from the ride tracking screen.'},
    ];
    final content = Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Support & Help', style: AppTextStyles.headlineLarge),
        Text('We\'re here to help you 24/7', style: AppTextStyles.bodyMedium),
      ])),
      const SizedBox(height: 20),
      // Quick contact
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [
        Expanded(child: _contactBtn(Icons.phone_outlined, 'Call Support', AppColors.cyan, () {})),
        const SizedBox(width: 12),
        Expanded(child: _contactBtn(Icons.chat_outlined, 'Live Chat', AppColors.teal, () {})),
        const SizedBox(width: 12),
        Expanded(child: _contactBtn(Icons.mail_outlined, 'Email', AppColors.gold, () {})),
      ])),
      const SizedBox(height: 20),
      // Live chat
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0A2030), Color(0xFF0D1117)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cyan.withOpacity(0.3))),
        child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle), child: const Icon(Icons.support_agent, color: AppColors.background, size: 24)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)), const SizedBox(width: 6), Text('CONCIERGE ONLINE', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green))]), Text('Live Concierge Chat', style: AppTextStyles.titleLarge), Text('Avg. response: 2 minutes', style: AppTextStyles.bodySmall)])), const Icon(Icons.arrow_forward, color: AppColors.cyan, size: 20)]))),
      const SizedBox(height: 20),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('Frequently Asked Questions', style: AppTextStyles.headlineSmall)),
      const SizedBox(height: 12),
      Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: _faqs.length, itemBuilder: (c, i) => _FAQTile(q: _faqs[i]['q']!, a: _faqs[i]['a']!))),
    ]);
    return embedded ? content : Scaffold(body: SafeArea(child: content));
  }

  Widget _contactBtn(IconData icon, String label, Color color, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.3))), child: Column(children: [Icon(icon, color: color, size: 22), const SizedBox(height: 6), Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600))])));
}

class _FAQTile extends StatefulWidget {
  final String q, a;
  const _FAQTile({required this.q, required this.a});
  @override State<_FAQTile> createState() => _FAQTileState();
}
class _FAQTileState extends State<_FAQTile> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => setState(() => _open = !_open),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: _open ? AppColors.cyan.withOpacity(0.4) : AppColors.border, width: 0.5)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text(widget.q, style: AppTextStyles.titleMedium)), Icon(_open ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary, size: 20)]),
          if (_open) ...[const SizedBox(height: 8), Text(widget.a, style: AppTextStyles.bodyMedium)],
        ])));
  }
}
