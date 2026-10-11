import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/property_model.dart';
import '../../../core/services/room_service.dart';
import '../../../core/widgets/gs_button.dart';

class PropertyBookingScreen extends StatefulWidget {
  const PropertyBookingScreen({super.key});

  @override
  State<PropertyBookingScreen> createState() => _PropertyBookingScreenState();
}

class _PropertyBookingScreenState extends State<PropertyBookingScreen> {
  bool _isSubmitting = false;
  final TextEditingController _nameController = TextEditingController(text: 'Alexander Vance');
  final TextEditingController _emailController = TextEditingController(text: 'alexander@goswift.bs');
  final TextEditingController _phoneController = TextEditingController(text: '+1 (242) 555-0199');
  final TextEditingController _guestsController = TextEditingController(text: '4');
  final TextEditingController _notesController = TextEditingController(text: 'Butler arrival greeting and chilled island coconut water.');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _guestsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    setState(() => _isSubmitting = true);
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      int listingId = 1;
      if (args is PropertyListingModel) {
        listingId = args.id;
      } else if (args is Map && args['id'] is int) {
        listingId = args['id'] as int;
      }

      final booking = await RoomService().createBooking(
        listingId: listingId,
        checkInDate: '2026-04-21',
        checkOutDate: '2026-04-26',
        numberOfPersons: int.tryParse(_guestsController.text.trim()) ?? 2,
        primaryGuestName: _nameController.text.trim(),
        primaryGuestEmail: _emailController.text.trim(),
        primaryGuestContact: _phoneController.text.trim(),
        guestNote: _notesController.text.trim(),
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reservation confirmed: #${booking.bookingNumber ?? booking.id}'),
            backgroundColor: AppColors.primaryTeal,
          ),
        );
        Navigator.pushNamed(context, '/customer/properties/rating', arguments: booking);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking dispatched: $e'),
            backgroundColor: AppColors.primaryNavy,
          ),
        );
        Navigator.pushNamed(context, '/customer/properties/rating');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final PropertyListingModel? listing = args is PropertyListingModel ? args : null;
    final propName = listing?.title ?? 'The Ocean Club Villa';
    final ratePerNight = listing?.pricePerNight != null
        ? '\$${listing!.pricePerNight.toStringAsFixed(0)}/night'
        : '\$1,850/night';
    final totalAmount = listing?.pricePerNight != null
        ? '\$${((listing!.pricePerNight * 5) * 1.1).toStringAsFixed(2)}'
        : '\$10,175.00';

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
        title: Text('Confirm Property Booking', style: AppTextStyles.titleLarge),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(propName, style: AppTextStyles.headlineLarge),
                  const SizedBox(height: 4),
                  Text('Apr 21 – Apr 26, 2026 • 5 nights', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  Text('GUEST INFORMATION', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(hintText: 'Lead Guest Name', prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary, size: 20)),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(hintText: 'Email', prefixIcon: Icon(Icons.mail_outline, color: AppColors.textSecondary, size: 20)),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(hintText: 'Mobile Phone', prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 20)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('NUMBER OF GUESTS', style: AppTextStyles.labelSmall),
                      Text('Max: ${listing?.maxGuests ?? 12}', style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _guestsController,
                    style: AppTextStyles.bodyLarge,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.people_outline, color: AppColors.textSecondary, size: 20)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    style: AppTextStyles.bodyMedium,
                    decoration: const InputDecoration(hintText: 'Special requests for butler or concierge...'),
                  ),
                  const SizedBox(height: 24),
                  Text('ADD-ON SERVICES', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  ...[
                    {'label': 'Private Chef (5 nights)', 'price': '+\$1,500', 'icon': Icons.restaurant},
                    {'label': 'Airport Transfer (both ways)', 'price': '+\$240', 'icon': Icons.flight},
                    {'label': 'Yacht Charter (half day)', 'price': '+\$2,200', 'icon': Icons.sailing},
                  ].map((a) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: AppColors.badgeTeal, borderRadius: BorderRadius.circular(10)),
                          child: Icon(a['icon'] as IconData, color: AppColors.primaryTeal, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(a['label'] as String, style: AppTextStyles.titleMedium)),
                        Text(a['price'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: AppColors.cyanPill,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 16, color: AppColors.primaryTeal),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      children: [
                        _row('5 nights × $ratePerNight', totalAmount),
                        _row('Butler & Concierge Service', 'Included'),
                        _row('Daily Housekeeping', 'Included'),
                        _row('Taxes & Fees', '\$925.00'),
                        const Divider(color: AppColors.border),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TOTAL', style: AppTextStyles.headlineSmall),
                            Text(totalAmount, style: AppTextStyles.price.copyWith(fontSize: 22)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GSButton(
              label: 'Confirm Booking • $totalAmount →',
              isLoading: _isSubmitting,
              onTap: _isSubmitting ? null : _submitBooking,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: AppTextStyles.bodyMedium),
        Text(v, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary)),
      ],
    ),
  );
}
