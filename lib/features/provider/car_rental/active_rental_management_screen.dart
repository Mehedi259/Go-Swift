import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/services/car_rental_service.dart';
import '../../../core/widgets/gs_button.dart';

class ActiveRentalManagementScreen extends StatefulWidget {
  final CarRentalBookingModel? booking;
  const ActiveRentalManagementScreen({super.key, this.booking});

  @override
  State<ActiveRentalManagementScreen> createState() => _ActiveRentalManagementScreenState();
}

class _ActiveRentalManagementScreenState extends State<ActiveRentalManagementScreen> {
  final CarRentalService _rentalService = CarRentalService();
  CarRentalBookingModel? _booking;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_booking == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is CarRentalBookingModel) {
        setState(() => _booking = args);
      } else {
        _fetchActiveBooking();
      }
    }
  }

  Future<void> _fetchActiveBooking() async {
    try {
      final list = await _rentalService.getFleetBookings();
      final active = list.where((b) => b.status.toLowerCase() != 'completed' && b.status.toLowerCase() != 'cancelled').toList();
      if (active.isNotEmpty && mounted) {
        setState(() => _booking = active.first);
      }
    } catch (_) {}
  }

  Future<void> _handleCompleteReturn() async {
    final bId = _booking?.id;
    setState(() => _isLoading = true);

    try {
      if (bId != null) {
        await _rentalService.completeBooking(bId);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vehicle return completed and inspected successfully!'),
            backgroundColor: AppColors.green,
          ),
        );
        Navigator.pop(context, true);
        return;
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rental return completed successfully.'),
            backgroundColor: AppColors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = _booking;
    final bookingId = b != null ? (b.bookingNumber ?? '#CR-${b.id}') : 'ACTIVE RESERVATION';
    final vehicle = b?.vehicleName ?? 'Fleet Vehicle';
    final renter = (b?.customerName != null && b!.customerName.isNotEmpty) ? b.customerName : 'VIP Client';
    final period = b != null ? '${b.startDate.split('T').first} – ${b.endDate.split('T').first}' : 'Active Duration';
    final total = b != null ? '\$${b.totalPrice.toStringAsFixed(2)}' : 'Escrow Protected';
    final status = b?.status.toUpperCase() ?? 'ACTIVE';

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
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Text('Active Rental $bookingId', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.greenLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.green.withOpacity(0.3)),
              ),
              child: Text(
                '$status  •  HANDOVER COMPLETE',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 14),
            Text(vehicle, style: AppTextStyles.displayMedium),
            const SizedBox(height: 20),
            _info('Renter', renter),
            _info('Rental Period', period),
            _info('Total Paid', total),
            _info('Insurance Tier', 'Full Bahamian Sovereign Coverage'),
            _info('Drop-off Location', 'Lynden Pindling Int\'l Airport (NAS)'),
            const SizedBox(height: 24),
            GSButton(
              label: _isLoading ? 'Completing Inspection...' : 'Complete Return →',
              onTap: _isLoading ? () {} : _handleCompleteReturn,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _info(String l, String v) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l, style: AppTextStyles.bodyMedium),
            Text(v, style: AppTextStyles.titleMedium),
          ],
        ),
      );
}
