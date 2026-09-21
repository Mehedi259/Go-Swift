import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class DriverActiveRideScreen extends StatelessWidget {
  const DriverActiveRideScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)), const SizedBox(width: 6), Text('ACTIVE TRIP', style: AppTextStyles.labelSmall.copyWith(color: AppColors.green))])),
        ])),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('TRIP #SW-8521', style: AppTextStyles.cyanLabel),
          const SizedBox(height: 8),
          Text('En Route to\nDestination', style: AppTextStyles.displayMedium),
          const SizedBox(height: 16),
          // Map
          Container(height: 200, decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Stack(children: [
              ClipRRect(borderRadius: BorderRadius.circular(16), child: CustomPaint(size: const Size(double.infinity, 200), painter: _MapBg())),
              Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.9), borderRadius: BorderRadius.circular(20)), child: Text('58 km/h  •  Sir Milo Butler Hwy', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary)))),
            ])),
          const SizedBox(height: 16),
          // Passenger card
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, width: 0.5)),
            child: Column(children: [
              Row(children: [Container(width: 52, height: 52, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle), child: const Icon(Icons.person, color: AppColors.background, size: 26)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Alexander Vance', style: AppTextStyles.headlineSmall), Text('Platinum Member  •  4.98 ★', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold))])), GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.phone_outlined, color: AppColors.cyan, size: 20)))]),
              const SizedBox(height: 12),
              Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.cyan, size: 16), const SizedBox(width: 8), Expanded(child: Text('Lynden Pindling Int\'l Airport (NAS)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)))]),
              const SizedBox(height: 4),
              Row(children: [const Icon(Icons.flag_outlined, color: AppColors.gold, size: 16), const SizedBox(width: 8), Expanded(child: Text('The Ocean Club, Four Seasons', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)))]),
            ])),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _infoBox('Est. Fare', '\$118.50', AppColors.gold)),
            const SizedBox(width: 12), Expanded(child: _infoBox('ETA', '8 min', AppColors.cyan)),
            const SizedBox(width: 12), Expanded(child: _infoBox('Distance', '6.4 km', AppColors.textSecondary)),
          ]),
          const SizedBox(height: 20),
          GSButton(label: 'Complete Trip →', onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/provider/driver/hub', (_) => false)),
          const SizedBox(height: 24),
        ]))),
      ])),
    );
  }
  Widget _infoBox(String l, String v, Color color) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 0.5)), child: Column(children: [Text(l, style: AppTextStyles.bodySmall), const SizedBox(height: 4), Text(v, style: AppTextStyles.titleMedium.copyWith(color: color))]));
}

class _MapBg extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFF1A2332));
    final street = Paint()..color = const Color(0xFF243048)..strokeWidth = 6;
    for (double y = 20; y < size.height; y += 35) canvas.drawLine(Offset(0, y), Offset(size.width, y), street);
    for (double x = 20; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), street);
    final hwy = Paint()..color = const Color(0xFF2D3F5C)..strokeWidth = 10;
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.3), hwy);
    final route = Paint()..color = const Color(0xFF00D4FF)..strokeWidth = 3..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final p = Path()..moveTo(size.width * 0.2, size.height * 0.65)..cubicTo(size.width * 0.4, size.height * 0.5, size.width * 0.6, size.height * 0.35, size.width * 0.8, size.height * 0.2);
    canvas.drawPath(p, route);
    canvas.drawCircle(Offset(size.width * 0.52, size.height * 0.43), 12, Paint()..color = const Color(0xFF00D4FF));
    canvas.drawCircle(Offset(size.width * 0.52, size.height * 0.43), 8, Paint()..color = const Color(0xFF0D1117));
    canvas.drawCircle(Offset(size.width * 0.52, size.height * 0.43), 5, Paint()..color = const Color(0xFF00D4FF));
  }
  @override bool shouldRepaint(_) => false;
}
