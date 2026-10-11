import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/courier_model.dart';
import '../../../core/services/courier_service.dart';
import '../../../core/widgets/gs_button.dart';

class CourierRequestsScreen extends StatefulWidget {
  const CourierRequestsScreen({super.key});

  @override
  State<CourierRequestsScreen> createState() => _CourierRequestsScreenState();
}

class _CourierRequestsScreenState extends State<CourierRequestsScreen> {
  final CourierService _courierService = CourierService();
  List<CourierOrderModel> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final reqs = await _courierService.getProviderRequests();
      if (mounted) {
        setState(() {
          _requests = reqs;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _accept(int id, CourierDeliveryModel? item) async {
    CourierDeliveryModel? accepted = item;
    try {
      accepted = await _courierService.acceptDelivery(id);
    } catch (_) {}
    if (mounted) {
      Navigator.pushNamed(context, '/provider/courier/active', arguments: accepted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Parcel Requests', style: AppTextStyles.titleLarge),
        centerTitle: false,
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
          : _requests.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _requests.length,
                  itemBuilder: (context, i) {
                    final req = _requests[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
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
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.goldLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text('PARCEL #${req.id}', style: AppTextStyles.goldLabel),
                              ),
                              const Spacer(),
                              Text(
                                '\$${req.fee}',
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
                                  req.pickupAddress,
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
                                  req.deliveryAddress,
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
                                child: GSButton(label: 'Accept →', onTap: () => _accept(req.id, req)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.cardTouchpoint,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inventory_2_outlined, color: AppColors.cyan, size: 36),
          ),
          const SizedBox(height: 16),
          Text('No Pending Requests', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 6),
          Text('New incoming delivery requests will appear here in real-time.', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
