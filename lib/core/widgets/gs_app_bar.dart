import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class GSAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final Widget? trailing;
  final bool showLogo;

  const GSAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.trailing,
    this.showLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: showBack
          ? GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.softShadow,
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
              ),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLogo) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.cyan,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Text(title, style: AppTextStyles.titleLarge),
        ],
      ),
      actions: [if (trailing != null) Padding(padding: const EdgeInsets.only(right: 16), child: trailing!)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

// Light Map widget for tracking screens
class GSMapWidget extends StatelessWidget {
  final String origin;
  final String destination;
  final double height;

  const GSMapWidget({
    super.key,
    this.origin = 'NAS Jet Gate',
    this.destination = 'The Ocean Club',
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFEAF3F9),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            CustomPaint(
              size: Size(double.infinity, height),
              painter: _MapPainter(),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _RoutePainter(),
              ),
            ),
            // Speed badge
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text('58 km/h • Sir Milo Butler Hwy', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ),
            // Destination badge
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: AppColors.softShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.hotel, size: 14, color: AppColors.gold),
                    const SizedBox(width: 6),
                    Text(destination.toUpperCase(), style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            // Map controls
            Positioned(
              right: 12,
              bottom: 12,
              child: Column(
                children: [
                  _mapControl(Icons.my_location),
                  const SizedBox(height: 8),
                  _mapControl(Icons.layers_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapControl(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Icon(icon, size: 18, color: AppColors.cyan),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFEAF3F9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final streetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (double y = 20; y < size.height; y += 35) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), streetPaint);
    }
    for (double x = 20; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), streetPaint);
    }

    final hwyPaint = Paint()
      ..color = const Color(0xFFD3E4F0)
      ..strokeWidth = 10;
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.4), hwyPaint);

    final originPaint = Paint()..color = AppColors.cyan;
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.55), 10, originPaint);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.55), 7, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.55), 4, originPaint);
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..color = AppColors.cyan
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.25, size.height * 0.55);
    path.cubicTo(
      size.width * 0.4, size.height * 0.5,
      size.width * 0.6, size.height * 0.35,
      size.width * 0.8, size.height * 0.25,
    );
    canvas.drawPath(path, routePaint);

    final destPaint = Paint()..color = AppColors.gold;
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.25), 10, destPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.25), 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_RoutePainter oldDelegate) => false;
}
