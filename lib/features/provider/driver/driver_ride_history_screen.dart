import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/services/ride_service.dart';
import '../../../core/widgets/gs_button.dart';

class DriverRideHistoryScreen extends StatefulWidget {
  final bool embedded;
  const DriverRideHistoryScreen({super.key, this.embedded = false});

  @override
  State<DriverRideHistoryScreen> createState() => _DriverRideHistoryScreenState();
}

class _DriverRideHistoryScreenState extends State<DriverRideHistoryScreen> {
  final RideService _rideService = RideService();
  List<RideModel> _liveHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoading = true);
    try {
      final list = await _rideService.getDriverRideHistory();
      if (mounted) {
        setState(() {
          _liveHistory = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _isLoading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
        : RefreshIndicator(
            color: AppColors.primaryTeal,
            onRefresh: _fetchHistory,
            child: _liveHistory.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: _liveHistory.length,
                    itemBuilder: (c, i) {
                      final r = _liveHistory[i];
                      final route = '${r.pickupAddress} → ${r.destinationAddress}';
                      final id = '#SW-${r.id}';
                      final dateStr = r.createdAt ?? '';
                      final time = dateStr.length >= 16 ? dateStr.substring(0, 16).replaceAll('T', ' ') : 'Recent Trip';
                      final fare = '\$${(r.finalFare ?? r.estimatedFare).toStringAsFixed(2)}';
                      final rating = (r.review != null && r.review!['rating'] != null)
                          ? '${r.review!['rating']}'
                          : '5.0';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
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
                                Text(id, style: AppTextStyles.cyanLabel),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: AppColors.gold, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      rating,
                                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(route, style: AppTextStyles.titleMedium),
                            const SizedBox(height: 4),
                            Text(time, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(color: AppColors.border, height: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('FARE EARNED', style: AppTextStyles.caption.copyWith(letterSpacing: 1)),
                                Text(
                                  fare,
                                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.green, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          );

    if (widget.embedded) return content;

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
        title: Text('Trip History', style: AppTextStyles.titleLarge),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryTeal),
            onPressed: _fetchHistory,
          ),
        ],
      ),
      body: content,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.history_outlined, size: 38, color: AppColors.primaryTeal),
            ),
            const SizedBox(height: 20),
            Text('No Completed Trips Yet', style: AppTextStyles.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'When you accept and complete VIP passenger dispatches, your fare records and route history will appear here.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GSButton(
              label: 'Refresh History',
              isSecondary: true,
              onTap: _fetchHistory,
            ),
          ],
        ),
      ),
    );
  }
}
