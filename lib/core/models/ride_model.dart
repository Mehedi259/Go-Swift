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
  final double? driverCurrentLatitude;
  final double? driverCurrentLongitude;
  final int? estimatedPickupMinutes;
  final DriverProfileModel? driver;
  final String? createdAt;
  final Map<String, dynamic>? review;
  final String? serviceArea;
  final double? baseFee;
  final double? distanceRate;
  final double? platformCommissionRate;
  final double? platformCommission;
  final double? driverPayout;
  final String? payoutStatus;

  String get customerName => customerFullName ?? 'VIP Rider';

  double get effectiveFare => finalFare ?? estimatedFare;
  double get effectiveCommission => platformCommission ?? (effectiveFare * 0.20);
  double get effectiveDriverEarnings => driverPayout ?? (effectiveFare - effectiveCommission);
  double get totalDriverTakeHome => effectiveDriverEarnings + (tipAmount ?? 0.0);

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
    this.driverCurrentLatitude,
    this.driverCurrentLongitude,
    this.estimatedPickupMinutes,
    this.driver,
    this.createdAt,
    this.review,
    this.serviceArea,
    this.baseFee,
    this.distanceRate,
    this.platformCommissionRate,
    this.platformCommission,
    this.driverPayout,
    this.payoutStatus,
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
      driverCurrentLatitude: json['driver_current_latitude'] != null ? double.tryParse(json['driver_current_latitude'].toString()) : null,
      driverCurrentLongitude: json['driver_current_longitude'] != null ? double.tryParse(json['driver_current_longitude'].toString()) : null,
      estimatedPickupMinutes: json['estimated_pickup_minutes'] != null ? int.tryParse(json['estimated_pickup_minutes'].toString()) : null,
      driver: json['driver'] is Map<String, dynamic> ? DriverProfileModel.fromJson(json['driver'] as Map<String, dynamic>) : null,
      createdAt: json['created_at']?.toString(),
      review: json['review'] is Map<String, dynamic> ? json['review'] as Map<String, dynamic> : null,
      serviceArea: json['service_area']?.toString(),
      baseFee: json['base_fee'] != null ? double.tryParse(json['base_fee'].toString()) : null,
      distanceRate: json['distance_rate'] != null ? double.tryParse(json['distance_rate'].toString()) : null,
      platformCommissionRate: json['platform_commission_rate'] != null ? double.tryParse(json['platform_commission_rate'].toString()) : null,
      platformCommission: json['platform_commission'] != null ? double.tryParse(json['platform_commission'].toString()) : null,
      driverPayout: json['driver_payout'] != null ? double.tryParse(json['driver_payout'].toString()) : null,
      payoutStatus: json['payout_status']?.toString(),
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
  final String? contactPhone;

  DriverProfileModel({
    required this.id,
    this.legalName,
    this.vehicleMake,
    this.vehicleModel,
    this.licensePlate,
    this.profilePhoto,
    this.rating,
    this.contactPhone,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      legalName: json['legal_name']?.toString() ?? json['display_name']?.toString() ?? json['user_full_name']?.toString(),
      vehicleMake: json['vehicle_make']?.toString(),
      vehicleModel: json['vehicle_model']?.toString(),
      licensePlate: json['license_plate']?.toString(),
      profilePhoto: json['profile_photo']?.toString(),
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : 4.95,
      contactPhone: json['contact_phone']?.toString() ?? json['contact_phone_number']?.toString() ?? json['phone_number']?.toString(),
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
