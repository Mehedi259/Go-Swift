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
    this.rating = 4.9,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
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
      rating: 4.9,
    );
  }
}

class FoodItemModel {
  final int id;
  final String name;
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
  final double? deliveryFee;
  final String? restaurantName;
  final String? deliveryAddress;
  final String? createdAt;
  final List<FoodOrderItemModel> items;

  String get customerName => 'VIP Dining Guest';

  FoodOrderModel({
    required this.id,
    this.orderNumber,
    required this.status,
    required this.totalAmount,
    this.deliveryFee,
    this.restaurantName,
    this.deliveryAddress,
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
      deliveryFee: double.tryParse(json['delivery_fee']?.toString() ?? '0'),
      restaurantName: json['restaurant_name']?.toString() ?? 'Bahamian Kitchen',
      deliveryAddress: json['delivery_address']?.toString(),
      createdAt: json['created_at']?.toString(),
      items: parsedItems,
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
}
