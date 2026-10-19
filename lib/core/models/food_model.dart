class RestaurantModel {
  final int id;
  final String name;
  final String? photo;
  final String? logo;
  final String? cuisineConcept;
  final String? islandHub;
  final String? address;
  final String? averagePrepWindow;
  final bool acceptingOrders;
  final bool isActive;
  final double rating;
  final int reviewsCount;

  RestaurantModel({
    required this.id,
    required this.name,
    this.photo,
    this.logo,
    this.cuisineConcept,
    this.islandHub,
    this.address,
    this.averagePrepWindow,
    this.acceptingOrders = true,
    this.isActive = true,
    this.rating = 0.0,
    this.reviewsCount = 0,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    final rawRating = json['rating'] ?? json['average_rating'];
    final parsedRating = rawRating != null ? double.tryParse(rawRating.toString()) : null;
    final rawReviews = json['reviews_count'] ?? json['reviews'] ?? json['total_reviews'];
    final parsedReviews = rawReviews != null ? int.tryParse(rawReviews.toString()) ?? 0 : 0;

    return RestaurantModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['restaurant_name']?.toString() ?? '',
      photo: json['restaurant_photo']?.toString(),
      logo: json['logo']?.toString(),
      cuisineConcept: json['cuisine_concept']?.toString() ?? 'Haute Island Cuisine',
      islandHub: json['island_service_hub']?.toString() ?? 'Nassau & Paradise Island',
      address: json['kitchen_dispatch_address']?.toString(),
      averagePrepWindow: json['average_prep_window']?.toString() ?? '20-30 min',
      acceptingOrders: json['accepting_orders'] == true,
      isActive: json['is_active'] != false,
      rating: parsedRating ?? 0.0,
      reviewsCount: parsedReviews,
    );
  }
}

class FoodItemModel {
  final int id;
  final String name;
  final int? categoryId;
  final String? categoryName;
  final String? photo;
  final String? description;
  final double price;
  final String currency;
  final String? prepWindow;
  final List<String> dietaryTags;
  final bool availableToday;

  bool get isAvailable => availableToday;

  FoodItemModel({
    required this.id,
    required this.name,
    this.categoryId,
    this.categoryName,
    this.photo,
    this.description,
    required this.price,
    this.currency = 'BSD',
    this.prepWindow,
    this.dietaryTags = const [],
    this.availableToday = true,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    final tagsRaw = json['dietary_tags'];
    List<String> tags = [];
    if (tagsRaw is List) {
      tags = tagsRaw.map((e) => e.toString()).toList();
    }
    return FoodItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      categoryId: json['category'] is int ? json['category'] as int : int.tryParse(json['category']?.toString() ?? ''),
      categoryName: json['category_name']?.toString(),
      photo: json['photo']?.toString(),
      description: json['culinary_description']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      currency: json['currency']?.toString() ?? 'BSD',
      prepWindow: json['estimated_prep_window']?.toString(),
      dietaryTags: tags,
      availableToday: json['available_today'] != false,
    );
  }
}

class FoodOrderModel {
  final int id;
  final String? orderNumber;
  final String status;
  final double totalAmount;
  final double? subtotal;
  final double? serviceFee;
  final double? deliveryFee;
  final String? restaurantName;
  final String? deliveryAddress;
  final String? customerFullName;
  final String? customerEmail;
  final String? createdAt;
  final List<FoodOrderItemModel> items;

  String get customerName {
    if (customerFullName != null && customerFullName!.trim().isNotEmpty) {
      return customerFullName!;
    }
    if (customerEmail != null && customerEmail!.trim().isNotEmpty) {
      return customerEmail!;
    }
    return 'VIP Dining Guest';
  }

  FoodOrderModel({
    required this.id,
    this.orderNumber,
    required this.status,
    required this.totalAmount,
    this.subtotal,
    this.serviceFee,
    this.deliveryFee,
    this.restaurantName,
    this.deliveryAddress,
    this.customerFullName,
    this.customerEmail,
    this.createdAt,
    this.items = const [],
  });

  factory FoodOrderModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'];
    List<FoodOrderItemModel> parsedItems = [];
    if (rawItems is List) {
      parsedItems = rawItems
          .whereType<Map<String, dynamic>>()
          .map((e) => FoodOrderItemModel.fromJson(e))
          .toList();
    }
    return FoodOrderModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderNumber: json['order_number']?.toString() ?? '#GS-${json['id']}',
      status: json['status']?.toString() ?? 'placed',
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0'),
      serviceFee: double.tryParse(json['service_fee']?.toString() ?? '0'),
      deliveryFee: double.tryParse(json['delivery_fee']?.toString() ?? '0'),
      restaurantName: json['restaurant_name']?.toString() ?? 'The Ocean Club Restaurant',
      deliveryAddress: json['delivery_address']?.toString(),
      customerFullName: json['customer_full_name']?.toString() ?? json['customer_name']?.toString(),
      customerEmail: json['customer_email']?.toString(),
      createdAt: json['created_at']?.toString(),
      items: parsedItems,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_number': orderNumber,
    'status': status,
    'total_amount': totalAmount,
    'subtotal': subtotal,
    'service_fee': serviceFee,
    'delivery_fee': deliveryFee,
    'restaurant_name': restaurantName,
    'delivery_address': deliveryAddress,
    'customer_full_name': customerFullName,
    'customer_email': customerEmail,
    'created_at': createdAt,
    'items': items.map((e) => e.toJson()).toList(),
  };

  FoodOrderModel copyWith({String? status}) {
    return FoodOrderModel(
      id: id,
      orderNumber: orderNumber,
      status: status ?? this.status,
      totalAmount: totalAmount,
      subtotal: subtotal,
      serviceFee: serviceFee,
      deliveryFee: deliveryFee,
      restaurantName: restaurantName,
      deliveryAddress: deliveryAddress,
      customerFullName: customerFullName,
      customerEmail: customerEmail,
      createdAt: createdAt,
      items: items,
    );
  }
}

class FoodOrderItemModel {
  final int id;
  final String name;
  final int quantity;
  final double price;

  FoodOrderItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory FoodOrderItemModel.fromJson(Map<String, dynamic> json) {
    return FoodOrderItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['item_name']?.toString() ?? json['name']?.toString() ?? '',
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'item_name': name,
    'quantity': quantity,
    'price': price,
  };
}
