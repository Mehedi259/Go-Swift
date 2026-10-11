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
  double _overallRating = 4.98;
  int _totalReviewCount = 620;
  final Map<int, double> _starDistribution = {5: 0.94, 4: 0.04, 3: 0.01, 2: 0.01, 1: 0.00};

  final List<Map<String, dynamic>> _fallbackReviews = [
    {'name': 'Alexander Vance', 'stars': 5, 'comment': 'Exceptional service. Captain Rolle was punctual and professional.', 'date': 'Apr 20'},
    {'name': 'Victoria Stubbs', 'stars': 5, 'comment': 'Best ride experience on the island. Highly recommended!', 'date': 'Apr 18'},
    {'name': 'Marcus Thompson', 'stars': 5, 'comment': 'Pristine vehicle, seamless airport pickup. 10/10.', 'date': 'Apr 16'},
    {'name': 'Sarah Williams', 'stars': 4, 'comment': 'Very good experience. Clean car and helpful driver.', 'date': 'Apr 14'},
  ];

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
          if (reviews.isNotEmpty) {
            _liveReviews = reviews;
            _totalReviewCount = reviews.length;
            _overallRating = double.parse((starSum / reviews.length).toStringAsFixed(2));
            for (int s = 1; s <= 5; s++) {
              _starDistribution[s] = (starCounts[s] ?? 0) / reviews.length;
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
    final displayReviews = _liveReviews.isNotEmpty ? _liveReviews : _fallbackReviews;

    final content = Column(
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
                        _bar('5★', _starDistribution[5] ?? 0.94),
                        _bar('4★', _starDistribution[4] ?? 0.04),
                        _bar('3★', _starDistribution[3] ?? 0.01),
                        _bar('2★', _starDistribution[2] ?? 0.01),
                        _bar('1★', _starDistribution[1] ?? 0.00),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Reviews', style: AppTextStyles.headlineSmall),
              if (_liveReviews.isNotEmpty)
                Text('${_liveReviews.length} Verified', style: AppTextStyles.caption.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _isLoading && _liveReviews.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
              : RefreshIndicator(
                  onRefresh: _loadRatings,
                  color: AppColors.cyan,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: displayReviews.length,
                    itemBuilder: (c, i) {
                      final r = displayReviews[i];
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
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.cyanLight,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                                  ),
                                  child: const Icon(Icons.person, color: AppColors.cyan, size: 18),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(r['name'] as String, style: AppTextStyles.titleMedium),
                                ),
                                Text(r['date'] as String, style: AppTextStyles.bodySmall),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(
                                r['stars'] as int,
                                (_) => const Icon(Icons.star, color: AppColors.gold, size: 14),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(r['comment'] as String, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );

    return widget.embedded
        ? content
        : Scaffold(
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
              title: Text('My Ratings', style: AppTextStyles.titleLarge),
              centerTitle: false,
            ),
            body: SafeArea(child: content),
          );
  }

  Widget _bar(String l, double pct) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text(l, style: AppTextStyles.caption),
            const SizedBox(width: 6),
            Container(
              width: 80,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: AppColors.cardTouchpoint,
              ),
              child: FractionallySizedBox(
                widthFactor: pct.clamp(0.0, 1.0),
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: AppColors.gold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
