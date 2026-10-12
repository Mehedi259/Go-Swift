import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/courier_model.dart';
import '../../../core/services/courier_service.dart';
import '../../../core/widgets/gs_button.dart';

class CourierDeliveryStatusScreen extends StatefulWidget {
  final CourierDeliveryModel? delivery;
  const CourierDeliveryStatusScreen({super.key, this.delivery});

  @override
  State<CourierDeliveryStatusScreen> createState() => _CourierDeliveryStatusScreenState();
}

class _CourierDeliveryStatusScreenState extends State<CourierDeliveryStatusScreen> {
  final CourierService _courierService = CourierService();
  CourierDeliveryModel? _delivery;
  Timer? _pollTimer;
  bool _initialized = false;
  bool _isCancelling = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is CourierDeliveryModel) {
        _delivery = args;
      } else if (widget.delivery != null) {
        _delivery = widget.delivery;
      }
      _startPolling();
    }
  }

  void _startPolling() {
    final deliveryId = _delivery?.id;
    if (deliveryId == null) return;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      try {
        final updated = await _courierService.getDeliveryDetail(deliveryId);
        if (!mounted) return;
        setState(() {
          _delivery = updated;
        });
        final s = updated.status.toLowerCase();
        if (s == 'delivered' || s == 'cancelled') {
          _pollTimer?.cancel();
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleCancelDelivery() async {
    final deliveryId = _delivery?.id;
    if (deliveryId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel Parcel Delivery?', style: AppTextStyles.titleLarge),
        content: Text(
          'Are you sure you want to cancel courier dispatch #${_delivery?.trackingNumber ?? deliveryId}?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Keep Dispatch', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel Dispatch'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isCancelling = true);
    try {
      await _courierService.cancelDelivery(deliveryId, reason: 'Customer requested cancellation');
      _pollTimer?.cancel();
      final refreshed = await _courierService.getDeliveryDetail(deliveryId);
      if (mounted) {
        setState(() {
          _delivery = refreshed;
          _isCancelling = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Courier dispatch cancelled.'), backgroundColor: AppColors.red),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isCancelling = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delivery cancelled.'), backgroundColor: AppColors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final delivery = _delivery;
    final trackingCode = delivery?.trackingNumber ?? (delivery != null ? '#CS-${delivery.id}' : '#CS-DISPATCH');
    final status = delivery?.status.toLowerCase() ?? 'in_transit';
    final statusText = status.replaceAll('_', ' ').toUpperCase();

    final isCancelled = status == 'cancelled';
    final isDelivered = status == 'delivered';
    final isInTransit = status == 'in_transit' || status == 'picked_up' || status == 'arrived';
    final isAssigned = status == 'assigned' || isInTransit || isDelivered;

    final pickup = (delivery != null && delivery.pickupAddress.isNotEmpty) ? delivery.pickupAddress : 'Designated Dispatch Point';
    final dropoff = (delivery != null && delivery.dropoffAddress.isNotEmpty) ? delivery.dropoffAddress : 'Designated Drop-off Destination';
    final courierName = (delivery != null && delivery.courierName != null && delivery.courierName!.isNotEmpty) ? delivery.courierName! : 'Assigned Escort Courier';

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Text('Delivery Status', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryTeal),
            onPressed: () async {
              if (delivery?.id != null) {
                final upd = await _courierService.getDeliveryDetail(delivery!.id);
                if (mounted) setState(() => _delivery = upd);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isCancelled ? AppColors.red.withValues(alpha: 0.15) : AppColors.badgeGold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'PARCEL $trackingCode • $statusText',
                style: AppTextStyles.goldLabel.copyWith(
                  color: isCancelled ? AppColors.red : const Color(0xFF8A5300),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isCancelled
                  ? 'Delivery Cancelled'
                  : isDelivered
                      ? 'Package Delivered\nSafely'
                      : 'Your Package is On\nIts Way',
              style: AppTextStyles.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isCancelled
                  ? 'Dispatch halted by sender'
                  : isDelivered
                      ? 'Chain-of-custody signed & completed'
                      : 'Est. Delivery: 4:45 PM • 12 min remaining',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            // Map container
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.local_shipping,
                      color: AppColors.primaryTeal.withValues(alpha: 0.5),
                      size: 48,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Text(
                        'LIVE GPS COURIER DISPATCH',
                        style: AppTextStyles.caption.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Steps
            if (!isCancelled)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: [
                    _step('Parcel Picked Up', pickup, isAssigned),
                    _step('En Route', '$courierName en route to destination', isInTransit),
                    _step('Arrived at Destination', dropoff, status == 'arrived' || isDelivered),
                    _step('Delivered & Signed', 'Chain-of-custody completed', isDelivered),
                  ],
                ),
              ),
            if (isCancelled)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cancel_outlined, color: AppColors.red, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dispatch Cancelled', style: AppTextStyles.titleMedium.copyWith(color: AppColors.red)),
                          Text('This parcel order is no longer in transit.', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            // Courier profile card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.badgeTeal, shape: BoxShape.circle),
                    child: const Icon(Icons.delivery_dining, color: AppColors.primaryTeal, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(courierName, style: AppTextStyles.titleLarge),
                        Text('Bonded VIP Courier • 4.95 ★', style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.cardTouchpoint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.phone_outlined, color: AppColors.primaryTeal, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (!isCancelled && !isDelivered) ...[
              GSButton(
                label: 'Mark as Received & Rate →',
                onTap: () => Navigator.pushNamed(context, '/customer/courier/rating', arguments: delivery),
              ),
              const SizedBox(height: 12),
              GSButton(
                label: _isCancelling ? 'Cancelling...' : 'Cancel Delivery',
                isSecondary: true,
                isLoading: _isCancelling,
                onTap: _isCancelling ? () {} : _handleCancelDelivery,
              ),
              const SizedBox(height: 12),
            ],
            if (isDelivered) ...[
              GSButton(
                label: 'Rate Courier Experience →',
                onTap: () => Navigator.pushNamed(context, '/customer/courier/rating', arguments: delivery),
              ),
              const SizedBox(height: 12),
            ],
            GSButton(
              label: 'Return to Hub',
              isSecondary: isCancelled || isDelivered,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _step(String l, String s, bool done) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: done ? AppColors.primaryTeal : AppColors.cardTouchpoint,
                shape: BoxShape.circle,
                border: Border.all(color: done ? AppColors.primaryTeal : AppColors.border),
              ),
              child: Icon(done ? Icons.check : Icons.circle_outlined, size: 12, color: done ? Colors.white : AppColors.textMuted),
            ),
            Container(width: 2, height: 22, color: done ? AppColors.primaryTeal.withValues(alpha: 0.4) : AppColors.border),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l, style: AppTextStyles.titleMedium.copyWith(color: done ? AppColors.textPrimary : AppColors.textMuted, fontWeight: done ? FontWeight.bold : FontWeight.normal)),
              Text(s, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    ),
  );
}
