import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/property_model.dart';
import '../../../core/services/room_service.dart';
import '../../../core/widgets/gs_card.dart';

class PastBookingsScreen extends StatefulWidget {
  const PastBookingsScreen({super.key});

  @override
  State<PastBookingsScreen> createState() => _PastBookingsScreenState();
}

class _PastBookingsScreenState extends State<PastBookingsScreen> {
  final RoomService _roomService = RoomService();
  bool _isLoading = true;
  List<RoomBookingModel> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final list = await _roomService.getProviderBookings();
      if (mounted) {
        setState(() {
          _history = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Booking History', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
          : RefreshIndicator(
              onRefresh: _loadHistory,
              color: AppColors.cyan,
              child: _history.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.history_outlined, size: 56, color: AppColors.cyan),
                            const SizedBox(height: 16),
                            Text('No Booking History Yet', style: AppTextStyles.headlineSmall),
                            const SizedBox(height: 8),
                            Text(
                              'Completed guest reservations and verified stays will be archived here.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _history.length,
                      itemBuilder: (c, i) {
                        final b = _history[i];
                        final isCompleted = b.status.toLowerCase() == 'completed';
                        final isConfirmed = b.status.toLowerCase() == 'confirmed';
                        final badgeColor = isCompleted
                            ? AppColors.green
                            : isConfirmed
                                ? AppColors.cyan
                                : AppColors.gold;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(b.bookingNumber ?? '#PB-${b.id}', style: AppTextStyles.cyanLabel),
                                  GSStatusBadge(
                                    label: b.status.toUpperCase(),
                                    color: badgeColor,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.villa_outlined, size: 16, color: AppColors.cyan),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(b.propertyTitle ?? 'Luxury Sovereign Property', style: AppTextStyles.titleMedium),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Text('${b.checkInDate}  →  ${b.checkOutDate} • ${b.totalNights} nights', style: AppTextStyles.bodySmall),
                                  const Spacer(),
                                  Text(
                                    '\$${b.totalPrice.toStringAsFixed(2)}',
                                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                  ),
                                ],
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
