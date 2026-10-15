import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/property_model.dart';
import '../../../core/services/room_service.dart';
import '../../../core/widgets/gs_card.dart';
import '../../../core/widgets/gs_bottom_nav.dart';

class PropertiesSearchScreen extends StatefulWidget {
  const PropertiesSearchScreen({super.key});

  @override
  State<PropertiesSearchScreen> createState() => _PropertiesSearchScreenState();
}

class _PropertiesSearchScreenState extends State<PropertiesSearchScreen> {
  List<PropertyListingModel> _liveProperties = [];
  bool _isLoading = false;

  final _properties = [
    {
      'id': 7,
      'name': 'Ocean Club Villa #4',
      'type': 'OCEANFRONT VILLA',
      'location': 'Paradise Island • One Ocean Drive',
      'price': '\$1,850/night',
      'rating': 4.98,
      'reviews': 87,
      'badge': 'OCEAN CLUB',
      'beds': 4,
      'baths': 4,
      'photo': 'https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/listing_7_1791995019466.jpg',
      'model': PropertyListingModel(
        id: 7,
        title: 'Ocean Club Villa #4',
        description: 'Ultra-luxurious waterfront residence featuring direct private beach access, infinity pool, 24/7 dedicated butler service, and private yacht slip.',
        bedrooms: 4,
        bathrooms: 4,
        maxGuests: 8,
        islandRegion: 'Paradise Island',
        streetAddress: 'One Ocean Drive, Paradise Island',
        nightlyBaseRate: 1850.0,
        amenities: ['Private Pool', 'Ocean View', 'Butler Service', 'Private Beach'],
        photos: ['https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/listing_7_1791995019466.jpg'],
        rating: 4.98,
      ),
    },
    {
      'id': 6,
      'name': 'Ocean Club Luxury Villa',
      'type': 'LUXURY VILLA',
      'location': 'Paradise Island • Ocean Drive',
      'price': '\$1,850/night',
      'rating': 4.97,
      'reviews': 65,
      'badge': 'PARADISE ISLAND',
      'beds': 4,
      'baths': 4,
      'photo': 'https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/scaled_1000071822.jpg',
      'model': PropertyListingModel(
        id: 6,
        title: 'Ocean Club Luxury Villa',
        description: 'Exclusive Bahamian residence with panoramic sea views, private dock, gourmet kitchen, and lush tropical gardens.',
        bedrooms: 4,
        bathrooms: 4,
        maxGuests: 8,
        islandRegion: 'Paradise Island',
        streetAddress: 'Ocean Drive, Paradise Island',
        nightlyBaseRate: 1850.0,
        amenities: ['Panoramic Sea View', 'Private Dock', 'Gourmet Kitchen', 'Concierge'],
        photos: ['https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/scaled_1000071822.jpg'],
        rating: 4.97,
      ),
    },
    {
      'id': 2,
      'name': 'Oceanfront Luxury Villa & Marina',
      'type': 'BEACHFRONT ESTATE',
      'location': 'Paradise Island • Marina Slip 12',
      'price': '\$1,250/night',
      'rating': 4.95,
      'reviews': 52,
      'badge': 'MARINA ESTATE',
      'beds': 5,
      'baths': 5,
      'photo': 'https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/service_provider_card.png',
      'model': PropertyListingModel(
        id: 2,
        title: 'Oceanfront Luxury Villa & Marina',
        description: 'Expansive oceanfront villa with deep-water yacht dockage, infinity edge pool, and fully staffed concierge service.',
        bedrooms: 5,
        bathrooms: 5,
        maxGuests: 10,
        islandRegion: 'Paradise Island',
        streetAddress: 'Marina Slip 12, Paradise Island',
        nightlyBaseRate: 1250.0,
        amenities: ['Yacht Dockage', 'Infinity Pool', 'Staffed Service', 'Ocean View'],
        photos: ['https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/service_provider_card.png'],
        rating: 4.95,
      ),
    },
    {
      'id': 3,
      'name': 'The Bahamian Palms Beachfront Retreat',
      'type': 'BEACH RESORT RETREAT',
      'location': 'Cable Beach • West Bay St',
      'price': '\$580/night',
      'rating': 4.92,
      'reviews': 38,
      'badge': 'CABLE BEACH',
      'beds': 3,
      'baths': 3,
      'photo': 'https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/retreat_beachfront.jpg',
      'model': PropertyListingModel(
        id: 3,
        title: 'The Bahamian Palms Beachfront Retreat',
        description: 'Sunlit beachfront oasis featuring direct white sand beach access, private plunge pool, and lush tropical flora.',
        bedrooms: 3,
        bathrooms: 3,
        maxGuests: 6,
        islandRegion: 'Cable Beach',
        streetAddress: 'West Bay St, Nassau',
        nightlyBaseRate: 580.0,
        amenities: ['Beachfront Access', 'Plunge Pool', 'Tropical Gardens', 'WiFi'],
        photos: ['https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/retreat_beachfront.jpg'],
        rating: 4.92,
      ),
    },
    {
      'id': 4,
      'name': 'Royal Penthouse Suite & Marina View',
      'type': 'RESORT PENTHOUSE',
      'location': 'Downtown Nassau • Harbor Front',
      'price': '\$420/night',
      'rating': 4.90,
      'reviews': 29,
      'badge': 'DOWNTOWN HARBOR',
      'beds': 2,
      'baths': 2,
      'photo': 'https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/penthouse_suite.jpg',
      'model': PropertyListingModel(
        id: 4,
        title: 'Royal Penthouse Suite & Marina View',
        description: 'Commanding top-floor penthouse with panoramic harbor views, private wraparound balcony, and VIP lounge access.',
        bedrooms: 2,
        bathrooms: 2,
        maxGuests: 4,
        islandRegion: 'Downtown Nassau',
        streetAddress: 'Harbor Front, Nassau',
        nightlyBaseRate: 420.0,
        amenities: ['Harbor View', 'Wraparound Terrace', 'Lounge Access', 'Elevator'],
        photos: ['https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/penthouse_suite.jpg'],
        rating: 4.90,
      ),
    },
    {
      'id': 5,
      'name': 'Coral Reef Sunset Cottage',
      'type': 'PRIVATE ISLAND COTTAGE',
      'location': 'Rose Island • Cove Bay Shore',
      'price': '\$275/night',
      'rating': 4.88,
      'reviews': 19,
      'badge': 'ROSE ISLAND',
      'beds': 2,
      'baths': 1,
      'photo': 'https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/cottage_island.jpg',
      'model': PropertyListingModel(
        id: 5,
        title: 'Coral Reef Sunset Cottage',
        description: 'Secluded private island experience on pristine Rose Island. Includes complimentary ocean kayaks, snorkeling gear, and solar power.',
        bedrooms: 2,
        bathrooms: 1,
        maxGuests: 4,
        islandRegion: 'Rose Island',
        streetAddress: 'Cove Bay Shore, Rose Island',
        nightlyBaseRate: 275.0,
        amenities: ['Beachfront Deck', 'Kayaks Included', 'Snorkeling Gear', 'Solar Powered'],
        photos: ['https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/cottage_island.jpg'],
        rating: 4.88,
      ),
    },
    {
      'id': 1,
      'name': 'Azure Sands Oceanfront Villa',
      'type': 'OCEANFRONT VILLA',
      'location': 'Paradise Island • Cabbage Beach',
      'price': '\$1,450/night',
      'rating': 4.94,
      'reviews': 64,
      'badge': 'PARADISE ISLAND',
      'beds': 4,
      'baths': 4,
      'photo': 'https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/villa_oceanfront_2cX1sqb.jpg',
      'model': PropertyListingModel(
        id: 1,
        title: 'Azure Sands Oceanfront Villa',
        description: 'Signature beachfront villa directly situated along crystal turquoise waters with private boardwalk and heated pool.',
        bedrooms: 4,
        bathrooms: 4,
        maxGuests: 8,
        islandRegion: 'Paradise Island',
        streetAddress: 'Cabbage Beach, Paradise Island',
        nightlyBaseRate: 1450.0,
        amenities: ['Direct Beach Boardwalk', 'Heated Pool', 'Outdoor Grill', 'Sea View'],
        photos: ['https://goswift-media-prod.s3.us-east-1.amazonaws.com/media/room_services/listings/villa_oceanfront_2cX1sqb.jpg'],
        rating: 4.94,
      ),
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    setState(() => _isLoading = true);
    try {
      final list = await RoomService().getListings();
      if (mounted) {
        setState(() {
          _liveProperties = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _displayList {
    if (_liveProperties.isNotEmpty) {
      return _liveProperties.map((l) => {
        'id': l.id,
        'name': l.title,
        'type': l.propertyType.replaceAll('_', ' ').toUpperCase(),
        'location': '${l.city} • ${l.address}',
        'price': '\$${l.pricePerNight.toStringAsFixed(0)}/night',
        'rating': (l.rating ?? 4.95).toDouble(),
        'reviews': 45,
        'badge': l.city.toUpperCase(),
        'beds': l.bedrooms,
        'baths': l.bathrooms,
        'model': l,
        'photo': l.photos.isNotEmpty ? l.photos.first : null,
      }).toList();
    }
    return _properties;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rooms & Properties', style: AppTextStyles.headlineLarge),
                        Text('LUXURY VILLA & RESORT CONCIERGE', style: AppTextStyles.cyanLabel.copyWith(color: AppColors.primaryTeal)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Search & filter
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search villas, penthouses, islands...',
                            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _fetchListings,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: AppColors.primaryTeal, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.tune, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _filterChip('All Properties', true),
                        const SizedBox(width: 8),
                        _filterChip('Oceanfront Villas', false),
                        const SizedBox(width: 8),
                        _filterChip('Penthouse Suites', false),
                        const SizedBox(width: 8),
                        _filterChip('Private Islands', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Properties list
            Expanded(
              child: _isLoading && _liveProperties.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
                  : RefreshIndicator(
                      onRefresh: _fetchListings,
                      color: AppColors.primaryTeal,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _displayList.length,
                        itemBuilder: (c, i) => _PropertyCard(p: _displayList[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GSBottomNav(
        currentIndex: 0,
        onTap: (idx) {
          if (idx == 0) {
            Navigator.pop(context);
          } else if (idx == 1) {
            Navigator.pushNamed(context, '/customer/history');
          } else if (idx == 2) {
            Navigator.pushNamed(context, '/customer/favorites');
          } else if (idx == 3) {
            Navigator.pushNamed(context, '/customer/support');
          } else if (idx == 4) {
            Navigator.pushNamed(context, '/customer/profile');
          }
        },
      ),
    );
  }

  Widget _filterChip(String l, bool active) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: active ? AppColors.primaryTeal : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: active ? AppColors.primaryTeal : AppColors.border),
      boxShadow: AppColors.cardShadow,
    ),
    child: Text(
      l,
      style: AppTextStyles.bodySmall.copyWith(
        color: active ? Colors.white : AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _PropertyCard extends StatelessWidget {
  final Map<String, dynamic> p;
  const _PropertyCard({required this.p});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/customer/properties/details',
        arguments: p['model'] ?? p,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                color: AppColors.cardTouchpoint,
                image: (p['photo'] != null && p['photo'].toString().isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(p['photo'].toString()),
                        fit: BoxFit.cover,
                      )
                    : null,
                gradient: (p['photo'] != null && p['photo'].toString().isNotEmpty)
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFFE8F4F8), Color(0xFFD6EDF4)],
                      ),
              ),
              child: Stack(
                children: [
                  if (p['photo'] == null || p['photo'].toString().isEmpty)
                    Center(child: Icon(Icons.villa, color: AppColors.primaryTeal.withValues(alpha: 0.5), size: 54))
                  else
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                          gradient: LinearGradient(
                            colors: [Colors.black.withValues(alpha: 0.35), Colors.transparent, Colors.black.withValues(alpha: 0.55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Text(p['badge'] as String, style: AppTextStyles.labelSmall.copyWith(color: const Color(0xFF8A5300), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: const Icon(Icons.favorite_border, color: AppColors.primaryTeal, size: 16),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(p['type'] as String, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary)),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: GSRatingRow(rating: (p['rating'] as num).toDouble(), reviews: p['reviews'] as int),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(p['name'] as String, style: AppTextStyles.headlineSmall)),
                      Text(p['price'] as String, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(child: Text(p['location'] as String, style: AppTextStyles.bodySmall)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.bed_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('${p['beds']} Beds', style: AppTextStyles.bodySmall),
                      const SizedBox(width: 14),
                      const Icon(Icons.bathtub_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('${p['baths']} Baths', style: AppTextStyles.bodySmall),
                      const SizedBox(width: 14),
                      const Icon(Icons.pool_outlined, size: 16, color: AppColors.primaryTeal),
                      const SizedBox(width: 4),
                      Text('Private Pool', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w600)),
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
}
