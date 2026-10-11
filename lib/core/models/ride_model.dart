class RideModel {
  final int id;
  final String status;
  final String pickupAddress;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? pickupNote;
  final String destinationAddress;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final int requestedPassengerCount;
  final String? requestedVehicleCategory;
  final double? distanceKm;
  final int? estimatedDurationMinutes;
  final String currency;
  final double estimatedFare;
  final double? finalFare;
  final double? tipAmount;
  final String paymentStatus;
  final String? customerFullName;
  final String? customerPhoneNumber;
  final DriverProfileModel? driver;
  final String? createdAt;
  final Map<String, dynamic>? review;

  String get customerName => customerFullName ?? 'VIP Rider';

  RideModel({
    required this.id,
    required this.status,
    required this.pickupAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupNote,
    required this.destinationAddress,
    this.destinationLatitude,
    this.destinationLongitude,
    this.requestedPassengerCount = 1,
    this.requestedVehicleCategory,
    this.distanceKm,
    this.estimatedDurationMinutes,
    this.currency = 'BSD',
    required this.estimatedFare,
    this.finalFare,
    this.tipAmount,
    this.paymentStatus = 'pending',
    this.customerFullName,
    this.customerPhoneNumber,
    this.driver,
    this.createdAt,
    this.review,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? 'pending',
      pickupAddress: json['pickup_address']?.toString() ?? '',
      pickupLatitude: json['pickup_latitude'] != null ? double.tryParse(json['pickup_latitude'].toString()) : null,
      pickupLongitude: json['pickup_longitude'] != null ? double.tryParse(json['pickup_longitude'].toString()) : null,
      pickupNote: json['pickup_note']?.toString(),
      destinationAddress: json['destination_address']?.toString() ?? '',
      destinationLatitude: json['destination_latitude'] != null ? double.tryParse(json['destination_latitude'].toString()) : null,
      destinationLongitude: json['destination_longitude'] != null ? double.tryParse(json['destination_longitude'].toString()) : null,
      requestedPassengerCount: json['requested_passenger_count'] is int
          ? json['requested_passenger_count']
          : int.tryParse(json['requested_passenger_count']?.toString() ?? '1') ?? 1,
      requestedVehicleCategory: json['requested_vehicle_category']?.toString(),
      distanceKm: json['distance_km'] != null ? double.tryParse(json['distance_km'].toString()) : null,
      estimatedDurationMinutes: json['estimated_duration_minutes'] != null ? int.tryParse(json['estimated_duration_minutes'].toString()) : null,
      currency: json['currency']?.toString() ?? 'BSD',
      estimatedFare: json['estimated_fare'] != null ? double.tryParse(json['estimated_fare'].toString()) ?? 0.0 : 0.0,
      finalFare: json['final_fare'] != null ? double.tryParse(json['final_fare'].toString()) : null,
      tipAmount: json['tip_amount'] != null ? double.tryParse(json['tip_amount'].toString()) : null,
      paymentStatus: json['payment_status']?.toString() ?? 'pending',
      customerFullName: json['customer_full_name']?.toString(),
      customerPhoneNumber: json['customer_phone_number']?.toString(),
      driver: json['driver'] is Map<String, dynamic> ? DriverProfileModel.fromJson(json['driver'] as Map<String, dynamic>) : null,
      createdAt: json['created_at']?.toString(),
      review: json['review'] is Map<String, dynamic> ? json['review'] as Map<String, dynamic> : null,
    );
  }
}

class DriverProfileModel {
  final int id;
  final String? legalName;
  final String? vehicleMake;
  final String? vehicleModel;
  final String? licensePlate;
  final String? profilePhoto;
  final double? rating;

  DriverProfileModel({
    required this.id,
    this.legalName,
    this.vehicleMake,
    this.vehicleModel,
    this.licensePlate,
    this.profilePhoto,
    this.rating,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      legalName: json['legal_name']?.toString() ?? json['display_name']?.toString(),
      vehicleMake: json['vehicle_make']?.toString(),
      vehicleModel: json['vehicle_model']?.toString(),
      licensePlate: json['license_plate']?.toString(),
      profilePhoto: json['profile_photo']?.toString(),
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : 4.95,
    );
  }
}

class FareEstimateModel {
  final double estimatedFare;
  final String currency;

  FareEstimateModel({required this.estimatedFare, required this.currency});

  factory FareEstimateModel.fromJson(Map<String, dynamic> json) {
    return FareEstimateModel(
      estimatedFare: double.tryParse(json['estimated_fare']?.toString() ?? '0') ?? 0.0,
      currency: json['currency']?.toString() ?? 'BSD',
    );
  }
}
