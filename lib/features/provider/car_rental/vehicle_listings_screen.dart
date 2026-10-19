import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/car_rental_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/car_rental_service.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/widgets/gs_button.dart';

class VehicleListingsScreen extends StatefulWidget {
  final bool embedded;
  const VehicleListingsScreen({super.key, this.embedded = false});

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
  DateTime? _lastBackPressTime;

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

  static const List<Map<String, String>> _curatedCarPresets = [
    {
      'title': 'Cadillac Escalade ESV',
      'make': 'Cadillac',
      'model': 'Escalade ESV',
      'year': '2025',
      'rate': '350',
      'category': 'luxury_suv',
      'url': 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Mercedes-Benz G63 AMG',
      'make': 'Mercedes-Benz',
      'model': 'G63 AMG',
      'year': '2024',
      'rate': '550',
      'category': 'luxury_suv',
      'url': 'https://images.unsplash.com/photo-1520031441872-265e4ff70366?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Porsche 911 Carrera Cabrio',
      'make': 'Porsche',
      'model': '911 Carrera',
      'year': '2024',
      'rate': '480',
      'category': 'convertible',
      'url': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'BMW X7 M60i Luxury',
      'make': 'BMW',
      'model': 'X7 M60i',
      'year': '2024',
      'rate': '390',
      'category': 'luxury_suv',
      'url': 'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Range Rover Autobiography',
      'make': 'Land Rover',
      'model': 'Range Rover',
      'year': '2024',
      'rate': '420',
      'category': 'luxury_suv',
      'url': 'https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Chevrolet Corvette Stingray',
      'make': 'Chevrolet',
      'model': 'Corvette C8',
      'year': '2024',
      'rate': '320',
      'category': 'sports_car',
      'url': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=80',
    },
  ];

  void _showAddVehicleDialog() {
    final makeCtrl = TextEditingController();
    final modelCtrl = TextEditingController();
    final yearCtrl = TextEditingController(text: '2024');
    final rateCtrl = TextEditingController();
    final plateCtrl = TextEditingController();
    String selectedCategory = 'luxury_suv';
    File? pickedImageFile;
    String? selectedPresetUrl;
    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: !isSubmitting,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final hasImage = pickedImageFile != null || selectedPresetUrl != null;

          return AlertDialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add Fleet Vehicle', style: AppTextStyles.titleLarge),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: AppColors.textMuted),
                  onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                ),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vehicle Cover Photo', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: isSubmitting
                          ? null
                          : () {
                              _showPhotoSourceOptions(context, (file, url, preset) {
                                setDialogState(() {
                                  pickedImageFile = file;
                                  selectedPresetUrl = url;
                                  if (preset != null) {
                                    if (makeCtrl.text.isEmpty) makeCtrl.text = preset['make'] ?? '';
                                    if (modelCtrl.text.isEmpty) modelCtrl.text = preset['model'] ?? '';
                                    if (yearCtrl.text.isEmpty || yearCtrl.text == '2024') yearCtrl.text = preset['year'] ?? '2024';
                                    if (rateCtrl.text.isEmpty) rateCtrl.text = preset['rate'] ?? '350';
                                    if (preset['category'] != null) selectedCategory = preset['category']!;
                                  }
                                });
                              });
                            },
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.cardTouchpoint,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: hasImage ? AppColors.cyan : AppColors.border,
                            width: hasImage ? 2.0 : 1.2,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: hasImage
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  if (pickedImageFile != null)
                                    Image.file(pickedImageFile!, fit: BoxFit.cover)
                                  else if (selectedPresetUrl != null)
                                    Image.network(selectedPresetUrl!, fit: BoxFit.cover),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent, Colors.black.withValues(alpha: 0.4)],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.green.withValues(alpha: 0.95),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check_circle, color: Colors.white, size: 14),
                                          SizedBox(width: 4),
                                          Text('Photo Selected', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setDialogState(() {
                                          pickedImageFile = null;
                                          selectedPresetUrl = null;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.65),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text('Tap to change', style: TextStyle(color: Colors.white, fontSize: 11)),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.cyanLight,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
                                    ),
                                    child: const Icon(Icons.add_a_photo, color: AppColors.cyan, size: 26),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('Upload Vehicle Photo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                                  const SizedBox(height: 2),
                                  Text('Camera, Gallery, or Luxury Presets', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: yearCtrl,
                            keyboardType: TextInputType.number,
                            style: AppTextStyles.bodyMedium,
                            decoration: const InputDecoration(labelText: 'Year'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: rateCtrl,
                            keyboardType: TextInputType.number,
                            style: AppTextStyles.bodyMedium,
                            decoration: const InputDecoration(labelText: 'Daily Rate (\$)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: plateCtrl,
                      style: AppTextStyles.bodyMedium,
                      decoration: const InputDecoration(labelText: 'License Plate (e.g. BS-942-EX)'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
              ),
              GestureDetector(
                onTap: isSubmitting
                    ? null
                    : () async {
                        final make = makeCtrl.text.trim();
                        final model = modelCtrl.text.trim();
                        final year = int.tryParse(yearCtrl.text.trim()) ?? 2024;
                        final rate = double.tryParse(rateCtrl.text.trim()) ?? 0.0;
                        final plate = plateCtrl.text.trim();

                        if (make.isEmpty || model.isEmpty || rate <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter Make, Model, and a valid Daily Rate'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        setDialogState(() => isSubmitting = true);

                        try {
                          final newVehicle = await _rentalService.addVehicle(
                            make: make,
                            model: model,
                            year: year,
                            category: selectedCategory,
                            licensePlate: plate.isNotEmpty ? plate : 'BS-${DateTime.now().millisecondsSinceEpoch % 10000}',
                            dailyRate: rate,
                          );

                          // Upload vehicle media if selected
                          if (pickedImageFile != null) {
                            try {
                              await _rentalService.uploadVehicleMedia(
                                vehicleId: newVehicle.id,
                                imageFile: pickedImageFile!,
                              );
                            } catch (uploadErr) {
                              debugPrint('Failed to upload vehicle media: $uploadErr');
                            }
                          }

                          if (ctx.mounted) Navigator.pop(ctx);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$make $model added to fleet successfully!'),
                                backgroundColor: AppColors.cyan,
                              ),
                            );
                            _loadFleetData();
                          }
                        } catch (e) {
                          setDialogState(() => isSubmitting = false);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to add vehicle: $e'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cyan,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Add Vehicle',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPhotoSourceOptions(
    BuildContext parentContext,
    Function(File? file, String? url, Map<String, String>? preset) onSelected,
  ) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Vehicle Cover Photo', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Choose how you want to add photo for this vehicle', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _photoOptionButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () async {
                      Navigator.pop(bottomSheetContext);
                      final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 85);
                      if (picked != null) {
                        onSelected(File(picked.path), null, null);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _photoOptionButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () async {
                      Navigator.pop(bottomSheetContext);
                      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
                      if (picked != null) {
                        onSelected(File(picked.path), null, null);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _photoOptionButton(
              icon: Icons.auto_awesome,
              label: 'Curated Bahamas Luxury Presets',
              isWide: true,
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _showPresetsSheet(parentContext, onSelected);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isWide = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          mainAxisAlignment: isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.cyan, size: 22),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPresetsSheet(
    BuildContext parentContext,
    Function(File? file, String? url, Map<String, String>? preset) onSelected,
  ) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(parentContext).size.height * 0.75,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Curated Luxury Vehicle Presets', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Select a vehicle image to automatically attach and fill details', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: _curatedCarPresets.length,
                itemBuilder: (context, i) {
                  final preset = _curatedCarPresets[i];
                  return GestureDetector(
                    onTap: () async {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(
                          content: Text('Attaching ${preset['title']} photo...'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                      try {
                        final res = await http.get(Uri.parse(preset['url']!));
                        final tempDir = await getTemporaryDirectory();
                        final file = File('${tempDir.path}/preset_${DateTime.now().millisecondsSinceEpoch}.jpg');
                        await file.writeAsBytes(res.bodyBytes);
                        onSelected(file, preset['url'], preset);
                      } catch (_) {
                        onSelected(null, preset['url'], preset);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(preset['url']!, fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  preset['title']!,
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '\$${preset['rate']}/day',
                                  style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getVehicleImageUrl(RentalVehicleModel v) => v.displayImageUrl;

  @override
  Widget build(BuildContext context) {
    final bodyContent = Column(
      children: [
        _buildTopHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
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
          _buildAddVehicleBanner(),
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
                                      height: 140,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: AppColors.cardTouchpoint,
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            _getVehicleImageUrl(v),
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Center(
                                              child: Icon(
                                                Icons.directions_car,
                                                size: 54,
                                                color: AppColors.cyan.withValues(alpha: 0.4),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.black.withValues(alpha: 0.35),
                                                  Colors.transparent,
                                                  Colors.black.withValues(alpha: 0.4),
                                                ],
                                              ),
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
                                                color: statusColor.withValues(alpha: 0.9),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(status, style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(name, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.airline_seat_recline_normal, size: 14, color: AppColors.textSecondary),
                                                  const SizedBox(width: 4),
                                                  Text('${v.seatingCapacity} Seats', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                                  const SizedBox(width: 12),
                                                  Icon(Icons.speed, size: 14, color: AppColors.textSecondary),
                                                  const SizedBox(width: 4),
                                                  Text(v.transmission.toUpperCase(), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
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
    );

    if (widget.embedded) {
      return Container(
        color: AppColors.background,
        child: bodyContent,
      );
    }

    final scaffoldContent = Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.cyan,
        elevation: 3,
        icon: const Icon(Icons.add, color: Colors.white, size: 20),
        label: const Text('Add Vehicle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        onPressed: _showAddVehicleDialog,
      ),
      body: bodyContent,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
          boxShadow: [
            BoxShadow(
              color: Color(0x060B2238),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.directions_car_outlined, Icons.directions_car, 'Fleet', true, () {}),
                _navItem(Icons.calendar_month_outlined, Icons.calendar_month, 'Bookings', false, () => Navigator.pushNamed(context, '/provider/rental/bookings')),
                _navItem(Icons.attach_money, Icons.attach_money, 'Earnings', false, () => Navigator.pushNamed(context, '/provider/rental/earnings')),
                _navItem(Icons.business_outlined, Icons.business, 'Profile', false, () => Navigator.pushNamed(context, '/provider/rental/profile')),
              ],
            ),
          ),
        ),
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit Go-Swift'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: scaffoldContent,
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.8)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cyanLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
              ),
              child: const Icon(Icons.directions_car, color: AppColors.cyan, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('My Fleet', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold), maxLines: 1),
                  Text('Bahamas Luxury', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cyan), maxLines: 1),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _showAddVehicleDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Add Car',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.error, size: 20),
              tooltip: 'Sign Out',
              onPressed: _confirmLogout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddVehicleBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cyan, AppColors.cyanDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add New Vehicle', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text('List luxury SUVs, sedans & sports cars', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _showAddVehicleDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                '+ Add',
                style: TextStyle(
                  color: AppColors.cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Log Out', style: AppTextStyles.headlineSmall),
        content: const Text('Are you sure you want to sign out from your rental partner session?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(90, 40),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      if (mounted) {
        await context.read<AuthProvider>().logout();
      } else {
        await LocalStorage.clearAuth();
      }
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/customer/login', (_) => false);
      }
    }
  }

  Widget _navItem(IconData icon, IconData activeIcon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? AppColors.cyan : AppColors.textMuted,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isActive ? AppColors.cyan : AppColors.textMuted,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
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
