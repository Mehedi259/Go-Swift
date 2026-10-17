import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/food_model.dart';
import '../../../core/services/food_service.dart';
import '../../../core/services/provider_application_service.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/widgets/gs_bottom_nav.dart';
import '../../../core/widgets/gs_button.dart';
import 'provider_food_item_detail_screen.dart';

class OrdersListScreen extends StatefulWidget {
  final int initialTab;
  const OrdersListScreen({super.key, this.initialTab = 0});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  final FoodService _foodService = FoodService();
  final ProviderApplicationService _providerService = ProviderApplicationService();

  late int _currentTab;
  bool _isLoading = true;
  Timer? _pollTimer;
  DateTime? _lastBackPressTime;

  // Restaurant Profile State
  String _restaurantName = 'cheta';
  String _chefName = 'dablu';
  String _cuisineConcept = 'Fine Bahamian & Haute Seafood';
  String _islandHub = 'Nassau & Paradise Island';
  String _kitchenAddress = 'Ocean Club Drive, Paradise Island, Bahamas';
  String _commercialLine = '+1 (242) 01627021553';
  String _contactEmail = 'mehedihasanmridulcse@gmail.com';
  String _businessLicense = 'gfdg34';
  String _operatingHours = 'Open Daily: 11:30 AM – 11:00 PM';
  String _prepWindow = '20-30 min';
  bool _acceptingOrders = true;

  // Orders State
  List<FoodOrderModel> _liveOrders = [];
  String _selectedOrderStatusFilter = 'ALL';

  // Menu State
  List<FoodItemModel> _menuItems = [];
  List<Map<String, dynamic>> _categories = [];
  int? _selectedCategoryId; // null = All
  bool _isMenuLoading = false;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
    _fetchAllData();
    _pollTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (_currentTab == 0 && mounted) {
        _fetchOrders(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchAllData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _fetchProfile(),
      _fetchOrders(silent: true),
      _fetchMenuData(silent: true),
    ]);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _fetchProfile() async {
    try {
      final p = await _providerService.getRestaurantProfile();
      if (mounted && p.isNotEmpty) {
        setState(() {
          if (p['restaurant_name'] != null && (p['restaurant_name'] as String).isNotEmpty) {
            _restaurantName = p['restaurant_name'];
          }
          if (p['manager_or_head_chef_name'] != null && (p['manager_or_head_chef_name'] as String).isNotEmpty) {
            _chefName = p['manager_or_head_chef_name'];
          }
          if (p['cuisine_concept'] != null && (p['cuisine_concept'] as String).isNotEmpty) {
            _cuisineConcept = p['cuisine_concept'];
          }
          if (p['island_service_hub'] != null && (p['island_service_hub'] as String).isNotEmpty) {
            _islandHub = p['island_service_hub'];
          }
          if (p['kitchen_dispatch_address'] != null && (p['kitchen_dispatch_address'] as String).isNotEmpty) {
            _kitchenAddress = p['kitchen_dispatch_address'];
          }
          if (p['commercial_line'] != null && (p['commercial_line'] as String).isNotEmpty) {
            _commercialLine = p['commercial_line'];
          }
          if (p['contact_email'] != null && (p['contact_email'] as String).isNotEmpty) {
            _contactEmail = p['contact_email'];
          }
          if (p['business_license_number'] != null && (p['business_license_number'] as String).isNotEmpty) {
            _businessLicense = p['business_license_number'];
          }
          if (p['average_prep_window'] != null && (p['average_prep_window'] as String).isNotEmpty) {
            _prepWindow = p['average_prep_window'];
          }
          if (p['accepting_orders'] != null) {
            _acceptingOrders = p['accepting_orders'] == true;
          }
          final hoursRaw = p['operating_hours'];
          if (hoursRaw is Map && hoursRaw.isNotEmpty) {
            _operatingHours = hoursRaw.values.first.toString();
          } else if (hoursRaw is String && hoursRaw.isNotEmpty) {
            _operatingHours = hoursRaw;
          }
        });
      }
    } catch (_) {}
  }

  Future<void> _fetchOrders({bool silent = false}) async {
    try {
      final list = await _foodService.getProviderOrders(restaurantName: _restaurantName);
      if (mounted) {
        setState(() {
          _liveOrders = list;
        });
      }
    } catch (_) {}
  }

  Future<void> _fetchMenuData({bool silent = false}) async {
    if (!silent) setState(() => _isMenuLoading = true);
    try {
      final cats = await _foodService.getCategories();
      final items = await _foodService.getProviderMenuItems();
      if (mounted) {
        setState(() {
          _categories = cats.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          _menuItems = items;
          _isMenuLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isMenuLoading = false);
    }
  }

  Future<void> _toggleAcceptingOrders() async {
    final next = !_acceptingOrders;
    setState(() => _acceptingOrders = next);
    try {
      await _providerService.updateRestaurantProfile(acceptingOrders: next);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next ? 'Kitchen is OPEN & ACCEPTING orders' : 'Kitchen is CLOSED for dispatch'),
            backgroundColor: next ? AppColors.green : AppColors.gold,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      if (mounted) setState(() => _acceptingOrders = !next);
    }
  }

  Future<void> _toggleItemAvailability(FoodItemModel item) async {
    final next = !item.isAvailable;
    try {
      await _foodService.updateFoodItem(item.id, isAvailable: next);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} marked as ${next ? "AVAILABLE" : "SOLD OUT"}'),
            backgroundColor: next ? AppColors.green : AppColors.gold,
            duration: const Duration(seconds: 2),
          ),
        );
        _fetchMenuData(silent: true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update availability: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _deleteItem(FoodItemModel item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Remove Menu Item', style: AppTextStyles.headlineSmall),
        content: Text('Are you sure you want to remove "${item.name}" from your restaurant menu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete Dish', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _foodService.deleteFoodItem(item.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${item.name} removed from menu'), backgroundColor: AppColors.primaryTeal),
          );
          _fetchMenuData(silent: true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete item: $e'), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  static const List<Map<String, String>> _gourmetPresets = [
    {
      'title': 'Spiny Lobster Tail',
      'url': 'https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Fresh Conch Salad',
      'url': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Yellowtail Snapper',
      'url': 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Prime Wagyu Ribeye',
      'url': 'https://images.unsplash.com/photo-1558030006-450675393462?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Island Rum Cake',
      'url': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Gourmet Burger & Truffle',
      'url': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Caribbean Ceviche',
      'url': 'https://images.unsplash.com/photo-1535400255456-984241443b29?auto=format&fit=crop&w=800&q=80',
    },
  ];

  void _showAddDishDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final prepCtrl = TextEditingController(text: '15-20 mins');
    final descCtrl = TextEditingController();
    int? selectedCat = _categories.isNotEmpty ? _categories.first['id'] as int? : null;
    final List<String> availableTags = ['Signature', 'Gluten-Free', 'Catch of the Day', 'Raw Bar', 'Vegetarian', 'Spicy', 'Chef Curated'];
    final Set<String> chosenTags = {'Signature'};
    bool isSaving = false;
    File? pickedDishFile;
    String? selectedPresetUrl;
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.cyanLight, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.restaurant, color: AppColors.cyan, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('Add Culinary Dish', style: AppTextStyles.headlineSmall),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Create a signature gourmet offering for island yacht & villa delivery', style: AppTextStyles.bodySmall),
                const SizedBox(height: 16),

                // Inline Photo Picker & Presets Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.35), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pickedDishFile != null || selectedPresetUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              if (pickedDishFile != null)
                                Image.file(pickedDishFile!, width: double.infinity, height: 140, fit: BoxFit.cover)
                              else
                                Image.network(selectedPresetUrl!, width: double.infinity, height: 140, fit: BoxFit.cover),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => setModalState(() {
                                    pickedDishFile = null;
                                    selectedPresetUrl = null;
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.75),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Text('Change Photo ✕', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryTeal, size: 20),
                            const SizedBox(width: 8),
                            Text('Dish Photo (Required)', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.primaryTeal),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                                icon: const Icon(Icons.camera_alt, size: 16, color: AppColors.primaryTeal),
                                label: const Text('Camera', style: TextStyle(color: AppColors.primaryTeal, fontSize: 12, fontWeight: FontWeight.bold)),
                                onPressed: () async {
                                  final x = await picker.pickImage(source: ImageSource.camera, maxWidth: 1200, maxHeight: 1200, imageQuality: 85);
                                  if (x != null) {
                                    setModalState(() {
                                      pickedDishFile = File(x.path);
                                      selectedPresetUrl = null;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.primaryTeal),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                                icon: const Icon(Icons.photo_library, size: 16, color: AppColors.primaryTeal),
                                label: const Text('Gallery', style: TextStyle(color: AppColors.primaryTeal, fontSize: 12, fontWeight: FontWeight.bold)),
                                onPressed: () async {
                                  final x = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1200, maxHeight: 1200, imageQuality: 85);
                                  if (x != null) {
                                    setModalState(() {
                                      pickedDishFile = File(x.path);
                                      selectedPresetUrl = null;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('Or Pick from Curated Gourmet Presets:', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 70,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _gourmetPresets.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (c, idx) {
                              final preset = _gourmetPresets[idx];
                              return GestureDetector(
                                onTap: () async {
                                  setModalState(() {
                                    selectedPresetUrl = preset['url'];
                                    pickedDishFile = null;
                                  });
                                  try {
                                    final res = await http.get(Uri.parse(preset['url']!));
                                    if (res.statusCode == 200) {
                                      final f = File('${Directory.systemTemp.path}/preset_dish_${DateTime.now().millisecondsSinceEpoch}.jpg');
                                      await f.writeAsBytes(res.bodyBytes);
                                      setModalState(() {
                                        pickedDishFile = f;
                                      });
                                    }
                                  } catch (_) {}
                                },
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(preset['url']!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                                      color: Colors.black.withValues(alpha: 0.65),
                                    ),
                                    child: Text(
                                      preset['title']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Dish Name *',
                    hintText: 'e.g. Bahamian Rock Lobster Tail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: priceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Price (BSD \$) *',
                          hintText: '58.00',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: prepCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Prep Window',
                          hintText: '15-20 mins',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (_categories.isNotEmpty) ...[
                  DropdownButtonFormField<int>(
                    value: selectedCat,
                    decoration: const InputDecoration(
                      labelText: 'Menu Category *',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((c) {
                      return DropdownMenuItem<int>(
                        value: c['id'] is int ? c['id'] as int : int.tryParse(c['id'].toString()),
                        child: Text(c['name']?.toString() ?? 'Category'),
                      );
                    }).toList(),
                    onChanged: (val) => setModalState(() => selectedCat = val),
                  ),
                  const SizedBox(height: 14),
                ],
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Culinary Description & Ingredients',
                    hintText: 'Island spices, garlic confit butter, citrus reduction...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Dietary & Specialty Tags', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableTags.map((tag) {
                    final selected = chosenTags.contains(tag);
                    return FilterChip(
                      label: Text(tag, style: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontSize: 12)),
                      selected: selected,
                      selectedColor: AppColors.cyan,
                      checkmarkColor: Colors.white,
                      backgroundColor: AppColors.cardTouchpoint,
                      onSelected: (val) {
                        setModalState(() {
                          if (val) {
                            chosenTags.add(tag);
                          } else {
                            chosenTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                GSButton(
                  label: isSaving ? 'Publishing Dish...' : 'Publish Dish to Menu →',
                  isLoading: isSaving,
                  onTap: () async {
                    final name = nameCtrl.text.trim();
                    final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
                    if (name.isEmpty || price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter dish name and valid price'), backgroundColor: AppColors.error),
                      );
                      return;
                    }

                    setModalState(() => isSaving = true);
                    try {
                      int? targetCat = selectedCat;
                      if (targetCat == null) {
                        final newCat = await _foodService.createCategory(name: 'Main Menu', description: 'Chef Island Curations');
                        targetCat = newCat['id'] is int ? newCat['id'] as int : int.tryParse(newCat['id'].toString());
                      }

                      await _foodService.createFoodItem(
                        name: name,
                        price: price,
                        description: descCtrl.text.trim(),
                        categoryId: targetCat,
                        prepWindow: prepCtrl.text.trim(),
                        dietaryTags: chosenTags.toList(),
                        photoFile: pickedDishFile,
                      );

                      if (mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('"$name" published successfully with photo!'), backgroundColor: AppColors.green),
                        );
                        _fetchMenuData();
                      }
                    } catch (e) {
                      setModalState(() => isSaving = false);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to create dish: $e'), backgroundColor: AppColors.error),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    final catNameCtrl = TextEditingController();
    final catDescCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('New Menu Category', style: AppTextStyles.headlineSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: catNameCtrl,
              decoration: const InputDecoration(labelText: 'Category Name', hintText: 'e.g. Signature Cocktails & Wines'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: catDescCtrl,
              decoration: const InputDecoration(labelText: 'Short Description', hintText: 'Curated cellars & tropical mixes'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyan, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              final name = catNameCtrl.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(ctx);
                try {
                  await _foodService.createCategory(name: name, description: catDescCtrl.text.trim());
                  _fetchMenuData();
                } catch (_) {}
              }
            },
            child: const Text('Create Category', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditProfileModal() {
    final nameCtrl = TextEditingController(text: _restaurantName);
    final chefCtrl = TextEditingController(text: _chefName);
    final conceptCtrl = TextEditingController(text: _cuisineConcept);
    final hubCtrl = TextEditingController(text: _islandHub);
    final addressCtrl = TextEditingController(text: _kitchenAddress);
    final phoneCtrl = TextEditingController(text: _commercialLine);
    final emailCtrl = TextEditingController(text: _contactEmail);
    final hoursCtrl = TextEditingController(text: _operatingHours);
    final prepCtrl = TextEditingController(text: _prepWindow);
    bool accepting = _acceptingOrders;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.cyanLight, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.storefront, color: AppColors.cyan, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('Edit Restaurant Operations', style: AppTextStyles.headlineSmall),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Update dispatch details, kitchen status, and guest contact info', style: AppTextStyles.bodySmall),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Restaurant / Entity Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: chefCtrl,
                        decoration: const InputDecoration(labelText: 'Executive Chef / Manager', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: prepCtrl,
                        decoration: const InputDecoration(labelText: 'Avg Prep Window', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: conceptCtrl,
                  decoration: const InputDecoration(labelText: 'Cuisine Concept', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hubCtrl,
                  decoration: const InputDecoration(labelText: 'Island Service Hub', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(labelText: 'Kitchen Dispatch Address', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: phoneCtrl,
                        decoration: const InputDecoration(labelText: 'Commercial Phone', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: hoursCtrl,
                        decoration: const InputDecoration(labelText: 'Business Hours', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.green,
                  title: Text('Accepting Delivery Orders', style: AppTextStyles.titleMedium),
                  subtitle: Text('When turned on, your restaurant appears active in guest apps', style: AppTextStyles.bodySmall),
                  value: accepting,
                  onChanged: (val) => setModalState(() => accepting = val),
                ),
                const SizedBox(height: 20),
                GSButton(
                  label: isSaving ? 'Saving Changes...' : 'Save Operations Profile',
                  isLoading: isSaving,
                  onTap: () async {
                    setModalState(() => isSaving = true);
                    try {
                      await _providerService.updateRestaurantProfile(
                        restaurantName: nameCtrl.text.trim(),
                        managerOrHeadChefName: chefCtrl.text.trim(),
                        cuisineConcept: conceptCtrl.text.trim(),
                        islandServiceHub: hubCtrl.text.trim(),
                        kitchenAddress: addressCtrl.text.trim(),
                        commercialLine: phoneCtrl.text.trim(),
                        contactPhone: phoneCtrl.text.trim(),
                        contactEmail: emailCtrl.text.trim(),
                        averagePrepWindow: prepCtrl.text.trim(),
                        operatingHours: hoursCtrl.text.trim(),
                        acceptingOrders: accepting,
                      );
                      if (mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Restaurant profile updated successfully!'), backgroundColor: AppColors.green),
                        );
                        _fetchProfile();
                      }
                    } catch (e) {
                      setModalState(() => isSaving = false);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update: $e'), backgroundColor: AppColors.error),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentTab != 0) {
          setState(() => _currentTab = 0);
          return;
        }
        final now = DateTime.now();
        if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press back again to exit Go-Swift'), duration: Duration(seconds: 2)),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
            : _buildBody(),
        bottomNavigationBar: GSProviderBottomNav(
          currentIndex: _currentTab,
          onTap: (idx) {
            setState(() => _currentTab = idx);
            if (idx == 0) _fetchOrders();
            if (idx == 1) _fetchMenuData();
            if (idx == 2) _fetchProfile();
          },
          items: const [
            ProviderNavItem(
              icon: Icons.receipt_long_outlined,
              activeIcon: Icons.receipt_long,
              label: 'Orders',
            ),
            ProviderNavItem(
              icon: Icons.restaurant_menu_outlined,
              activeIcon: Icons.restaurant_menu,
              label: 'Menu',
            ),
            ProviderNavItem(
              icon: Icons.storefront_outlined,
              activeIcon: Icons.storefront,
              label: 'Kitchen',
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cyanLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
        ),
        child: const Icon(Icons.restaurant, color: AppColors.cyan, size: 20),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_restaurantName, style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _acceptingOrders ? AppColors.green : AppColors.gold,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Text(
            'Chef $_chefName • ${_acceptingOrders ? "Kitchen Open" : "Dispatch Closed"}',
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        if (_currentTab == 1)
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.cyan),
            tooltip: 'Add Dish',
            onPressed: _showAddDishDialog,
          ),
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.cyan),
          tooltip: 'Refresh',
          onPressed: _fetchAllData,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    switch (_currentTab) {
      case 1:
        return _buildMenuTab();
      case 2:
        return _buildKitchenProfileTab();
      default:
        return _buildOrdersTab();
    }
  }

  // =========================================================================
  // TAB 0: KITCHEN ORDERS
  // =========================================================================

  Widget _buildOrdersTab() {
    final filteredOrders = _selectedOrderStatusFilter == 'ALL'
        ? _liveOrders
        : _liveOrders.where((o) => o.status.toUpperCase().contains(_selectedOrderStatusFilter)).toList();

    return RefreshIndicator(
      color: AppColors.primaryTeal,
      onRefresh: () => _fetchOrders(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // Acceptance Toggle Banner
          _buildAcceptanceToggleBanner(),
          const SizedBox(height: 16),

          // Quick Operational Metric Chips
          Row(
            children: [
              _metricChip('Active Orders', '${_liveOrders.where((o) => !o.status.toUpperCase().contains("DELIVERED") && !o.status.toUpperCase().contains("CANCELLED")).length}', AppColors.cyan),
              const SizedBox(width: 10),
              _metricChip('Total Orders', '${_liveOrders.length}', AppColors.gold),
              const SizedBox(width: 10),
              _metricChip('Kitchen Status', _acceptingOrders ? 'OPEN' : 'CLOSED', _acceptingOrders ? AppColors.green : AppColors.error),
            ],
          ),
          const SizedBox(height: 18),

          // Order Status Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['ALL', 'PLACED', 'IN_PREP', 'KITCHEN_SEALED', 'IN_TRANSIT', 'HANDED_OVER'].map((status) {
                final isSelected = _selectedOrderStatusFilter == status;
                final label = status == 'ALL'
                    ? 'All Orders'
                    : status == 'PLACED'
                        ? 'New'
                        : status == 'IN_PREP'
                            ? 'In Kitchen'
                            : status == 'KITCHEN_SEALED'
                                ? 'Sealed'
                                : status == 'IN_TRANSIT'
                                    ? 'In Transit'
                                    : 'Delivered';
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                    selected: isSelected,
                    selectedColor: AppColors.cyan,
                    backgroundColor: AppColors.card,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? AppColors.cyan : AppColors.border)),
                    onSelected: (val) => setState(() => _selectedOrderStatusFilter = status),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          if (filteredOrders.isEmpty)
            _buildEmptyOrdersState()
          else
            ...filteredOrders.map((o) => _buildOrderCard(o)),
        ],
      ),
    );
  }

  Widget _buildAcceptanceToggleBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _acceptingOrders ? AppColors.green.withValues(alpha: 0.3) : AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _acceptingOrders ? AppColors.greenLight : AppColors.cardTouchpoint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _acceptingOrders ? Icons.check_circle_outline : Icons.pause_circle_outline,
              color: _acceptingOrders ? AppColors.green : AppColors.textMuted,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _acceptingOrders ? 'Kitchen Dispatch Open' : 'Kitchen Closed for Dispatch',
                  style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  _acceptingOrders ? 'Accepting yacht & villa dining orders' : 'Guests will see your restaurant as closed',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: _acceptingOrders,
            activeColor: AppColors.green,
            onChanged: (_) => _toggleAcceptingOrders(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(FoodOrderModel o) {
    final id = o.orderNumber ?? '#GS-${o.id}';
    final customer = o.customerName;
    final itemsSummary = o.items.isNotEmpty
        ? o.items.map((it) => '${it.quantity}x ${it.name}').join(', ')
        : (o.deliveryAddress ?? 'Yacht / Villa Delivery');
    final total = '\$${o.totalAmount.toStringAsFixed(2)}';
    final status = o.status.toUpperCase();

    final Color statusColor;
    final Color statusBg;
    if (status.contains('PLACED') || status.contains('NEW') || status.contains('CONFIRMED')) {
      statusColor = AppColors.gold;
      statusBg = AppColors.goldLight;
    } else if (status.contains('PREP') || status.contains('SEALED')) {
      statusColor = AppColors.cyan;
      statusBg = AppColors.cyanLight;
    } else {
      statusColor = AppColors.green;
      statusBg = AppColors.greenLight;
    }

    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          '/provider/restaurant/order-detail',
          arguments: {'id': o.id, 'order': o},
        );
        _fetchOrders();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt, size: 16, color: AppColors.cyan),
                    const SizedBox(width: 6),
                    Text(id, style: AppTextStyles.titleMedium.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                  child: Text(status.replaceAll('_', ' '), style: AppTextStyles.labelSmall.copyWith(color: statusColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(customer, style: AppTextStyles.headlineSmall),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.room_service_outlined, size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    itemsSummary,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (o.deliveryAddress != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 15, color: AppColors.primaryTeal),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      o.deliveryAddress!,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: AppColors.border, height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TOTAL REVENUE', style: AppTextStyles.caption.copyWith(letterSpacing: 1)),
                Text(total, style: AppTextStyles.titleLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyOrdersState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.cardTouchpoint,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.room_service_outlined, size: 36, color: AppColors.primaryTeal),
            ),
            const SizedBox(height: 16),
            Text('No Orders Found', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 6),
            Text(
              'Incoming culinary orders for "cheta" will stream here live.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GSButton(
              label: 'Refresh Orders List',
              isSecondary: true,
              onTap: () => _fetchOrders(),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 1: MENU MANAGEMENT
  // =========================================================================

  Widget _buildMenuTab() {
    final filteredItems = _selectedCategoryId == null
        ? _menuItems
        : _menuItems.where((it) => it.categoryId == _selectedCategoryId).toList();

    return RefreshIndicator(
      color: AppColors.primaryTeal,
      onRefresh: () => _fetchMenuData(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // Categories Bar with Add Category Button
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: Text('All (${_menuItems.length})', style: TextStyle(color: _selectedCategoryId == null ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                        selected: _selectedCategoryId == null,
                        selectedColor: AppColors.cyan,
                        backgroundColor: AppColors.card,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: _selectedCategoryId == null ? AppColors.cyan : AppColors.border)),
                        onSelected: (_) => setState(() => _selectedCategoryId = null),
                      ),
                      const SizedBox(width: 8),
                      ..._categories.map((c) {
                        final catId = c['id'] is int ? c['id'] as int : int.tryParse(c['id'].toString());
                        final isSel = _selectedCategoryId == catId;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(c['name']?.toString() ?? 'Category', style: TextStyle(color: isSel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                            selected: isSel,
                            selectedColor: AppColors.cyan,
                            backgroundColor: AppColors.card,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSel ? AppColors.cyan : AppColors.border)),
                            onSelected: (_) => setState(() => _selectedCategoryId = catId),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_box_outlined, color: AppColors.cyan),
                tooltip: 'Add Category',
                onPressed: _showAddCategoryDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_isMenuLoading)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: AppColors.primaryTeal)))
          else if (filteredItems.isEmpty)
            _buildEmptyMenuState()
          else
            ...filteredItems.map((item) => _buildDishCard(item)),
        ],
      ),
    );
  }

  Widget _buildCardFallbackImage() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        gradient: LinearGradient(
          colors: [Color(0xFFE8F4F8), Color(0xFFD6EDF4)],
        ),
      ),
      child: Center(
        child: Icon(Icons.restaurant_menu, color: AppColors.primaryTeal.withValues(alpha: 0.5), size: 44),
      ),
    );
  }

  Widget _buildDishCard(FoodItemModel item) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProviderFoodItemDetailScreen(
              item: item,
              categories: _categories,
            ),
          ),
        );
        if (result == true) {
          _fetchMenuData();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Hero Image Banner (height: 155)
            Container(
              height: 155,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Stack(
                children: [
                  if (item.photo != null && item.photo!.isNotEmpty)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        child: Image.network(
                          item.photo!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildCardFallbackImage(),
                        ),
                      ),
                    )
                  else
                    _buildCardFallbackImage(),

                  // Dark gradient overlay for text readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.45),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.60),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // Category badge on top-left
                  if (item.categoryName != null && item.categoryName!.isNotEmpty)
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
                          item.categoryName!,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Prep Window badge on top-right
                  if (item.prepWindow != null && item.prepWindow!.isNotEmpty)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_outlined, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              item.prepWindow!,
                              style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Price Tag on bottom-right of image
                  Positioned(
                    bottom: 10,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Text(
                        '\$${item.price.toStringAsFixed(2)} ${item.currency}',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: const Color(0xFF15803D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Body Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (item.description != null && item.description!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      item.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                  if (item.dietaryTags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: item.dietaryTags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDFA),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF99F6E4)),
                        ),
                        child: Text(
                          tag,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: AppColors.border, height: 1),
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.82,
                        child: Switch(
                          value: item.isAvailable,
                          activeColor: AppColors.primaryTeal,
                          onChanged: (_) => _toggleItemAvailability(item),
                        ),
                      ),
                      Text(
                        item.isAvailable ? 'Available' : 'Sold Out',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: item.isAvailable ? const Color(0xFF15803D) : Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.badgeTeal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Details',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primaryTeal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.primaryTeal),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                        tooltip: 'Remove Dish',
                        onPressed: () => _deleteItem(item),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMenuState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(color: AppColors.cardTouchpoint, shape: BoxShape.circle),
              child: const Icon(Icons.restaurant_menu, size: 36, color: AppColors.primaryTeal),
            ),
            const SizedBox(height: 16),
            Text('No Dishes In This Category', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 6),
            Text('Add gourmet items to attract VIP island delivery orders.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            GSButton(
              label: 'Add First Dish →',
              onTap: _showAddDishDialog,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 2: KITCHEN & PROFILE
  // =========================================================================

  Widget _buildKitchenProfileTab() {
    return RefreshIndicator(
      color: AppColors.primaryTeal,
      onRefresh: () => _fetchProfile(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // Restaurant Profile Hero
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.cyanLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.restaurant_outlined, color: AppColors.cyan, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_restaurantName, style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('Head Chef $_chefName', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.cyan, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _acceptingOrders ? AppColors.greenLight : AppColors.goldLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _acceptingOrders ? '● ACCEPTING DISPATCH' : '● KITCHEN PAUSED',
                              style: AppTextStyles.caption.copyWith(
                                color: _acceptingOrders ? AppColors.green : AppColors.gold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _metricChip('Rating', '4.98 ★', AppColors.gold),
                    const SizedBox(width: 8),
                    _metricChip('Prep Window', _prepWindow, AppColors.cyan),
                    const SizedBox(width: 8),
                    _metricChip('Island Hub', 'Nassau', AppColors.primaryTeal),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Restaurant Information
          _buildInfoSection(
            title: 'Culinary & Operations Info',
            items: [
              {'label': 'Cuisine Concept', 'value': _cuisineConcept, 'icon': Icons.dining_outlined},
              {'label': 'Island Service Hub', 'value': _islandHub, 'icon': Icons.map_outlined},
              {'label': 'Kitchen Address', 'value': _kitchenAddress, 'icon': Icons.location_on_outlined},
              {'label': 'Operating Hours', 'value': _operatingHours, 'icon': Icons.access_time_outlined},
            ],
          ),
          const SizedBox(height: 16),

          // Commercial & Legal Info
          _buildInfoSection(
            title: 'Commercial & Dispatch License',
            items: [
              {'label': 'Commercial Line', 'value': _commercialLine, 'icon': Icons.phone_outlined},
              {'label': 'Contact Email', 'value': _contactEmail, 'icon': Icons.email_outlined},
              {'label': 'Business License No.', 'value': _businessLicense, 'icon': Icons.verified_user_outlined},
            ],
          ),
          const SizedBox(height: 24),

          // Action Buttons
          GSButton(
            label: 'Edit Kitchen & Operations Profile',
            isSecondary: false,
            onTap: _showEditProfileModal,
          ),
          const SizedBox(height: 12),

          GSButton(
            label: 'Switch to Customer Account',
            isSecondary: true,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/customer/hub', (_) => false);
            },
          ),
          const SizedBox(height: 12),

          GSButton(
            label: 'Log Out of Restaurant Partner',
            isSecondary: true,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Text('Log Out', style: AppTextStyles.headlineSmall),
                  content: const Text('Are you sure you want to sign out from your restaurant partner session?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Log Out', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await LocalStorage.clearAuth();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/choose-account', (_) => false);
                }
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoSection({required String title, required List<Map<String, dynamic>> items}) {
    return Container(
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
          Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...items.map((it) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(it['icon'] as IconData, size: 18, color: AppColors.cyan),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it['label'] as String, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 2),
                          Text(it['value'] as String, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _metricChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cardTouchpoint,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.titleMedium.copyWith(color: color, fontWeight: FontWeight.bold), maxLines: 1),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.caption.copyWith(fontSize: 11), maxLines: 1),
          ],
        ),
      ),
    );
  }
}
