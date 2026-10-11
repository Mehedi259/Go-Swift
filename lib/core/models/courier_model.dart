class CourierDeliveryModel {
  final int id;
  final String status;
  final String pickupAddress;
  final String? pickupNotes;
  final String dropoffAddress;
  final String? dropoffNotes;
  final String packageSize;
  final String? packageDescription;
  final String? recipientName;
  final String? recipientPhone;
  final double estimatedFare;
  final double? finalFare;
  final String currency;
  final String? pickupPin;
  final String? courierName;
  final String? createdAt;

  CourierDeliveryModel({
    required this.id,
    required this.status,
    required this.pickupAddress,
    this.pickupNotes,
    required this.dropoffAddress,
    this.dropoffNotes,
    this.packageSize = 'small_parcel',
    this.packageDescription,
    this.recipientName,
    this.recipientPhone,
    required this.estimatedFare,
    this.finalFare,
    this.currency = 'BSD',
    this.pickupPin,
    this.courierName,
    this.createdAt,
  });

  String get trackingNumber => '#CS-$id';
  String get deliveryAddress => dropoffAddress;
  double get fee => finalFare ?? estimatedFare;

  factory CourierDeliveryModel.fromJson(Map<String, dynamic> json) {
    return CourierDeliveryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? 'pending',
      pickupAddress: json['pickup_address']?.toString() ?? '',
      pickupNotes: json['pickup_notes']?.toString(),
      dropoffAddress: json['dropoff_address']?.toString() ?? '',
      dropoffNotes: json['dropoff_notes']?.toString(),
      packageSize: json['package_size']?.toString() ?? 'small_parcel',
      packageDescription: json['package_description']?.toString(),
      recipientName: json['recipient_name']?.toString(),
      recipientPhone: json['recipient_phone']?.toString(),
      estimatedFare: double.tryParse(json['estimated_fare']?.toString() ?? '0') ?? 0.0,
      finalFare: json['final_fare'] != null ? double.tryParse(json['final_fare'].toString()) : null,
      currency: json['currency']?.toString() ?? 'BSD',
      pickupPin: json['pickup_handover_pin']?.toString(),
      courierName: json['courier_name']?.toString() ?? (json['courier'] is Map ? json['courier']['legal_name']?.toString() : null),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class CourierFareEstimateModel {
  final double estimatedFare;
  final String currency;

  CourierFareEstimateModel({required this.estimatedFare, required this.currency});

  factory CourierFareEstimateModel.fromJson(Map<String, dynamic> json) {
    return CourierFareEstimateModel(
      estimatedFare: double.tryParse(json['estimated_fare']?.toString() ?? '0') ?? 0.0,
      currency: json['currency']?.toString() ?? 'BSD',
    );
  }
}

typedef CourierOrderModel = CourierDeliveryModel;

