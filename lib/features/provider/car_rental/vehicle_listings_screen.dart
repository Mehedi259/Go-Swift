import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/services/car_rental_service.dart';
import '../../../core/widgets/gs_button.dart';

class VehicleListingsScreen extends StatefulWidget {
  const VehicleListingsScreen({super.key});

  @override
  State<VehicleListingsScreen> createState() => _VehicleListingsScreenState();
}

class _VehicleListingsScreenState extends State<VehicleListingsScreen> {
  final CarRentalService _rentalService = CarRentalService();
  List<CarRentalVehicleModel> _liveVehicles = [];
  bool _isLoading = true;
  String _totalFleet = '0';
  String _activeRentals = '0';
  String _monthlyEarnings = '\$0';

  @override
  void initState() {
    super.initState();
    _loadFleetData();
  }

  Future<void> _loadFleetData() async {
    setState(() => _isLoading = true);
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
          _totalFleet = '${list.length}';
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteVehicle(int id) async {
    try {
      await _rentalService.deleteVehicle(id);
      _loadFleetData();
    } catch (_) {}
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
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Fleet Vehicle', style: AppTextStyles.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: makeCtrl,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(labelText: 'Make (e.g. Cadillac, Mercedes)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: modelCtrl,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(labelText: 'Model (e.g. Escalade ESV)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: yearCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(labelText: 'Year'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: plateCtrl,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(labelText: 'License Plate (e.g. BS-942-EX)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: rateCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(labelText: 'Daily Rate USD / BSD'),
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
                : RefreshIndicator(
                    color: AppColors.primaryTeal,
                    onRefresh: _loadFleetData,
                    child: _liveVehicles.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _liveVehicles.length,
                            itemBuilder: (c, i) {
                              final v = _liveVehicles[i];
                              final name = '${v.make ?? ''} ${v.model ?? ''} (${v.year ?? ''})'.trim();
                              final plate = v.licensePlate ?? 'BS-NP';
                              final status = v.isAvailable ? 'Available' : 'Booked';
                              final rate = '\$${v.dailyRate.toStringAsFixed(0)}/day';
                              final statusColor = v.isAvailable ? AppColors.cyan : AppColors.green;

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
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Icon(
                                              Icons.directions_car,
                                              size: 54,
                                              color: AppColors.cyan.withValues(alpha: 0.4),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.9),
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: AppColors.border),
                                              ),
                                              child: Text(plate, style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: statusColor.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(status, style: AppTextStyles.labelSmall.copyWith(color: statusColor, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(name, style: AppTextStyles.titleMedium),
                                        Text(rate, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.gold)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => _deleteVehicle(v.id),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                color: AppColors.error.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Remove',
                                                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.directions_car_outlined, size: 38, color: AppColors.primaryTeal),
            ),
            const SizedBox(height: 20),
            Text('No Fleet Vehicles Registered', style: AppTextStyles.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Add your luxury SUVs and executive fleet vehicles to receive guest bookings in the Bahamas.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GSButton(
              label: 'Add Vehicle to Fleet →',
              onTap: _showAddVehicleDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String v, String l, Color c) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Text(v, style: AppTextStyles.headlineSmall.copyWith(color: c, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(l, style: AppTextStyles.caption),
          ],
        ),
      );
}
