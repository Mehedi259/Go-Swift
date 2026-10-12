import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/courier_model.dart';
import '../../../core/services/courier_service.dart';
import '../../../core/widgets/gs_button.dart';

class CourierActiveDeliveryScreen extends StatefulWidget {
  final CourierDeliveryModel? delivery;
  const CourierActiveDeliveryScreen({super.key, this.delivery});

  @override
  State<CourierActiveDeliveryScreen> createState() => _CourierActiveDeliveryScreenState();
}

class _CourierActiveDeliveryScreenState extends State<CourierActiveDeliveryScreen> {
  final CourierService _courierService = CourierService();
  CourierDeliveryModel? _delivery;
  String _status = 'in_transit';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _delivery = widget.delivery;
    if (_delivery != null) {
      _status = _delivery!.status.isNotEmpty ? _delivery!.status : 'in_transit';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_delivery == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is CourierDeliveryModel) {
        setState(() {
          _delivery = args;
          _status = args.status.isNotEmpty ? args.status : 'in_transit';
        });
      } else {
        _fetchActiveDelivery();
      }
    }
  }

  Future<void> _fetchActiveDelivery() async {
    try {
      final list = await _courierService.getProviderRequests();
      final active = list.where((d) => d.status != 'delivered' && d.status != 'cancelled').toList();
      if (active.isNotEmpty && mounted) {
        setState(() {
          _delivery = active.first;
          _status = _delivery!.status.isNotEmpty ? _delivery!.status : 'in_transit';
        });
      }
    } catch (_) {}
  }

  Future<void> _handleStatusProgression() async {
    final dId = _delivery?.id;
    setState(() => _isLoading = true);

    try {
      if (_status == 'assigned') {
        if (dId != null) {
          await _courierService.updateDeliveryStatus(dId, status: 'pickup_arrived');
        }
        if (mounted) setState(() => _status = 'pickup_arrived');
      } else if (_status == 'pickup_arrived') {
        if (dId != null) {
          await _courierService.updateDeliveryStatus(dId, status: 'in_transit');
        }
        if (mounted) setState(() => _status = 'in_transit');
      } else {
        // Final: Delivered
        if (dId != null) {
          await _courierService.updateDeliveryStatus(dId, status: 'delivered');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Delivery completed successfully! Payout credited.'),
              backgroundColor: AppColors.green,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/provider/courier/hub', (_) => false);
          return;
        }
      }
    } catch (_) {
      // Graceful offline fallback
      if (mounted) {
        if (_status == 'assigned') {
          setState(() => _status = 'pickup_arrived');
        } else if (_status == 'pickup_arrived') {
          setState(() => _status = 'in_transit');
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/provider/courier/hub', (_) => false);
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String get _buttonText {
    if (_status == 'assigned') return 'Arrived at Pickup →';
    if (_status == 'pickup_arrived') return 'Picked Up • Begin Transit →';
    return 'Mark as Delivered →';
  }

  String get _badgeText {
    if (_status == 'assigned') return 'ASSIGNED  •  EN ROUTE TO PICKUP';
    if (_status == 'pickup_arrived') return 'ARRIVED AT PICKUP LOCATION';
    return 'IN TRANSIT  •  EN ROUTE TO DESTINATION';
  }

  @override
  Widget build(BuildContext context) {
    final d = _delivery;
    final trackNum = d != null ? d.trackingNumber : 'ACTIVE DISPATCH';
    final pickup = d != null && d.pickupAddress.isNotEmpty ? d.pickupAddress : 'Designated Dispatch Point';
    final dropoff = d != null && d.dropoffAddress.isNotEmpty ? d.dropoffAddress : 'Designated Drop-off Destination';
    final recipient = d?.recipientName ?? 'Concierge Desk';
    final packageDesc = d?.packageDescription ?? d?.packageSize ?? 'Bonded Courier Parcel';
    final fee = d != null ? '\$${d.fee.toStringAsFixed(2)}' : 'Escrow Protected';

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
        title: Text('Active Delivery $trackNum', style: AppTextStyles.titleLarge),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(_badgeText, style: AppTextStyles.labelSmall.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _status == 'assigned'
                  ? 'Pickup Pending'
                  : _status == 'pickup_arrived'
                      ? 'Package Handover'
                      : 'Parcel In Transit',
              style: AppTextStyles.displayMedium,
            ),
            const SizedBox(height: 16),
            // Light Map Container
            Container(
              height: 190,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5F9),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: const Icon(Icons.delivery_dining, color: AppColors.cyan, size: 34),
                        ),
                        const SizedBox(height: 10),
                        Text('Dispatching via Bay St & Shirley St', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text('ETA 12 MIN', style: AppTextStyles.caption.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                      const Icon(Icons.radio_button_checked, color: AppColors.cyan, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(pickup, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppColors.border, height: 1),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.gold, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(dropoff, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppColors.border, height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recipient', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 2),
                          Text(recipient, style: AppTextStyles.titleMedium),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Payout Fee', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 2),
                          Text(fee, style: AppTextStyles.titleMedium.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.cyan),
                      const SizedBox(width: 6),
                      Text('Parcel: $packageDesc', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GSButton(
              label: _isLoading ? 'Updating Status...' : _buttonText,
              onTap: _isLoading ? () {} : _handleStatusProgression,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
