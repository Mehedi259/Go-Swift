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
          imageUrls.add(m['image'].toString());
        }
      }
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

