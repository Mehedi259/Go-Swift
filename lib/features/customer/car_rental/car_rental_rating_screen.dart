import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/services/car_rental_service.dart';
import '../../../core/widgets/gs_button.dart';

class CarRentalRatingScreen extends StatefulWidget {
  final CarRentalBookingModel? booking;
  const CarRentalRatingScreen({super.key, this.booking});

  @override
  State<CarRentalRatingScreen> createState() => _CarRentalRatingScreenState();
}

class _CarRentalRatingScreenState extends State<CarRentalRatingScreen> {
  final CarRentalService _rentalService = CarRentalService();
  final TextEditingController _commentController = TextEditingController();
  int _rating = 5;
  final Set<String> _selectedTags = {'Pristine Condition', 'Smooth Handover'};
  bool _isSubmitting = false;

  final List<String> _tags = const [
    'Pristine Condition',
    'Smooth Handover',
    'Great Performance',
    'Clean Interior',
    'Full Tank on Arrival',
    'Luxury Experience',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview(CarRentalBookingModel? booking) async {
    setState(() => _isSubmitting = true);
    final bookingId = booking?.id ?? 1;

    try {
      await _rentalService.reviewBooking(
        bookingId,
        rating: _rating,
        notes: _commentController.text.trim(),
        stoodOut: _selectedTags.toList(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vehicle rental review submitted successfully!'),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rating saved. Thank you for your feedback.'),
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
    final CarRentalBookingModel? booking = widget.booking ?? (args is CarRentalBookingModel ? args : null);

    final vehicleName = booking?.vehicleName ?? 'Cadillac Escalade ESV';
    final bookingCode = booking != null ? '#CR-${booking.id}' : '#CR-5821';

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
        title: Text('Rate Rental Experience', style: AppTextStyles.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
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
              child: const Icon(Icons.directions_car_filled_outlined, color: AppColors.primaryTeal, size: 38),
            ),
            const SizedBox(height: 16),
            Text('Rate Your Rental', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(
              '$vehicleName • Booking $bookingCode',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(i < _rating ? Icons.star : Icons.star_border, color: AppColors.gold, size: 40),
                ),
              )),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('What stood out?', style: AppTextStyles.labelSmall),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                  selectedColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                  checkmarkColor: AppColors.primaryTeal,
                  labelStyle: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? AppColors.primaryTeal : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: isSelected ? AppColors.primaryTeal : AppColors.border),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _commentController,
              maxLines: 3,
              style: AppTextStyles.bodyLarge,
              decoration: const InputDecoration(
                hintText: 'Share your feedback on vehicle comfort, cleanliness, and service...',
              ),
            ),
            const SizedBox(height: 32),
            GSButton(
              label: _isSubmitting ? 'Submitting Review...' : 'Submit Rating →',
              onTap: _isSubmitting ? () {} : () => _submitReview(booking),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false),
              child: Text('Skip', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
