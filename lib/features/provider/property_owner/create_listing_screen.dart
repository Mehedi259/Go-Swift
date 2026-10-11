import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/room_service.dart';
import '../../../core/widgets/gs_button.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final RoomService _roomService = RoomService();

  final _titleController = TextEditingController(text: 'Ocean Club Villa #4');
  final _propertyTypeController = TextEditingController(text: 'Oceanfront Villa');
  final _addressController = TextEditingController(text: 'One Ocean Drive, Paradise Island');
  final _regionController = TextEditingController(text: 'Paradise Island');
  final _rateController = TextEditingController(text: '1850');
  final _bedroomsController = TextEditingController(text: '4');
  final _bathroomsController = TextEditingController(text: '4');
  final _maxGuestsController = TextEditingController(text: '8');
  final _descriptionController = TextEditingController(
    text: 'Ultra-luxurious waterfront residence featuring direct private beach access, infinity pool, 24/7 dedicated butler service, and private yacht slip.',
  );

  final List<String> _allAmenities = [
    'Private Pool',
    'Ocean View',
    'Butler Service',
    'Private Beach',
    'Gym & Spa',
    'Yacht Access',
    'Home Cinema',
    'Golf Cart',
    'High-Speed Wi-Fi',
    'Helipad Access',
  ];
  final Set<String> _selectedAmenities = {'Private Pool', 'Ocean View', 'Butler Service', 'Private Beach'};

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _propertyTypeController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    _rateController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _maxGuestsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final rate = double.tryParse(_rateController.text.trim()) ?? 1850.0;
      final bedrooms = int.tryParse(_bedroomsController.text.trim()) ?? 3;
      final bathrooms = int.tryParse(_bathroomsController.text.trim()) ?? 3;
      final maxGuests = int.tryParse(_maxGuestsController.text.trim()) ?? 6;

      await _roomService.createListing(
        title: _titleController.text.trim(),
        propertyType: _propertyTypeController.text.trim(),
        islandRegion: _regionController.text.trim(),
        streetAddress: _addressController.text.trim(),
        nightlyBaseRate: rate,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        maxGuests: maxGuests,
        description: _descriptionController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Luxury Property Listing created successfully!'),
            backgroundColor: AppColors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create listing: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
        title: Text('Create New Listing', style: AppTextStyles.titleLarge),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PROPERTY PHOTOS', style: AppTextStyles.labelSmall),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardTouchpoint,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_photo_alternate_outlined, color: AppColors.cyan, size: 36),
                          const SizedBox(height: 8),
                          Text('Upload High-Res Property Photos', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan, fontWeight: FontWeight.w600)),
                          Text('Supports 4K architectural & aerial drone shots', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _field(
                      label: 'Property Name / Title',
                      icon: Icons.villa_outlined,
                      controller: _titleController,
                      hint: 'e.g. Ocean Club Villa #4',
                      validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _field(
                      label: 'Property Typology',
                      icon: Icons.home_outlined,
                      controller: _propertyTypeController,
                      hint: 'e.g. Oceanfront Villa / Penthouse',
                      validator: (v) => v == null || v.isEmpty ? 'Typology is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _field(
                      label: 'Island Region',
                      icon: Icons.map_outlined,
                      controller: _regionController,
                      hint: 'e.g. Paradise Island, New Providence',
                      validator: (v) => v == null || v.isEmpty ? 'Region is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _field(
                      label: 'Street Address',
                      icon: Icons.location_on_outlined,
                      controller: _addressController,
                      hint: 'e.g. One Ocean Drive, Ocean Club Estates',
                      validator: (v) => v == null || v.isEmpty ? 'Address is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _field(
                      label: 'Nightly Rate (BSD)',
                      icon: Icons.attach_money,
                      controller: _rateController,
                      hint: 'e.g. 1850',
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Rate is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _field(
                            label: 'Bedrooms',
                            icon: Icons.bed_outlined,
                            controller: _bedroomsController,
                            hint: '4',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(
                            label: 'Baths',
                            icon: Icons.bathroom_outlined,
                            controller: _bathroomsController,
                            hint: '4',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(
                            label: 'Guests',
                            icon: Icons.people_outline,
                            controller: _maxGuestsController,
                            hint: '8',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('DESCRIPTION', style: AppTextStyles.labelSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Describe your property, amenities, and unique features...',
                        filled: true,
                        fillColor: AppColors.card,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cyan, width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('AMENITIES', style: AppTextStyles.labelSmall),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allAmenities.map((a) {
                        final isSelected = _selectedAmenities.contains(a);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedAmenities.remove(a);
                              } else {
                                _selectedAmenities.add(a);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.cyan : AppColors.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? AppColors.cyan : AppColors.border),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: Text(
                              a,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GSButton(
                label: _isSubmitting ? 'Creating Listing...' : 'Create Listing →',
                isLoading: _isSubmitting,
                onTap: _isSubmitting ? () {} : _submitListing,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTextStyles.labelSmall),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextStyles.bodyLarge,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: AppColors.cyan, size: 20),
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cyan, width: 1.5)),
            ),
          ),
        ],
      );
}
