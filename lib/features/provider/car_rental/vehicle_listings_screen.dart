import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/services/car_rental_service.dart';

class VehicleListingsScreen extends StatefulWidget {
  const VehicleListingsScreen({super.key});

  @override
  State<VehicleListingsScreen> createState() => _VehicleListingsScreenState();
}

class _VehicleListingsScreenState extends State<VehicleListingsScreen> {
  final CarRentalService _rentalService = CarRentalService();
  List<CarRentalVehicleModel> _liveVehicles = [];
  bool _isLoading = true;
  String _totalFleet = '3';
  String _activeRentals = '1';
  String _monthlyEarnings = '\$4,200';

  final List<Map<String, dynamic>> _fallbackVehicles = [
    {'name': 'Cadillac Escalade ESV', 'plate': 'BS-942-EX', 'status': 'Active Rental', 'rate': '\$285/day', 'color': AppColors.green},
    {'name': 'Range Rover Sport', 'plate': 'BS-441-YZ', 'status': 'Available', 'rate': '\$245/day', 'color': AppColors.cyan},
    {'name': 'Lamborghini Urus', 'plate': 'BS-009-LM', 'status': 'Maintenance', 'rate': '\$850/day', 'color': AppColors.gold},
  ];

  @override
  void initState() {
    super.initState();
    _loadFleetData();
  }

  Future<void> _loadFleetData() async {
    try {
      final stats = await _rentalService.getProviderStats();
      if (mounted && stats.isNotEmpty) {
        setState(() {
          if (stats['total_vehicles'] != null) _totalFleet = '${stats['total_vehicles']}';
          if (stats['confirmed_bookings'] != null) _activeRentals = '${stats['confirmed_bookings']}';
        });
      }
    } catch (_) {}

    try {
      final bookings = await _rentalService.getFleetBookings();
      if (mounted && bookings.isNotEmpty) {
        final earnings = bookings
            .where((b) => b.status.toLowerCase() != 'cancelled')
            .fold<double>(0.0, (sum, b) => sum + b.totalPrice);
        if (earnings > 0) {
          setState(() {
            _monthlyEarnings = '\$${earnings.toStringAsFixed(0)}';
          });
        }
      }
    } catch (_) {}

    try {
      final list = await _rentalService.getFleetVehicles();
      if (mounted) {
        setState(() {
          _liveVehicles = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddVehicleDialog() {
    final makeCtrl = TextEditingController();
    final modelCtrl = TextEditingController();
    final yearCtrl = TextEditingController(text: '2024');
    final rateCtrl = TextEditingController();
    final plateCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Add Fleet Vehicle', style: AppTextStyles.headlineSmall),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: makeCtrl,
                decoration: const InputDecoration(labelText: 'Make', hintText: 'e.g. Mercedes-Benz'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: modelCtrl,
                decoration: const InputDecoration(labelText: 'Model', hintText: 'e.g. G 63 AMG'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: yearCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Year', hintText: '2024'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: plateCtrl,
                decoration: const InputDecoration(labelText: 'License Plate', hintText: 'BS-882-VIP'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: rateCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Daily Rate (\$)', hintText: '350.00'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyan,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final make = makeCtrl.text.trim();
              final model = modelCtrl.text.trim();
              final year = int.tryParse(yearCtrl.text.trim()) ?? 2024;
              final rate = double.tryParse(rateCtrl.text.trim()) ?? 0.0;
              final plate = plateCtrl.text.trim();

              if (make.isNotEmpty && model.isNotEmpty && rate > 0) {
                Navigator.pop(ctx);
                try {
                  await _rentalService.addVehicle(
                    make: make,
                    model: model,
                    year: year,
                    licensePlate: plate.isNotEmpty ? plate : 'BS-NP',
                    dailyRate: rate,
                  );
                  _loadFleetData();
                } catch (_) {}
              }
            },
            child: const Text('Add Vehicle', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useLive = _liveVehicles.isNotEmpty;
    final count = useLive ? _liveVehicles.length : _fallbackVehicles.length;

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
        title: Text('My Fleet', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: AppColors.cyan),
            tooltip: 'Bookings',
            onPressed: () => Navigator.pushNamed(context, '/provider/rental/bookings'),
          ),
          IconButton(
            icon: const Icon(Icons.attach_money, color: AppColors.gold),
            tooltip: 'Earnings',
            onPressed: () => Navigator.pushNamed(context, '/provider/rental/earnings'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.cyan),
            tooltip: 'Profile',
            onPressed: () => Navigator.pushNamed(context, '/provider/rental/profile'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _showAddVehicleDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Add',
                      style: AppTextStyles.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: _stat(_totalFleet, 'Total Fleet', AppColors.cyan)),
                const SizedBox(width: 10),
                Expanded(child: _stat(_activeRentals, 'Active Rentals', AppColors.green)),
                const SizedBox(width: 10),
                Expanded(child: _stat(_monthlyEarnings, 'This Month', AppColors.gold)),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: count,
                    itemBuilder: (c, i) {
                      final String name;
                      final String plate;
                      final String status;
                      final String rate;
                      final Color statusColor;

                      if (useLive) {
                        final v = _liveVehicles[i];
                        name = '${v.make ?? ''} ${v.model ?? ''} (${v.year ?? ''})'.trim();
                        plate = v.licensePlate ?? 'BS-NP';
                        status = v.isAvailable ? 'Available' : 'Booked';
                        rate = '\$${v.dailyRate}/day';
                        statusColor = v.isAvailable ? AppColors.cyan : AppColors.green;
                      } else {
                        final v = _fallbackVehicles[i];
                        name = v['name'] as String;
                        plate = v['plate'] as String;
                        status = v['status'] as String;
                        rate = v['rate'] as String;
                        statusColor = v['color'] as Color;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: AppColors.cardTouchpoint,
                              ),
                              child: const Center(
                                child: Icon(Icons.directions_car, size: 54, color: AppColors.cyan),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: AppTextStyles.titleMedium),
                                    const SizedBox(height: 2),
                                    Text(plate, style: AppTextStyles.bodySmall),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      rate,
                                      style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        status,
                                        style: AppTextStyles.caption.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String val, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Text(val, style: AppTextStyles.price.copyWith(color: color, fontSize: 20)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
