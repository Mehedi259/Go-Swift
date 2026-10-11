import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/storage/local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    await LocalStorage.init();
    if (!mounted) return;

    if (LocalStorage.isLoggedIn) {
      final role = (LocalStorage.getUserRole() ?? 'customer').toLowerCase();
      String destination = '/customer/hub';

      if (role.contains('driver') || role.contains('chauffeur')) {
        destination = '/provider/driver/hub';
      } else if (role.contains('courier')) {
        destination = '/provider/courier/hub';
      } else if (role.contains('restaurant')) {
        destination = '/provider/restaurant/orders';
      } else if (role.contains('rental')) {
        destination = '/provider/rental/vehicles';
      } else if (role.contains('property')) {
        destination = '/provider/property/listings';
      }

      Navigator.pushReplacementNamed(context, destination);
    } else {
      Navigator.pushReplacementNamed(context, '/choose-account');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.25), width: 2),
                            boxShadow: AppColors.softShadow,
                            image: const DecorationImage(
                              image: AssetImage('assets/images/AppLogo.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Brand name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('GO ', style: GoogleFonts.outfit(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            )),
                            Text('SWIFT', style: GoogleFonts.outfit(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryTeal,
                            )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // BAHAMAS badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.badgeGold,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFF3C78E)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFB87800), shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Text('BAHAMAS', style: AppTextStyles.labelSmall.copyWith(color: const Color(0xFF8A5300), letterSpacing: 3, fontWeight: FontWeight.w700)),
                              const SizedBox(width: 8),
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFB87800), shape: BoxShape.circle)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text('SOVEREIGN MOBILITY & CONCIERGE',
                            style: AppTextStyles.cyanLabel.copyWith(letterSpacing: 2, color: AppColors.primaryTeal)),
                        const SizedBox(height: 14),
                        Text(
                          'Private Chauffeured Transit ✦ Yacht Charters ✦\nBespoke Air Liaison',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Footer
              Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_outlined, color: AppColors.primaryTeal, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'LICENSED BY THE ROAD TRAFFIC DEPARTMENT OF THE BAHAMAS',
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
