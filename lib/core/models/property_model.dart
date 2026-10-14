class PropertyListingModel {
  final int id;
  final String title;
  final String? description;
  final int bedrooms;
  final int bathrooms;
  final int maxGuests;
  final String? islandRegion;
  final String? streetAddress;
  final bool gatedCommunity;
  final double nightlyBaseRate;
  final String currency;
  final int minimumStayNights;
  final double? cleaningFee;
  final List<String> amenities;
  final List<String> photos;
  final double? rating;
  final bool isActive;

  PropertyListingModel({
    required this.id,
    required this.title,
    this.description,
    this.bedrooms = 3,
    this.bathrooms = 2,
    this.maxGuests = 6,
    this.islandRegion,
    this.streetAddress,
    this.gatedCommunity = false,
    required this.nightlyBaseRate,
    this.currency = 'BSD',
    this.minimumStayNights = 1,
    this.cleaningFee,
    this.amenities = const [],
    this.photos = const [],
    this.rating,
    this.isActive = true,
  });

  double get pricePerNight => nightlyBaseRate;
  String get city => islandRegion ?? 'Nassau';
  String get address => streetAddress ?? 'Paradise Island';
  String get propertyType => 'villa';

  static const List<String> _curatedVillaPhotos = [
    'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1613490493576-7fde63acd811?auto=format&fit=crop&w=1200&q=80',
  ];

  factory PropertyListingModel.fromJson(Map<String, dynamic> json) {
    List<String> photoUrls = [];
    if (json['photos'] is List) {
      for (final p in json['photos'] as List) {
        if (p is Map && p['image'] != null && p['image'].toString().isNotEmpty) {
          photoUrls.add(p['image'].toString());
        } else if (p is String && p.isNotEmpty) {
          photoUrls.add(p);
        }
      }
    }

    final idVal = json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0;

    // If no uploaded photos yet, use a curated Bahamian estate photo for a premium aesthetic
    if (photoUrls.isEmpty) {
      final fallbackIndex = idVal > 0 ? (idVal - 1) % _curatedVillaPhotos.length : 0;
      photoUrls.add(_curatedVillaPhotos[fallbackIndex]);
    }

    List<String> amenitiesList = [];
    if (json['amenities'] is List) {
      amenitiesList = (json['amenities'] as List).map((e) => e.toString()).toList();
    }

    double? avgRating;
    if (json['average_rating'] != null) {
      avgRating = double.tryParse(json['average_rating'].toString());
    }

    return PropertyListingModel(
      id: idVal,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      bedrooms: json['bedrooms'] is int ? json['bedrooms'] : int.tryParse(json['bedrooms']?.toString() ?? '3') ?? 3,
      bathrooms: json['bathrooms'] is int ? json['bathrooms'] : int.tryParse(json['bathrooms']?.toString() ?? '2') ?? 2,
      maxGuests: json['max_guests'] is int ? json['max_guests'] : int.tryParse(json['max_guests']?.toString() ?? '6') ?? 6,
      islandRegion: json['island_region']?.toString() ?? 'Paradise Island',
      streetAddress: json['street_address']?.toString(),
      gatedCommunity: json['gated_community'] == true,
      nightlyBaseRate: double.tryParse(json['nightly_base_rate']?.toString() ?? '0') ?? 0.0,
      currency: json['currency']?.toString() ?? 'BSD',
      minimumStayNights: json['minimum_stay_nights'] is int ? json['minimum_stay_nights'] : 1,
      cleaningFee: double.tryParse(json['cleaning_fee']?.toString() ?? '0'),
      amenities: amenitiesList,
      photos: photoUrls,
      rating: avgRating,
      isActive: json['is_active'] != false,
    );
  }
}

class RoomBookingModel {
  final int id;
  final String? bookingNumber;
  final String status;
  final String checkInDate;
  final String checkOutDate;
  final int totalNights;
  final double totalPrice;
  final String? propertyTitle;
  final String? createdAt;

  RoomBookingModel({
    required this.id,
    this.bookingNumber,
    required this.status,
    required this.checkInDate,
    required this.checkOutDate,
    this.totalNights = 1,
    required this.totalPrice,
    this.propertyTitle,
    this.createdAt,
  });

  factory RoomBookingModel.fromJson(Map<String, dynamic> json) {
    return RoomBookingModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      bookingNumber: json['booking_number']?.toString() ?? '#PB-${json['id']}',
      status: json['status']?.toString() ?? 'pending',
      checkInDate: json['check_in_date']?.toString() ?? '',
      checkOutDate: json['check_out_date']?.toString() ?? '',
      totalNights: json['total_nights'] is int ? json['total_nights'] : int.tryParse(json['total_nights']?.toString() ?? '1') ?? 1,
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      propertyTitle: json['property_title']?.toString() ?? (json['listing'] is Map ? json['listing']['title'] : null),
      createdAt: json['created_at']?.toString(),
    );
  }
}
