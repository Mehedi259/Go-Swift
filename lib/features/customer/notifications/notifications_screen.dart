import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  final bool embedded;
  const NotificationsScreen({super.key, this.embedded = false});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0;
  List<NotificationModel> _apiNotifications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final list = await NotificationService().getNotifications();
      if (mounted) {
        setState(() {
          _apiNotifications = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<NotificationModel> get _filteredNotifications {
    if (_selectedFilter == 0) return _apiNotifications;
    return _apiNotifications.where((n) {
      final text = '${n.title} ${n.body}'.toLowerCase();
      if (_selectedFilter == 1) return text.contains('ride') || text.contains('chauffeur') || text.contains('driver');
      if (_selectedFilter == 2) return text.contains('food') || text.contains('dining') || text.contains('meal') || text.contains('order');
      if (_selectedFilter == 3) return text.contains('courier') || text.contains('parcel') || text.contains('package') || text.contains('delivery');
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.embedded)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: widget.embedded ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Text('Notifications', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(
                      'GO SWIFT CONCIERGE',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              _buildFilterChip(0, 'All', count: _apiNotifications.length),
              const SizedBox(width: 8),
              _buildFilterChip(1, 'Rides', icon: Icons.directions_car_outlined),
              const SizedBox(width: 8),
              _buildFilterChip(2, 'Food', icon: Icons.restaurant_outlined),
              const SizedBox(width: 8),
              _buildFilterChip(3, 'Courier', icon: Icons.local_shipping_outlined),
            ],
          ),
        ),

        Expanded(
          child: _isLoading && _apiNotifications.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  color: AppColors.cyan,
                  child: _filteredNotifications.isEmpty
                      ? Center(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: const BoxDecoration(
                                    color: AppColors.cyanLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.notifications_none_outlined, size: 32, color: AppColors.cyan),
                                ),
                                const SizedBox(height: 16),
                                Text('No Notifications', style: AppTextStyles.headlineSmall),
                                const SizedBox(height: 8),
                                Text(
                                  'Your live concierge alerts, transit notifications, and dispatch updates will appear here.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          children: [
                            _buildSectionHeader('LIVE NOTIFICATIONS', '${_filteredNotifications.length} Updates'),
                            ..._filteredNotifications.map((n) => _buildNotificationCard(
                                  category: 'CONCIERGE ALERT',
                                  title: n.title,
                                  body: n.body,
                                  time: (n.createdAt != null && n.createdAt!.length >= 16) ? n.createdAt!.substring(11, 16) : 'Just now',
                                  icon: Icons.notifications_active_outlined,
                                  iconColor: AppColors.cyan,
                                  iconBgColor: AppColors.cyanLight,
                                  badgeText: n.isRead ? 'Read' : 'New',
                                  badgeColor: n.isRead ? AppColors.textSecondary : AppColors.cyan,
                                  badgeBgColor: n.isRead ? AppColors.borderLight : AppColors.cyanLight,
                                  actionText: 'View Details →',
                                )),
                            const SizedBox(height: 20),
                          ],
                        ),
                ),
        ),
      ],
    );
    return widget.embedded ? content : Scaffold(backgroundColor: AppColors.background, body: SafeArea(child: content));
  }

  Widget _buildFilterChip(int index, String label, {int? count, IconData? icon}) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyanPill : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.cyan.withOpacity(0.3) : AppColors.border, width: 0.8),
          boxShadow: isSelected ? null : AppColors.softShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? AppColors.cyan : AppColors.textSecondary),
              const SizedBox(width: 6),
            ],
            Text(
              count != null ? '$label $count' : label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.cyan : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String countText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1.0, fontWeight: FontWeight.bold)),
          Text(countText, style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String category,
    required String title,
    required String body,
    required String time,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    String? badgeText,
    Color? badgeColor,
    Color? badgeBgColor,
    required String actionText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                        ),
                        Text(time, style: AppTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(body, style: AppTextStyles.bodySmall.copyWith(height: 1.3)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBgColor ?? AppColors.cyanLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    style: AppTextStyles.labelSmall.copyWith(color: badgeColor ?? AppColors.cyan, fontWeight: FontWeight.bold),
                  ),
                )
              else
                const SizedBox.shrink(),
              Text(
                actionText,
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
