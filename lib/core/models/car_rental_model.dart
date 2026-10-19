class RentalVehicleModel {
  final int id;
  final String name;
  final String? make;
  final String? model;
  final int? year;
  final String category;
  final String? licensePlate;
  final int seatingCapacity;
  final int luggageCapacity;
  final String transmission;
  final String fuelType;
  final String? description;
  final String? location;
  final double dailyRate;
  final String currency;
  final bool available;
  final List<String> images;
  final double rating;

  bool get isAvailable => available;

  String get displayImageUrl {
    if (images.isNotEmpty && images.first.isNotEmpty) return images.first;
    return getCarRentalFallbackImage(
      name: name,
      make: make,
      model: model,
      category: category,
      seed: id,
    );
  }

  RentalVehicleModel({
    required this.id,
    required this.name,
    this.make,
    this.model,
    this.year,
    this.category = 'luxury_suv',
    this.licensePlate,
    this.seatingCapacity = 5,
    this.luggageCapacity = 3,
    this.transmission = 'automatic',
    this.fuelType = 'petrol',
    this.description,
    this.location,
    required this.dailyRate,
    this.currency = 'BSD',
    this.available = true,
    this.images = const [],
    this.rating = 4.95,
  });

  factory RentalVehicleModel.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = [];
    if (json['media'] is List) {
      for (final m in json['media'] as List) {
        if (m is Map && m['image'] != null) {
          String img = m['image'].toString();
          if (img.startsWith('/')) {
            img = 'http://184.192.34.206$img';
          }
          imageUrls.add(img);
        } else if (m is String && m.isNotEmpty) {
          String img = m;
          if (img.startsWith('/')) {
            img = 'http://184.192.34.206$img';
          }
          imageUrls.add(img);
        }
      }
    }
    if (json['images'] is List) {
      for (final item in json['images'] as List) {
        if (item is String && item.isNotEmpty) {
          String img = item;
          if (img.startsWith('/')) {
            img = 'http://184.192.34.206$img';
          }
          if (!imageUrls.contains(img)) imageUrls.add(img);
        } else if (item is Map && item['image'] != null) {
          String img = item['image'].toString();
          if (img.startsWith('/')) {
            img = 'http://184.192.34.206$img';
          }
          if (!imageUrls.contains(img)) imageUrls.add(img);
        }
      }
    }
    if (json['image'] is String && (json['image'] as String).isNotEmpty) {
      String img = json['image'].toString();
      if (img.startsWith('/')) {
        img = 'http://184.192.34.206$img';
      }
      if (!imageUrls.contains(img)) imageUrls.add(img);
    }

    return RentalVehicleModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '${json['make'] ?? ''} ${json['model'] ?? ''}'.trim(),
      make: json['make']?.toString(),
      model: json['model']?.toString(),
      year: json['year'] is int ? json['year'] : int.tryParse(json['year']?.toString() ?? '2025'),
      category: json['category']?.toString() ?? 'luxury_suv',
      licensePlate: json['license_plate']?.toString(),
      seatingCapacity: json['seating_capacity'] is int ? json['seating_capacity'] : 5,
      luggageCapacity: json['luggage_capacity'] is int ? json['luggage_capacity'] : 3,
      transmission: json['transmission']?.toString() ?? 'automatic',
      fuelType: json['fuel_type']?.toString() ?? 'petrol',
      description: json['description']?.toString(),
      location: json['location']?.toString(),
      dailyRate: double.tryParse(json['daily_rate']?.toString() ?? '0') ?? 0.0,
      currency: json['currency']?.toString() ?? 'BSD',
      available: json['available'] != false,
      images: imageUrls,
      rating: double.tryParse(json['average_rating']?.toString() ?? '4.95') ?? 4.95,
    );
  }
}

class CarRentalBookingModel {
  final int id;
  final String? bookingNumber;
  final String status;
  final String startDate;
  final String endDate;
  final int totalDays;
  final double totalPrice;
  final String? vehicleName;
  final String? licensePlate;
  final String? createdAt;

  CarRentalBookingModel({
    required this.id,
    this.bookingNumber,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.totalDays = 1,
    required this.totalPrice,
    this.vehicleName,
    this.licensePlate,
    this.createdAt,
  });

  String get customerName => 'VIP Client';

  factory CarRentalBookingModel.fromJson(Map<String, dynamic> json) {
    return CarRentalBookingModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      bookingNumber: json['booking_number']?.toString() ?? '#CR-${json['id']}',
      status: json['status']?.toString() ?? 'pending',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      totalDays: json['total_days'] is int ? json['total_days'] : int.tryParse(json['total_days']?.toString() ?? '1') ?? 1,
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      vehicleName: json['vehicle_name']?.toString() ?? (json['vehicle'] is Map ? json['vehicle']['name'] : null),
      licensePlate: json['license_plate']?.toString() ?? (json['vehicle'] is Map ? json['vehicle']['license_plate']?.toString() : null),
      createdAt: json['created_at']?.toString(),
    );
  }
}

typedef CarRentalVehicleModel = RentalVehicleModel;

String getCarRentalFallbackImage({
  String? name,
  String? make,
  String? model,
  String? category,
  int? seed,
}) {
  final text = '${make ?? ''} ${model ?? ''} ${name ?? ''}'.toLowerCase();
  if (text.contains('escalade') || text.contains('cadillac')) {
    return 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80';
  }
  if (text.contains('mercedes') || text.contains('g63') || text.contains('amg') || text.contains('s-class') || text.contains('benz')) {
    return 'https://images.unsplash.com/photo-1520031441872-265e4ff70366?auto=format&fit=crop&w=800&q=80';
  }
  if (text.contains('porsche') || text.contains('911') || text.contains('carrera')) {
    return 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=800&q=80';
  }
  if (text.contains('bmw') || text.contains('m8') || text.contains('x7') || text.contains('m60i')) {
    return 'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=800&q=80';
  }
  if (text.contains('range rover') || text.contains('land rover') || text.contains('autobiography')) {
    return 'https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=800&q=80';
  }
  if (text.contains('lamborghini') || text.contains('urus')) {
    return 'https://images.unsplash.com/photo-1544829099-b9a0c07fad1a?auto=format&fit=crop&w=800&q=80';
  }
  if (text.contains('ferrari') || text.contains('488') || text.contains('spider')) {
    return 'https://images.unsplash.com/photo-1583121274602-3e2820c69888?auto=format&fit=crop&w=800&q=80';
  }
  if (text.contains('corvette') || text.contains('chevrolet')) {
    return 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=80';
  }

  final cat = (category ?? '').toLowerCase();
  if (cat.contains('convertible') || cat.contains('sports')) {
    return 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=800&q=80';
  }
  if (cat.contains('sedan') || cat.contains('executive')) {
    return 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=800&q=80';
  }

  const curated = [
    'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1520031441872-265e4ff70366?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=80',
  ];
  final idx = (seed ?? 0).abs() % curated.length;
  return curated[idx];
}

