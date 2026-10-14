import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();

  File? _pickedImageFile;
  String? _selectedPresetUrl;

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

  static const List<Map<String, String>> _curatedPresets = [
    {
      'title': 'Oceanfront Luxury Villa',
      'url': 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'title': 'Bahamian Palms Retreat',
      'url': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'title': 'Sunset Bay Cliff Residence',
      'url': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'title': 'Royal Marina Penthouse',
      'url': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'title': 'Coral Reef Cove Cottage',
      'url': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'title': 'Turquoise Beach Estate',
      'url': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80',
    },
  ];

  final List<String> _typologies = [
    'Oceanfront Villa',
    'Penthouse Suite',
    'Private Island Estate',
    'Beach Cottage',
    'Waterfront Residence',
  ];

  final List<String> _regions = [
    'Paradise Island',
    'Rose Island',
    'Exuma',
    'Eleuthera',
    'New Providence',
  ];

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
  void initState() {
    super.initState();
    // Default to the first curated preset photo so a new listing always has a rich luxury photo
    _selectedPresetUrl = _curatedPresets.first['url'];
  }

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

  Future<void> _showPhotoPickerOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Select Property Cover Photo', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: AppColors.cyanLight, shape: BoxShape.circle),
                  child: const Icon(Icons.photo_library_outlined, color: AppColors.cyan),
                ),
                title: Text('Choose from Device Gallery', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text('Select an architectural photo from your phone', style: AppTextStyles.caption),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                    if (picked != null) {
                      setState(() {
                        _pickedImageFile = File(picked.path);
                        _selectedPresetUrl = null;
                      });
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gallery pick failed: $e')));
                    }
                  }
                },
              ),
              const Divider(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: AppColors.cyanLight, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_outlined, color: AppColors.cyan),
                ),
                title: Text('Take Photo with Camera', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text('Capture current villa or room view', style: AppTextStyles.caption),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
                    if (picked != null) {
                      setState(() {
                        _pickedImageFile = File(picked.path);
                        _selectedPresetUrl = null;
                      });
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera capture failed: $e')));
                    }
                  }
                },
              ),
              const Divider(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: AppColors.cyanLight, shape: BoxShape.circle),
                  child: const Icon(Icons.auto_awesome, color: AppColors.gold),
                ),
                title: Text('Choose from Curated Bahamas Showcase', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text('Pick 4K architectural & aerial shots from gallery', style: AppTextStyles.caption),
                onTap: () {
                  Navigator.pop(ctx);
                  _showPresetPicker();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showPresetPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Curated Bahamas Showcase Photos', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
              Text('Tap any image to select as this property’s cover photo', style: AppTextStyles.caption),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _curatedPresets.length,
                  itemBuilder: (context, i) {
                    final item = _curatedPresets[i];
                    final isSelected = _selectedPresetUrl == item['url'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPresetUrl = item['url'];
                          _pickedImageFile = null;
                        });
                        Navigator.pop(ctx);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(item['url']!, fit: BoxFit.cover),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                child: Text(
                                  item['title']!,
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                                  child: const Icon(Icons.check, color: Colors.white, size: 14),
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
      ),
    );
  }

  Widget _photoPickerWidget() {
    final hasPhoto = _pickedImageFile != null || (_selectedPresetUrl != null && _selectedPresetUrl!.isNotEmpty);

    return GestureDetector(
      onTap: _showPhotoPickerOptions,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasPhoto ? AppColors.cyan : AppColors.border,
            width: hasPhoto ? 1.5 : 1.0,
          ),
          boxShadow: AppColors.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: hasPhoto
            ? Stack(
                fit: StackFit.expand,
                children: [
                  if (_pickedImageFile != null)
                    Image.file(_pickedImageFile!, fit: BoxFit.cover)
                  else if (_selectedPresetUrl != null)
                    Image.network(_selectedPresetUrl!, fit: BoxFit.cover),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent, Colors.black.withValues(alpha: 0.4)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Cover Photo Attached',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _pickedImageFile = null;
                          _selectedPresetUrl = null;
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
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.cyan,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text('Change Photo', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.cyanLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_a_photo_outlined, color: AppColors.cyan, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Upload High-Res Property Photo',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to choose from Gallery, Camera, or Curated Showcase',
                    style: AppTextStyles.caption.copyWith(fontSize: 11),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final rate = double.tryParse(_rateController.text.trim()) ?? 1850.0;
      final bedrooms = int.tryParse(_bedroomsController.text.trim()) ?? 3;
      final bathrooms = double.tryParse(_bathroomsController.text.trim()) ?? 2.0;
      final maxGuests = int.tryParse(_maxGuestsController.text.trim()) ?? 6;

      // 1. Create listing
      final newListing = await _roomService.createListing(
        title: _titleController.text.trim(),
        propertyType: _propertyTypeController.text.trim(),
        islandRegion: _regionController.text.trim(),
        streetAddress: _addressController.text.trim(),
        nightlyBaseRate: rate,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        maxGuests: maxGuests,
        description: _descriptionController.text.trim(),
        amenities: _selectedAmenities.toList(),
      );

      // 2. Upload photo if selected
      if (_pickedImageFile != null) {
        await _roomService.uploadListingPhoto(
          newListing.id,
          file: _pickedImageFile,
          isCover: true,
          caption: _titleController.text.trim(),
        ).catchError((_) => <String, dynamic>{});
      } else if (_selectedPresetUrl != null && _selectedPresetUrl!.isNotEmpty) {
        await _roomService.uploadListingPhoto(
          newListing.id,
          photoUrl: _selectedPresetUrl,
          isCover: true,
          caption: _titleController.text.trim(),
        ).catchError((_) => <String, dynamic>{});
      }

      // 3. Seed availability so it is active and bookable immediately
      await _roomService.seedListingAvailability(newListing.id, days: 14, rateOverride: rate);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Luxury Property Listing created & published successfully!'),
            backgroundColor: AppColors.green,
            duration: Duration(seconds: 3),
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
                    _photoPickerWidget(),
                    const SizedBox(height: 20),
                    _field(
                      label: 'Property Name / Title',
                      icon: Icons.villa_outlined,
                      controller: _titleController,
                      hint: 'e.g. Ocean Club Villa #4',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _field(
                      label: 'Property Typology',
                      icon: Icons.home_outlined,
                      controller: _propertyTypeController,
                      hint: 'e.g. Oceanfront Villa / Penthouse',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Typology is required' : null,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _typologies.map((t) {
                        final isSel = _propertyTypeController.text == t;
                        return ChoiceChip(
                          label: Text(t, style: TextStyle(fontSize: 12, color: isSel ? Colors.white : AppColors.textPrimary)),
                          selected: isSel,
                          selectedColor: AppColors.cyan,
                          backgroundColor: AppColors.card,
                          onSelected: (_) => setState(() => _propertyTypeController.text = t),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _field(
                      label: 'Island Region',
                      icon: Icons.map_outlined,
                      controller: _regionController,
                      hint: 'e.g. Paradise Island, New Providence',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Region is required' : null,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _regions.map((r) {
                        final isSel = _regionController.text == r;
                        return ChoiceChip(
                          label: Text(r, style: TextStyle(fontSize: 12, color: isSel ? Colors.white : AppColors.textPrimary)),
                          selected: isSel,
                          selectedColor: AppColors.cyan,
                          backgroundColor: AppColors.card,
                          onSelected: (_) => setState(() => _regionController.text = r),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _field(
                      label: 'Street Address',
                      icon: Icons.location_on_outlined,
                      controller: _addressController,
                      hint: 'e.g. One Ocean Drive, Ocean Club Estates',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Address is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _field(
                      label: 'Nightly Rate (USD / BSD)',
                      icon: Icons.attach_money,
                      controller: _rateController,
                      hint: 'e.g. 1850',
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Rate is required' : null,
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
                            validator: (v) => v == null || v.trim().isEmpty ? 'Req' : null,
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
                            validator: (v) => v == null || v.trim().isEmpty ? 'Req' : null,
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
                            validator: (v) => v == null || v.trim().isEmpty ? 'Req' : null,
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
                      validator: (v) => v == null || v.trim().isEmpty ? 'Description is required' : null,
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
                label: _isSubmitting ? 'Publishing Luxury Listing...' : 'Create Listing →',
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
