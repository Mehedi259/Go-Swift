import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/property_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/room_service.dart';
import '../../../core/widgets/gs_button.dart';

class PropertyBookingScreen extends StatefulWidget {
  const PropertyBookingScreen({super.key});

  @override
  State<PropertyBookingScreen> createState() => _PropertyBookingScreenState();
}

class _PropertyBookingScreenState extends State<PropertyBookingScreen> {
  bool _isSubmitting = false;
  bool _userInitialized = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController(text: '2');
  final TextEditingController _notesController = TextEditingController(text: 'Butler arrival greeting and chilled island coconut water.');

  DateTime _checkInDate = DateTime.now().add(const Duration(days: 2));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 7));

  final Set<int> _selectedAddons = {};
  final List<Map<String, dynamic>> _addons = [
    {'label': 'Private Chef Experience', 'price': 1500.0, 'icon': Icons.restaurant},
    {'label': 'VIP Airport Transfer (Return)', 'price': 240.0, 'icon': Icons.flight},
    {'label': 'Luxury Yacht Charter (Half Day)', 'price': 2200.0, 'icon': Icons.sailing},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_userInitialized) {
      _userInitialized = true;
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null) {
        if (user.fullName.isNotEmpty) _nameController.text = user.fullName;
        if (user.email.isNotEmpty) _emailController.text = user.email;
        if (user.phone.isNotEmpty) _phoneController.text = user.phone;
      } else {
        _nameController.text = 'VIP Guest';
        _emailController.text = 'guest@goswift.bs';
        _phoneController.text = '+1 (242) 555-0100';
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _guestsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _nights {
    final diff = _checkOutDate.difference(_checkInDate).inDays;
    return diff > 0 ? diff : 1;
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  String _formatDisplayDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  Future<void> _selectDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _checkInDate, end: _checkOutDate),
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
        _checkInDate = picked.start;
        _checkOutDate = picked.end;
      });
    }
  }

  Future<void> _submitBooking() async {
    setState(() => _isSubmitting = true);
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      int listingId = 1;
      if (args is PropertyListingModel) {
        listingId = args.id;
      } else if (args is Map && args['id'] is int) {
        listingId = args['id'] as int;
      }

      final inStr = _formatDate(_checkInDate);
      final outStr = _formatDate(_checkOutDate);

      final booking = await RoomService().createBooking(
        listingId: listingId,
        checkInDate: inStr,
        checkOutDate: outStr,
        numberOfPersons: int.tryParse(_guestsController.text.trim()) ?? 2,
        primaryGuestName: _nameController.text.trim(),
        primaryGuestEmail: _emailController.text.trim(),
        primaryGuestContact: _phoneController.text.trim(),
        guestNote: _notesController.text.trim(),
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reservation confirmed: #${booking.bookingNumber ?? booking.id}'),
            backgroundColor: AppColors.primaryTeal,
          ),
        );
        Navigator.pushNamed(context, '/customer/properties/rating', arguments: booking);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Property reservation failed: $e'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final PropertyListingModel? listing = args is PropertyListingModel ? args : null;
    final propName = listing?.title ?? 'The Ocean Club Villa';
    final ratePerNight = listing?.pricePerNight ?? 1850.0;

    double addonTotal = 0.0;
    for (final idx in _selectedAddons) {
      addonTotal += (_addons[idx]['price'] as double);
    }

    final baseTotal = ratePerNight * _nights;
    final taxAndFees = (baseTotal + addonTotal) * 0.10;
    final grandTotal = baseTotal + addonTotal + taxAndFees;

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
        title: Text('Confirm Property Booking', style: AppTextStyles.titleLarge),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(propName, style: AppTextStyles.headlineLarge),
                  const SizedBox(height: 8),

                  // Interactive Date Selection Card
                  GestureDetector(
                    onTap: _selectDates,
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
                            child: const Icon(Icons.calendar_month_outlined, color: AppColors.primaryTeal, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_formatDisplayDate(_checkInDate)} – ${_formatDisplayDate(_checkOutDate)}',
                                  style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$_nights ${_nights == 1 ? "night" : "nights"} • Tap to change stay dates',
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
                  Text('GUEST INFORMATION', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Lead Guest Name',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Mobile Phone',
                      prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('NUMBER OF GUESTS', style: AppTextStyles.labelSmall),
                      Text('Max: ${listing?.maxGuests ?? 12}', style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _guestsController,
                    style: AppTextStyles.bodyLarge,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.people_outline, color: AppColors.textSecondary, size: 20)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    style: AppTextStyles.bodyMedium,
                    decoration: const InputDecoration(hintText: 'Special requests for butler or concierge...'),
                  ),
                  const SizedBox(height: 24),
                  Text('ADD-ON SERVICES', style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  ..._addons.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final a = entry.value;
                    final isSelected = _selectedAddons.contains(idx);
                    final price = (a['price'] as double).toStringAsFixed(0);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedAddons.remove(idx);
                          } else {
                            _selectedAddons.add(idx);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isSelected ? AppColors.primaryTeal : AppColors.border, width: isSelected ? 1.5 : 1.0),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryTeal : AppColors.badgeTeal,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(a['icon'] as IconData, color: isSelected ? Colors.white : AppColors.primaryTeal, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(a['label'] as String, style: AppTextStyles.titleMedium)),
                            Text('+\$$price', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryTeal : AppColors.cyanPill,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(isSelected ? Icons.check : Icons.add, size: 16, color: isSelected ? Colors.white : AppColors.primaryTeal),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
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
                        _row('$_nights nights × \$${ratePerNight.toStringAsFixed(0)}/night', '\$${baseTotal.toStringAsFixed(2)}'),
                        if (addonTotal > 0)
                          _row('Selected Add-ons', '+\$${addonTotal.toStringAsFixed(2)}'),
                        _row('Butler & Concierge Service', 'Included'),
                        _row('Daily Housekeeping', 'Included'),
                        _row('Bahamas VAT & Taxes (10%)', '\$${taxAndFees.toStringAsFixed(2)}'),
                        const Divider(color: AppColors.border),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TOTAL', style: AppTextStyles.headlineSmall),
                            Text('\$${grandTotal.toStringAsFixed(2)}', style: AppTextStyles.price.copyWith(fontSize: 22)),
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
              label: 'Confirm Booking • \$${grandTotal.toStringAsFixed(2)} →',
              isLoading: _isSubmitting,
              onTap: _isSubmitting ? null : _submitBooking,
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
