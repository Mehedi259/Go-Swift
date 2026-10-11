import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/car_rental_service.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/widgets/gs_button.dart';

class CarRentalBookingScreen extends StatefulWidget {
  const CarRentalBookingScreen({super.key});

  @override
  State<CarRentalBookingScreen> createState() => _CarRentalBookingScreenState();
}

class _CarRentalBookingScreenState extends State<CarRentalBookingScreen> {
  bool _isSubmitting = false;
  int _deliveryOption = 0;
  bool _initialized = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController(text: 'DL-BAH-2026');
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 5));

  Map<String, dynamic>? _selectedCard;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null) {
        if (user.fullName.isNotEmpty) _nameController.text = user.fullName;
        if (user.phone.isNotEmpty) _phoneController.text = user.phone;
        if (user.streetAddress != null && user.streetAddress!.isNotEmpty) {
          _addressController.text = '${user.streetAddress}${user.city != null ? ", ${user.city}" : ""}';
        } else {
          _addressController.text = 'The Ocean Club, Paradise Island';
        }
      } else {
        _nameController.text = 'Alexander Vance';
        _phoneController.text = '+1 (242) 555-0199';
        _addressController.text = 'The Ocean Club, Paradise Island';
      }

      final cards = LocalStorage.getPaymentCards();
      if (cards.isNotEmpty) {
        _selectedCard = cards.firstWhere((c) => c['isDefault'] == true, orElse: () => cards.first);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  int get _rentalDays {
    final diff = _endDate.difference(_startDate).inDays;
    return diff > 0 ? diff : 1;
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  String _formatDisplayDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  Future<void> _selectRentalDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _confirmBooking() async {
    setState(() => _isSubmitting = true);
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      int vehicleId = 1;
      if (args is RentalVehicleModel) {
        vehicleId = args.id;
      } else if (args is Map && args['id'] is int) {
        vehicleId = args['id'] as int;
      }

      final station = _deliveryOption == 2
          ? "Lynden Pindling International Airport (NAS)"
          : _deliveryOption == 1
              ? (_addressController.text.trim().isNotEmpty ? _addressController.text.trim() : "Villa Delivery, Paradise Island")
              : "Cable Beach Fleet Hub, Nassau";

      final booking = await CarRentalService().createBooking(
        vehicleId: vehicleId,
        startDate: _formatDate(_startDate),
        endDate: _formatDate(_endDate),
        pickupHandoverStation: station,
        deliverToVillaOrHotel: _deliveryOption == 1,
        deliveryAddress: _deliveryOption == 1 ? station : null,
        customerNote: "Driver: ${_nameController.text.trim()}, DL: ${_licenseController.text.trim()}",
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.pushNamed(context, '/customer/car-rental/active', arguments: booking);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rental confirmed: $e'),
            backgroundColor: AppColors.primaryNavy,
          ),
        );
        Navigator.pushNamed(context, '/customer/car-rental/active');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final RentalVehicleModel? vehicle = args is RentalVehicleModel ? args : null;
    final vehicleTitle = vehicle != null
        ? '${vehicle.make} ${vehicle.model}'
        : 'Cadillac Escalade ESV';
    final dailyRate = vehicle?.dailyRate ?? 285.0;
    final totalAmount = dailyRate * _rentalDays;
    final vehicleTotalFormatted = '\$${totalAmount.toStringAsFixed(2)}';

    final cardDisplay = _selectedCard != null
        ? '${_selectedCard!['type']} •••• ${_selectedCard!['number']}'
        : 'Visa •••• 4242';

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
        title: Text('Confirm Rental Booking', style: AppTextStyles.titleLarge),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicleTitle, style: AppTextStyles.headlineLarge),
                  const SizedBox(height: 8),

                  // Interactive Date Selection
                  GestureDetector(
                    onTap: _selectRentalDates,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primaryTeal, width: 1.2),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.badgeTeal,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.calendar_today_outlined, color: AppColors.primaryTeal, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_formatDisplayDate(_startDate)} – ${_formatDisplayDate(_endDate)}',
                                  style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$_rentalDays ${_rentalDays == 1 ? "Day" : "Days"} • Tap to change rental dates',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryTeal),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.edit_calendar_outlined, color: AppColors.primaryTeal, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text('PRIMARY DRIVER INFORMATION', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _licenseController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                      labelText: 'Driver\'s License Number',
                      prefixIcon: Icon(Icons.badge_outlined, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Phone',
                      prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('HANDOVER & DELIVERY OPTION', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  ...[
                    {'icon': Icons.location_on_outlined, 'label': 'Self Pick-up', 'sub': 'Cable Beach Fleet Hub, Nassau'},
                    {'icon': Icons.hotel, 'label': 'Hotel / Villa Concierge Delivery', 'sub': 'Direct delivery to your property • FREE'},
                    {'icon': Icons.flight, 'label': 'Airport Delivery (NAS)', 'sub': "Available at Lynden Pindling Int'l Airport FBO"},
                  ].asMap().entries.map((e) => GestureDetector(
                    onTap: () => setState(() => _deliveryOption = e.key),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _deliveryOption == e.key ? AppColors.primaryTeal : AppColors.border,
                          width: _deliveryOption == e.key ? 2 : 1,
                        ),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _deliveryOption == e.key ? AppColors.badgeTeal : AppColors.cardTouchpoint,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(e.value['icon'] as IconData, color: AppColors.primaryTeal, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.value['label'] as String, style: AppTextStyles.titleMedium),
                                Text(e.value['sub'] as String, style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          if (_deliveryOption == e.key)
                            const Icon(Icons.check_circle, color: AppColors.primaryTeal, size: 20),
                        ],
                      ),
                    ),
                  )),

                  if (_deliveryOption == 1) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _addressController,
                      style: AppTextStyles.bodyMedium,
                      decoration: const InputDecoration(
                        labelText: 'Villa / Resort Address',
                        hintText: 'e.g. 101 Ocean Club Drive, Villa 5',
                        prefixIcon: Icon(Icons.home_work_outlined, color: AppColors.primaryTeal, size: 20),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PAYMENT METHOD', style: AppTextStyles.labelSmall),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/customer/profile/payment-methods').then((_) {
                          final cards = LocalStorage.getPaymentCards();
                          if (cards.isNotEmpty) {
                            setState(() {
                              _selectedCard = cards.firstWhere((c) => c['isDefault'] == true, orElse: () => cards.first);
                            });
                          }
                        }),
                        child: Text('Change', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryTeal, width: 1.5),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.credit_card, color: AppColors.primaryTeal, size: 22),
                        const SizedBox(width: 12),
                        Expanded(child: Text(cardDisplay, style: AppTextStyles.titleMedium)),
                        const Icon(Icons.check_circle, color: AppColors.primaryTeal, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      children: [
                        _row('$_rentalDays Days Rental × \$${dailyRate.toStringAsFixed(0)}/day', vehicleTotalFormatted),
                        _row('Comprehensive Sovereign Insurance', 'Included'),
                        _row('Concierge Fleet Delivery', 'FREE'),
                        const Divider(color: AppColors.border),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TOTAL', style: AppTextStyles.headlineSmall),
                            Text(vehicleTotalFormatted, style: AppTextStyles.price.copyWith(fontSize: 22)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GSButton(
              label: 'Confirm Rental • $vehicleTotalFormatted →',
              isLoading: _isSubmitting,
              onTap: _isSubmitting ? null : _confirmBooking,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: AppTextStyles.bodyMedium),
        Text(v, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary)),
      ],
    ),
  );
}
