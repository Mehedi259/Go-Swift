import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/property_model.dart';
import '../../../core/services/room_service.dart';
import '../../../core/widgets/gs_button.dart';
import '../../../core/widgets/gs_card.dart';

class BookingRequestsScreen extends StatefulWidget {
  const BookingRequestsScreen({super.key});

  @override
  State<BookingRequestsScreen> createState() => _BookingRequestsScreenState();
}

class _BookingRequestsScreenState extends State<BookingRequestsScreen> {
  final RoomService _roomService = RoomService();
  bool _isLoading = true;
  List<RoomBookingModel> _bookings = [];
  int? _actionBookingId;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    try {
      final list = await _roomService.getProviderBookings();
      if (mounted) {
        setState(() {
          _bookings = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleConfirm(int bookingId) async {
    setState(() => _actionBookingId = bookingId);
    try {
      await _roomService.confirmBooking(bookingId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking confirmed successfully!'),
            backgroundColor: AppColors.green,
          ),
        );
        _loadBookings();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error confirming booking: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _actionBookingId = null);
      }
    }
  }

  Future<void> _handleDecline(int bookingId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Decline Booking', style: AppTextStyles.titleLarge),
        content: Text('Are you sure you want to decline this booking reservation?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Decline'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _actionBookingId = bookingId);
    try {
      await _roomService.declineBooking(bookingId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking reservation declined'),
            backgroundColor: AppColors.textSecondary,
          ),
        );
        _loadBookings();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error declining booking: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _actionBookingId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingBookings = _bookings.where((b) => b.status.toLowerCase() != 'completed' && b.status.toLowerCase() != 'cancelled').toList();

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
        title: Text('Booking Requests', style: AppTextStyles.titleLarge),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/provider/property/past-bookings'),
            child: Text('History', style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan, fontSize: 14)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
          : RefreshIndicator(
              onRefresh: _loadBookings,
              color: AppColors.cyan,
              child: pendingBookings.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_month_outlined, size: 56, color: AppColors.cyan),
                            const SizedBox(height: 16),
                            Text('No Pending Requests', style: AppTextStyles.headlineSmall),
                            const SizedBox(height: 8),
                            Text(
                              'When high-net-worth guests request a stay at your sovereign properties, they will appear here.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: pendingBookings.length,
                      itemBuilder: (c, i) {
                        final r = pendingBookings[i];
                        final isActioning = _actionBookingId == r.id;
                        final isPending = r.status.toLowerCase() == 'pending' || r.status.toLowerCase() == 'requested';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(r.bookingNumber ?? '#PB-${r.id}', style: AppTextStyles.cyanLabel),
                                  GSStatusBadge(
                                    label: r.status.toUpperCase(),
                                    color: isPending ? AppColors.gold : AppColors.green,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.villa_outlined, size: 16, color: AppColors.cyan),
                                  const SizedBox(width: 8),
                                  Text(r.propertyTitle ?? 'Luxury Villa Property', style: AppTextStyles.titleMedium),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Text('${r.checkInDate}  →  ${r.checkOutDate}  •  ${r.totalNights} nights', style: AppTextStyles.bodySmall),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(color: AppColors.border),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Payout:', style: AppTextStyles.bodyMedium),
                                  Text(
                                    '\$${r.totalPrice.toStringAsFixed(2)}',
                                    style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              if (isPending)
                                Row(
                                  children: [
                                    Expanded(
                                      child: GSButton(
                                        label: 'Decline',
                                        isSecondary: true,
                                        onTap: isActioning ? () {} : () => _handleDecline(r.id),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 2,
                                      child: GSButton(
                                        label: isActioning ? 'Confirming...' : 'Accept Booking →',
                                        isLoading: isActioning,
                                        onTap: isActioning ? () {} : () => _handleConfirm(r.id),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardTouchpoint,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Booking is ${r.status.toUpperCase()}',
                                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.green, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
