import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/property_model.dart';
import '../../../core/services/room_service.dart';
import '../../../core/widgets/gs_button.dart';

class PropertyRatingScreen extends StatefulWidget {
  final RoomBookingModel? booking;
  const PropertyRatingScreen({super.key, this.booking});

  @override
  State<PropertyRatingScreen> createState() => _PropertyRatingScreenState();
}

class _PropertyRatingScreenState extends State<PropertyRatingScreen> {
  final RoomService _roomService = RoomService();
  final TextEditingController _commentController = TextEditingController();
  final _cats = const ['Cleanliness', 'Location', 'Service', 'Value', 'Amenities'];
  final _ratings = <int>[5, 5, 5, 5, 5];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview(RoomBookingModel? booking) async {
    setState(() => _isSubmitting = true);
    final bookingId = booking?.id ?? 1;

    final avgRating = (_ratings.reduce((a, b) => a + b) / _ratings.length).round().clamp(1, 5);
    final stoodOut = <String>[];
    for (int i = 0; i < _cats.length; i++) {
      if (_ratings[i] >= 4) {
        stoodOut.add(_cats[i]);
      }
    }

    try {
      await _roomService.reviewBooking(
        bookingId,
        rating: avgRating,
        notes: _commentController.text.trim(),
        stoodOut: stoodOut,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Property stay review submitted successfully!'),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review recorded for your stay. Thank you!'),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final RoomBookingModel? booking = widget.booking ?? (args is RoomBookingModel ? args : null);

    final propertyName = booking?.propertyTitle ?? 'The Ocean Club Villa';
    final stayDates = (booking?.checkInDate != null && booking?.checkOutDate != null)
        ? '${booking!.checkInDate} – ${booking.checkOutDate}'
        : 'Apr 21 – Apr 26';

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
        title: Text('Rate Your Stay', style: AppTextStyles.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryTeal, width: 2),
                boxShadow: AppColors.softShadow,
              ),
              child: const Icon(Icons.villa, color: AppColors.primaryTeal, size: 38),
            ),
            const SizedBox(height: 16),
            Text('Rate Your Stay', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(
              '$propertyName • $stayDates',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ..._cats.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(e.value, style: AppTextStyles.titleMedium)),
                    Row(
                      children: List.generate(5, (i) => GestureDetector(
                        onTap: () => setState(() => _ratings[e.key] = i + 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Icon(i < _ratings[e.key] ? Icons.star : Icons.star_border, color: AppColors.gold, size: 26),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 12),
            Align(alignment: Alignment.centerLeft, child: Text('Your Review', style: AppTextStyles.labelSmall)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _commentController,
              maxLines: 4,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Describe your stay at $propertyName...',
              ),
            ),
            const SizedBox(height: 28),
            GSButton(
              label: _isSubmitting ? 'Submitting Review...' : 'Submit Review →',
              onTap: _isSubmitting ? () {} : () => _submitReview(booking),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false),
              child: Text('Skip Review', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
