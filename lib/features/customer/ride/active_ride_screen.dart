import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_app_bar.dart';

class ActiveRideScreen extends StatelessWidget {
  const ActiveRideScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
          const Spacer(), Container(width: 40, height: 40, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle), child: const Icon(Icons.person, color: AppColors.background, size: 22)),
        ])),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)), const SizedBox(width: 8), Text('ACTIVE TRANSIT • TRIP #SW-8492', style: AppTextStyles.cyanLabel)]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('18 mins remaining', style: AppTextStyles.displayMedium),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.route, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text('14.2 km', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))])),
          ]),
          const SizedBox(height: 16),
          // Map
          _MapView(),
          const SizedBox(height: 16),
          // Driver card
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              Row(children: [
                Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: AppColors.cyan, width: 2)), child: const Icon(Icons.person, color: AppColors.cyan, size: 28)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Captain Terrence Rolle', style: AppTextStyles.headlineSmall),
                  Text('Official Licensed VIP Chauffeur #CH-402', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.star, size: 14, color: AppColors.gold), const SizedBox(width: 4), Text('4.98', style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold)), const SizedBox(width: 8), Text('620+ Trips', style: AppTextStyles.bodySmall)]),
                ])),
              ]),
              const SizedBox(height: 12),
              GestureDetector(onTap: () {},
                child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.phone_outlined, color: AppColors.cyan, size: 16), const SizedBox(width: 8), Text('Call Chauffeur', style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan))]))),
              const SizedBox(height: 12),
              // Vehicle
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                child: Row(children: [const Icon(Icons.directions_car, color: AppColors.textSecondary, size: 18), const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Cadillac Escalade ESV', style: AppTextStyles.titleMedium), Text('Onyx Black • Tinted Privacy Glass • Luggage Cap: 6 Bags', style: AppTextStyles.bodySmall)])),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6)), child: Text('BS-942-EX', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan))),
                ])),
            ])),
          const SizedBox(height: 20),
          // Navigate to completed
          GestureDetector(onTap: () => Navigator.pushNamed(context, '/customer/ride/completed'),
            child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.flag_outlined, color: AppColors.green, size: 18), const SizedBox(width: 8), Text('Simulate: Trip Completed →', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.green))]))),
          const SizedBox(height: 24),
        ]))),
      ])),
    );
  }
}

class _MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 220, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: const Color(0xFF1A2332), border: Border.all(color: AppColors.border)),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Stack(children: [
        CustomPaint(size: const Size(double.infinity, 220), painter: _BgPainter()),
        // Speed badge
        Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)), const SizedBox(width: 8), Text('58 km/h • Sir Milo Butler Hwy', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary))]))),
        // ETA badge
        Positioned(bottom: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.access_time, size: 12, color: AppColors.cyan), const SizedBox(width: 6), Text('Expected 4:18 PM  •  Smooth Island Traffic', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)), const SizedBox(width: 12),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(6)), child: Text('LIVE GPS', style: AppTextStyles.caption.copyWith(color: AppColors.background, fontWeight: FontWeight.w700)))]))),
        // Controls
        Positioned(right: 12, top: 12, child: Column(children: [_ctrl(Icons.my_location), const SizedBox(height: 8), _ctrl(Icons.layers_outlined)])),
      ])));
  }

  Widget _ctrl(IconData icon) => Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)), child: Icon(icon, size: 18, color: AppColors.textSecondary));
}

class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFF1A2332));
    final street = Paint()..color = const Color(0xFF243048)..strokeWidth = 6..strokeCap = StrokeCap.round;
    for (double y = 20; y < size.height; y += 35) canvas.drawLine(Offset(0, y), Offset(size.width, y), street);
    for (double x = 20; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), street);
    final hwy = Paint()..color = const Color(0xFF2D3F5C)..strokeWidth = 10;
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.3), hwy);
    // Route
    final route = Paint()..color = const Color(0xFF00D4FF)..strokeWidth = 3..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final p = Path()..moveTo(size.width * 0.15, size.height * 0.7)..cubicTo(size.width * 0.35, size.height * 0.55, size.width * 0.55, size.height * 0.4, size.width * 0.82, size.height * 0.2);
    canvas.drawPath(p, route);
    // Car
    canvas.drawCircle(Offset(size.width * 0.42, size.height * 0.48), 14, Paint()..color = const Color(0xFF00D4FF));
    canvas.drawCircle(Offset(size.width * 0.42, size.height * 0.48), 10, Paint()..color = const Color(0xFF0D1117));
    canvas.drawCircle(Offset(size.width * 0.42, size.height * 0.48), 6, Paint()..color = const Color(0xFF00D4FF));
  }
  @override bool shouldRepaint(_) => false;
}
