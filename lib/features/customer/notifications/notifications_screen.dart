import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class NotificationsScreen extends StatelessWidget {
  final bool embedded;
  const NotificationsScreen({super.key, this.embedded = false});

  final _notifications = const [
    {'icon': Icons.directions_car, 'title': 'Ride Completed', 'body': 'Your trip #SW-8492 has been completed. Fare: \$118.50', 'time': '4:20 PM', 'read': true, 'color': 0xFF00D4FF},
    {'icon': Icons.restaurant, 'title': 'Order Delivered', 'body': 'Your order from Dune by Jean-Georges has been delivered.', 'time': '1:45 PM', 'read': true, 'color': 0xFFF5A623},
    {'icon': Icons.vpn_key_outlined, 'title': 'Rental Active', 'body': 'Your Cadillac Escalade ESV rental is now active. Return by Apr 25.', 'time': '9:00 AM', 'read': false, 'color': 0xFF00D4FF},
    {'icon': Icons.star, 'title': 'Rate Your Ride', 'body': 'Please rate your recent experience with Captain Terrence Rolle.', 'time': 'Yesterday', 'read': false, 'color': 0xFFF5A623},
    {'icon': Icons.local_offer_outlined, 'title': 'Special Offer', 'body': '20% off your next villa booking at Baha Mar. Expires Apr 30.', 'time': '2 days ago', 'read': true, 'color': 0xFF9B59B6},
    {'icon': Icons.verified_user_outlined, 'title': 'Account Verified', 'body': 'Your Go Swift account has been successfully verified.', 'time': '1 week ago', 'read': true, 'color': 0xFF3FB950},
  ];

  @override
  Widget build(BuildContext context) {
    final content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Notifications', style: AppTextStyles.headlineLarge),
        Text('Mark all read', style: AppTextStyles.cyanLabel),
      ])),
      const SizedBox(height: 16),
      Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: _notifications.length, itemBuilder: (c, i) {
        final n = _notifications[i];
        final isRead = n['read'] as bool;
        return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(
          color: isRead ? AppColors.card : AppColors.card.withOpacity(0.8),
          borderRadius: BorderRadius.circular(14), border: Border.all(color: isRead ? AppColors.border : AppColors.cyan.withOpacity(0.3), width: isRead ? 0.5 : 1)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: Color(n['color'] as int).withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Icon(n['icon'] as IconData, color: Color(n['color'] as int), size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(n['title'] as String, style: AppTextStyles.titleMedium),
                Text(n['time'] as String, style: AppTextStyles.caption),
              ]),
              const SizedBox(height: 4),
              Text(n['body'] as String, style: AppTextStyles.bodySmall),
            ])),
            if (!isRead) ...[const SizedBox(width: 8), Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle))],
          ]));
      })),
    ]);
    return embedded ? content : Scaffold(body: SafeArea(child: content));
  }
}
