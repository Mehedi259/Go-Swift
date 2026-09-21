import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/gs_card.dart';

class BookingHistoryScreen extends StatefulWidget {
  final bool embedded;
  const BookingHistoryScreen({super.key, this.embedded = false});
  @override State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}
class _BookingHistoryScreenState extends State<BookingHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override void dispose() { _tab.dispose(); super.dispose(); }

  final _rides = [
    {'id': '#SW-8492', 'from': 'NAS Airport', 'to': 'The Ocean Club', 'date': 'Apr 20, 4:18 PM', 'fare': '\$118.50', 'status': 'Completed', 'icon': Icons.directions_car},
    {'id': '#SW-8431', 'from': 'Atlantis', 'to': 'Cable Beach', 'date': 'Apr 18, 2:00 PM', 'fare': '\$65.00', 'status': 'Completed', 'icon': Icons.directions_car},
    {'id': '#SW-8298', 'from': 'Paradise Island', 'to': 'NAS Airport', 'date': 'Apr 15, 7:30 AM', 'fare': '\$98.00', 'status': 'Completed', 'icon': Icons.directions_car},
  ];

  final _orders = [
    {'id': '#GS-2847', 'name': 'Dune by Jean-Georges', 'items': '3 items', 'date': 'Apr 20, 1:15 PM', 'total': '\$202.50', 'status': 'Delivered', 'icon': Icons.restaurant},
    {'id': '#GS-2801', 'name': 'Nobu Bahamas', 'items': '2 items', 'date': 'Apr 17, 7:30 PM', 'total': '\$188.00', 'status': 'Delivered', 'icon': Icons.restaurant},
  ];

  final _rentals = [
    {'id': '#CR-5821', 'vehicle': 'Cadillac Escalade ESV', 'dates': 'Apr 21 – Apr 25', 'total': '\$1,140.00', 'status': 'Active', 'icon': Icons.vpn_key_outlined},
    {'id': '#CR-5700', 'vehicle': 'Range Rover Sport', 'dates': 'Apr 10 – Apr 13', 'total': '\$735.00', 'status': 'Completed', 'icon': Icons.vpn_key_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final content = Column(children: [
      if (!widget.embedded) Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Row(children: [
        if (widget.embedded == false) GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20))),
        const SizedBox(width: 12), Text('Booking History', style: AppTextStyles.headlineLarge),
      ])),
      if (widget.embedded) Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Text('Booking History', style: AppTextStyles.headlineLarge)),
      const SizedBox(height: 16),
      Container(margin: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: TabBar(controller: _tab, indicator: BoxDecoration(gradient: AppColors.cyanGradient, borderRadius: BorderRadius.circular(10)), labelColor: AppColors.background, unselectedLabelColor: AppColors.textSecondary, labelStyle: AppTextStyles.labelMedium, tabs: const [Tab(text: 'Rides'), Tab(text: 'Orders'), Tab(text: 'Rentals')])),
      const SizedBox(height: 8),
      Expanded(child: TabBarView(controller: _tab, children: [
        _list(_rides, (item) => _BookingTile(id: item['id'] as String, title: '${item['from']} → ${item['to']}', sub: item['date'] as String, amount: item['fare'] as String, status: item['status'] as String, icon: item['icon'] as IconData)),
        _list(_orders, (item) => _BookingTile(id: item['id'] as String, title: item['name'] as String, sub: '${item['items']} • ${item['date']}', amount: item['total'] as String, status: item['status'] as String, icon: item['icon'] as IconData)),
        _list(_rentals, (item) => _BookingTile(id: item['id'] as String, title: item['vehicle'] as String, sub: item['dates'] as String, amount: item['total'] as String, status: item['status'] as String, icon: item['icon'] as IconData)),
      ])),
    ]);
    return widget.embedded ? content : Scaffold(body: SafeArea(child: content));
  }

  Widget _list(List<Map<String, dynamic>> items, Widget Function(Map<String, dynamic>) builder) =>
    ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), itemCount: items.length, itemBuilder: (c, i) => builder(items[i]));
}

class _BookingTile extends StatelessWidget {
  final String id, title, sub, amount, status;
  final IconData icon;
  const _BookingTile({required this.id, required this.title, required this.sub, required this.amount, required this.status, required this.icon});
  @override
  Widget build(BuildContext context) {
    final isActive = status == 'Active';
    return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 0.5)),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.cyan, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTextStyles.titleMedium),
          Text(sub, style: AppTextStyles.bodySmall),
          const SizedBox(height: 4),
          Row(children: [Text(id, style: AppTextStyles.cyanLabel), const SizedBox(width: 8), GSStatusBadge(label: status, color: isActive ? AppColors.cyan : AppColors.green)]),
        ])),
        Text(amount, style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold)),
      ]));
  }
}



