import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/ride_model.dart';
import '../../../core/services/ride_service.dart';

class DriverRatingsScreen extends StatefulWidget {
  final bool embedded;
  const DriverRatingsScreen({super.key, this.embedded = false});

  @override
  State<DriverRatingsScreen> createState() => _DriverRatingsScreenState();
}

class _DriverRatingsScreenState extends State<DriverRatingsScreen> {
  final RideService _rideService = RideService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _liveReviews = [];
  double _overallRating = 5.0;
  int _totalReviewCount = 0;
  final Map<int, double> _starDistribution = {5: 1.0, 4: 0.0, 3: 0.0, 2: 0.0, 1: 0.0};

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  Future<void> _loadRatings() async {
    setState(() => _isLoading = true);
    try {
      final history = await _rideService.getDriverRideHistory();
      final reviews = <Map<String, dynamic>>[];
      int starSum = 0;
      final starCounts = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

      for (final RideModel r in history) {
        if (r.review != null) {
          final rev = r.review!;
          final stars = (rev['rating'] is num) ? (rev['rating'] as num).toInt() : 5;
          final comment = rev['notes']?.toString() ?? 'Smooth ride and professional service.';
          final name = rev['customer_name']?.toString() ?? r.customerName;
          final dateStr = rev['created_at']?.toString() ?? r.createdAt ?? 'Recent';
          final formattedDate = dateStr.length >= 10 ? dateStr.substring(5, 10) : 'Recent';

          reviews.add({
            'name': name,
            'stars': stars,
            'comment': comment.isNotEmpty ? comment : 'Excellent trip.',
            'date': formattedDate,
          });

          starSum += stars;
          starCounts[stars] = (starCounts[stars] ?? 0) + 1;
        }
      }

      if (mounted) {
        setState(() {
          _liveReviews = reviews;
          if (reviews.isNotEmpty) {
            _totalReviewCount = reviews.length;
            _overallRating = double.parse((starSum / reviews.length).toStringAsFixed(2));
            for (int s = 1; s <= 5; s++) {
              _starDistribution[s] = (starCounts[s] ?? 0) / reviews.length;
            }
          } else {
            _totalReviewCount = 0;
            _overallRating = 5.0;
            _starDistribution[5] = 1.0;
            for (int s = 1; s <= 4; s++) {
              _starDistribution[s] = 0.0;
            }
          }
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
            onRefresh: _loadRatings,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.embedded) Text('My Ratings', style: AppTextStyles.headlineLarge),
                        const SizedBox(height: 16),
                        // Summary card in Sovereign Light Theme
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Overall Rating', style: AppTextStyles.bodyMedium),
                                  const SizedBox(height: 4),
                                  Text(
                                    _overallRating.toStringAsFixed(2),
                                    style: AppTextStyles.price.copyWith(fontSize: 38, color: AppColors.gold),
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        i < _overallRating.round() ? Icons.star : Icons.star_border,
                                        color: AppColors.gold,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('$_totalReviewCount total reviews', style: AppTextStyles.bodySmall),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _bar('5★', _starDistribution[5] ?? 1.0),
                                  _bar('4★', _starDistribution[4] ?? 0.0),
                                  _bar('3★', _starDistribution[3] ?? 0.0),
                                  _bar('2★', _starDistribution[2] ?? 0.0),
                                  _bar('1★', _starDistribution[1] ?? 0.0),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text('Recent Guest Reviews', style: AppTextStyles.headlineSmall),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  if (_liveReviews.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _liveReviews.length,
                      itemBuilder: (c, i) {
                        final r = _liveReviews[i];
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
                                  Text(r['name'] as String, style: AppTextStyles.titleMedium),
                                  Text(r['date'] as String, style: AppTextStyles.bodySmall),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: List.generate(
                                  5,
                                  (j) => Icon(
                                    j < (r['stars'] as int) ? Icons.star : Icons.star_border,
                                    color: AppColors.gold,
                                    size: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                r['comment'] as String,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                ],
              ),
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
        title: Text('Driver Ratings', style: AppTextStyles.titleLarge),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryTeal),
            onPressed: _loadRatings,
          ),
        ],
      ),
      body: content,
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.star_outline, size: 32, color: AppColors.gold),
            ),
            const SizedBox(height: 16),
            Text('No Reviews Yet', style: AppTextStyles.titleLarge),
            const SizedBox(height: 6),
            Text(
              'Complete rides to start collecting ratings and reviews from VIP passengers.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(String label, double val) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(label, style: AppTextStyles.bodySmall),
            ),
            const SizedBox(width: 8),
            Container(
              width: 100,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: val.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
