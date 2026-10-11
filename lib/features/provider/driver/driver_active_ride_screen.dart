import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_button.dart';

class DriverActiveRideScreen extends StatelessWidget {
  const DriverActiveRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.greenLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ACTIVE TRIP',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TRIP #SW-8521', style: AppTextStyles.cyanLabel),
                    const SizedBox(height: 6),
                    Text('En Route to\nDestination', style: AppTextStyles.displayMedium),
                    const SizedBox(height: 16),
                    // Light Coastal Island Map
                    Container(
                      height: 210,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5F9),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CustomPaint(
                              size: const Size(double.infinity, 210),
                              painter: _DriverMapPainter(),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.border),
                                boxShadow: AppColors.cardShadow,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.navigation, color: AppColors.cyan, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    '58 km/h • Sir Milo Butler Hwy',
                                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Passenger card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.cyanLight,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.cyan, width: 1.5),
                                ),
                                child: const Icon(Icons.person, color: AppColors.cyan, size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Alexander Vance', style: AppTextStyles.headlineSmall),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: AppColors.gold, size: 14),
                                        const SizedBox(width: 4),
                                        Text('Platinum Member • 4.98 ★', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.cyanLight,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.phone_outlined, color: AppColors.cyan, size: 20),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Divider(color: AppColors.border, height: 1),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.radio_button_checked, color: AppColors.cyan, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text('Lynden Pindling Int\'l Airport (NAS)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: AppColors.gold, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text('The Ocean Club, Four Seasons', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _infoBox('Est. Fare', '\$118.50', AppColors.gold)),
                        const SizedBox(width: 12),
                        Expanded(child: _infoBox('ETA', '8 min', AppColors.cyan)),
                        const SizedBox(width: 12),
                        Expanded(child: _infoBox('Distance', '6.4 km', AppColors.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GSButton(
                      label: 'Complete Trip →',
                      onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/provider/driver/hub', (_) => false),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String label, String value, Color color) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.cardShadow,
    ),
    child: Column(
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.titleMedium.copyWith(color: color, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

class _DriverMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Light coastal water background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFFE4F4F9));

    // Land mass
    final islandPath = Path()
      ..moveTo(0, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.05, size.width * 0.7, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.95, size.height * 0.4, size.width, size.height * 0.85)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(islandPath, Paint()..color = const Color(0xFFF3F9FC));

    // Local streets
    final streetPaint = Paint()
      ..color = const Color(0xFFDFEDF5)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    for (double y = 30; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), streetPaint);
    }
    for (double x = 30; x < size.width; x += 45) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), streetPaint);
    }

    // Main highway
    final hwyPaint = Paint()
      ..color = const Color(0xFFCFE4EE)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.35), hwyPaint);

    // Sovereign Teal route
    final routePaint = Paint()
      ..color = AppColors.cyan
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final routePath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.7)
      ..cubicTo(size.width * 0.4, size.height * 0.55, size.width * 0.55, size.height * 0.42, size.width * 0.82, size.height * 0.25);
    canvas.drawPath(routePath, routePaint);

    // Vehicle position indicator
    final vehiclePos = Offset(size.width * 0.52, size.height * 0.45);
    canvas.drawCircle(vehiclePos, 14, Paint()..color = AppColors.cyan.withOpacity(0.2));
    canvas.drawCircle(vehiclePos, 9, Paint()..color = AppColors.cyan);
    canvas.drawCircle(vehiclePos, 5, Paint()..color = Colors.white);
    canvas.drawCircle(vehiclePos, 2.5, Paint()..color = AppColors.cyan);
  }

  @override
  bool shouldRepaint(_) => false;
}
