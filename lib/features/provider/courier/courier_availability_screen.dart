import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/courier_model.dart';
import '../../../core/services/courier_service.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/widgets/gs_button.dart';
import 'courier_history_screen.dart';
import 'courier_profile_screen.dart';

class CourierAvailabilityScreen extends StatefulWidget {
  const CourierAvailabilityScreen({super.key});
  @override
  State<CourierAvailabilityScreen> createState() => _CourierAvailabilityScreenState();
}

class _CourierAvailabilityScreenState extends State<CourierAvailabilityScreen> {
  final CourierService _courierService = CourierService();
  final ProviderApplicationService _providerService = ProviderApplicationService();
  bool _online = true;
  int _nav = 0;
  String _courierName = 'Marcus Rolle';
  String _badgeNumber = 'Bonded Courier • #BC-182';
  String _todayEarnings = '\$182.00';
  String _todayDeliveries = '6';
  List<CourierOrderModel> _incomingRequests = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final profile = await _providerService.getCourierProfile();
      if (mounted && profile.isNotEmpty) {
        setState(() {
          if (profile['legal_name'] != null && (profile['legal_name'] as String).isNotEmpty) {
            _courierName = profile['legal_name'];
          }
          if (profile['transport_mode'] != null) {
            _badgeNumber = 'Bonded Courier • ${profile['transport_mode'].toString().toUpperCase()}';
          }
          if (profile['online_accepting_dispatch'] != null) {
            _online = profile['online_accepting_dispatch'] == true;
          }
        });
      }
    } catch (_) {}

    try {
      final stats = await _courierService.getProviderStats();
      if (mounted && stats.isNotEmpty) {
        setState(() {
          if (stats['total_earnings'] != null) {
            _todayEarnings = '\$${stats['total_earnings']}';
          }
          if (stats['deliveries_today'] != null) {
            _todayDeliveries = '${stats['deliveries_today']}';
          }
        });
      }
    } catch (_) {}

    try {
      final requests = await _courierService.getProviderRequests();
      if (mounted) {
        setState(() {
          _incomingRequests = requests;
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleOnline() async {
    final nextState = !_online;
    setState(() => _online = nextState);
    try {
      await _providerService.updateCourierProfile(onlineAcceptingDispatch: nextState);
    } catch (_) {}
  }

  Widget _body() {
    switch (_nav) {
      case 1:
        return const CourierHistoryScreen(embedded: true);
      case 2:
        return _earningsTab();
      case 3:
        return const CourierProfileScreen(embedded: true);
      default:
        return _homeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _body(),
      bottomNavigationBar: _bottomNav(),
    );
  }

  // ─── Home Tab ──────────────────────────────────────────────────────────────
  Widget _homeTab() {
    final CourierOrderModel? topRequest = _incomingRequests.isNotEmpty ? _incomingRequests.first : null;

    return SafeArea(
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.cyanLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
                  ),
                  child: const Icon(Icons.bolt, color: AppColors.cyan, size: 22),
                ),
                const SizedBox(width: 10),
                Text('Courier Hub', style: AppTextStyles.titleLarge.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status card in Sovereign Light Theme
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_courierName, style: AppTextStyles.headlineMedium),
                                const SizedBox(height: 2),
                                Text(_badgeNumber, style: AppTextStyles.bodySmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.cyanLight,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.cyan, width: 2),
                              ),
                              child: const Icon(Icons.delivery_dining, color: AppColors.cyan, size: 28),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        // Online/Offline toggle
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.cardTouchpoint,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _online ? 'ONLINE' : 'OFFLINE',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: _online ? AppColors.green : AppColors.textMuted,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _online ? 'Ready for parcels' : 'Not accepting jobs',
                                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: _toggleOnline,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 64,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: _online ? AppColors.green : AppColors.border,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: AnimatedAlign(
                                    duration: const Duration(milliseconds: 300),
                                    alignment: _online ? Alignment.centerRight : Alignment.centerLeft,
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      margin: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _stat('Today', _todayEarnings, AppColors.gold)),
                            const SizedBox(width: 12),
                            Expanded(child: _stat('Deliveries', _todayDeliveries, AppColors.cyan)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Incoming Parcel Request', style: AppTextStyles.headlineSmall),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/provider/courier/requests'),
                        child: Text('View All', style: AppTextStyles.cyanLabel.copyWith(color: AppColors.cyan)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Request card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.goldLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(topRequest != null ? 'PARCEL #${topRequest.id}' : 'BONDED PARCEL', style: AppTextStyles.goldLabel),
                            ),
                            const Spacer(),
                            Text(
                              topRequest != null ? '\$${topRequest.fee}' : '\$42.00',
                              style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: AppColors.cyan, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                topRequest?.pickupAddress ?? 'Graycliff Boutique, Nassau',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.flag_outlined, color: AppColors.gold, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                topRequest?.deliveryAddress ?? 'The Ocean Club, Paradise Island',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: GSButton(label: 'Decline', isSecondary: true, onTap: () {})),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: GSButton(
                                label: 'Accept →',
                                onTap: () async {
                                  if (topRequest != null) {
                                    try {
                                      await _courierService.acceptDelivery(topRequest.id);
                                    } catch (_) {}
                                  }
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, '/provider/courier/active');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Earnings Tab ──────────────────────────────────────────────────────────
  Widget _earningsTab() {
    final txns = [
      {'from': 'Graycliff Boutique', 'to': 'Ocean Club', 'id': '#CS-3182', 'amount': '\$42.00', 'date': 'Today 2:10 PM'},
      {'from': 'Baha Mar Shops', 'to': 'Atlantis', 'id': '#CS-3171', 'amount': '\$38.00', 'date': 'Today 11:30 AM'},
      {'from': 'Bay St. Legal', 'to': 'Lyford Cay', 'id': '#CS-3160', 'amount': '\$65.00', 'date': 'Yesterday 4:00 PM'},
      {'from': 'Paradise Island', 'to': 'NAS Airport', 'id': '#CS-3145', 'amount': '\$37.00', 'date': 'Apr 19, 9:00 AM'},
    ];
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Earnings', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  Text('Weekly Dispatch Earnings', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 6),
                  Text(_todayEarnings, style: AppTextStyles.price.copyWith(color: AppColors.gold, fontSize: 36)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _stat('Completed', _todayDeliveries, AppColors.cyan)),
                      const SizedBox(width: 12),
                      Expanded(child: _stat('Avg. Payout', '\$44.50', AppColors.gold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Dispatch Log', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            ...txns.map((t) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.cardTouchpoint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delivery_dining, color: AppColors.cyan, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${t['from']} → ${t['to']}', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 2),
                            Text('${t['id']}  •  ${t['date']}', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Text(
                        t['amount']!,
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardTouchpoint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.titleLarge.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    final items = [
      {'icon': Icons.home_outlined, 'active': Icons.home, 'label': 'Home'},
      {'icon': Icons.history_outlined, 'active': Icons.history, 'label': 'History'},
      {'icon': Icons.attach_money_outlined, 'active': Icons.attach_money, 'label': 'Earnings'},
      {'icon': Icons.person_outline, 'active': Icons.person, 'label': 'Profile'},
    ];
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final active = _nav == i;
              return GestureDetector(
                onTap: () => setState(() => _nav = i),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      active ? items[i]['active'] as IconData : items[i]['icon'] as IconData,
                      color: active ? AppColors.cyan : AppColors.textMuted,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[i]['label'] as String,
                      style: AppTextStyles.caption.copyWith(
                        color: active ? AppColors.cyan : AppColors.textMuted,
                        fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
