import '../models/food_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class FoodService {
  final ApiClient _api = ApiClient.instance;

  // --- RESTAURANTS ---
  Future<List<RestaurantModel>> getRestaurants({String? search, String? cuisine}) async {
    final params = <String, String>{};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (cuisine != null && cuisine.isNotEmpty) params['cuisine'] = cuisine;

    final response = await _api.get(ApiEndpoints.restaurants, queryParams: params);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<RestaurantModel> getRestaurantDetail(int id) async {
    final response = await _api.get(ApiEndpoints.restaurantDetail(id));
    return RestaurantModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<FoodItemModel>> getRestaurantMenu(int restaurantId) async {
    final response = await _api.get(ApiEndpoints.restaurantMenu(restaurantId));
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // --- ORDERS ---
  Future<FoodOrderModel> createOrder({
    required int restaurantId,
    required List<Map<String, dynamic>> items,
    required String deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String? deliveryNotes,
    String paymentMethod = 'card',
  }) async {
    final response = await _api.post(
      ApiEndpoints.customerFoodOrders,
      body: {
        'restaurant_id': restaurantId,
        'items': items,
        'delivery_address': deliveryAddress,
        'delivery_latitude': deliveryLatitude ?? 25.0772,
        'delivery_longitude': deliveryLongitude ?? -77.3031,
        if (deliveryNotes != null) 'delivery_note': deliveryNotes,
        'payment_method': paymentMethod,
      },
    );
    return FoodOrderModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<FoodOrderModel>> getMyOrders() async {
    final response = await _api.get(ApiEndpoints.customerFoodOrders);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => FoodOrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<FoodOrderModel> getOrderDetail(int id) async {
    final response = await _api.get(ApiEndpoints.customerFoodOrderDetail(id));
    return FoodOrderModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> cancelOrder(int id, {required String reason}) async {
    await _api.post(
      ApiEndpoints.customerFoodOrderCancel(id),
      body: {'reason': reason},
    );
  }

  // --- RESTAURANT PROVIDER ---
  Future<List<FoodOrderModel>> getProviderOrders() async {
    final response = await _api.get(ApiEndpoints.restaurantProviderOrders);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => FoodOrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> updateOrderStatus(int id, [String status = 'preparing']) async {
    await _api.post(
      ApiEndpoints.restaurantProviderOrderStatus(id),
      body: {'status': status},
    );
  }

  Future<List<FoodItemModel>> getProviderItems() async {
    final response = await _api.get(ApiEndpoints.restaurantProviderItems);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<FoodItemModel>> getProviderMenuItems() => getProviderItems();

  Future<FoodOrderModel> getProviderOrderDetail(int id) async {
    final response = await _api.get(ApiEndpoints.restaurantProviderOrderDetail(id));
    return FoodOrderModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<dynamic>> getCategories() async {
    final response = await _api.get(ApiEndpoints.restaurantProviderCategories);
    if (response is List) return response;
    if (response is Map && response['results'] is List) return response['results'] as List;
    return [];
  }

  Future<Map<String, dynamic>> createCategory({
    required String name,
    String? description,
    int displayOrder = 0,
  }) async {
    final response = await _api.post(
      ApiEndpoints.restaurantProviderCategories,
      body: {
        'name': name,
        if (description != null) 'description': description,
        'display_order': displayOrder,
        'is_active': true,
      },
    );
    return response as Map<String, dynamic>;
  }

  Future<FoodItemModel> createFoodItem({
    required String name,
    required double price,
    String? description,
    int? categoryId,
    List<String>? dietaryTags,
    bool isAvailable = true,
  }) async {
    final response = await _api.post(
      ApiEndpoints.restaurantProviderItems,
      body: {
        'name': name,
        'price': price,
        if (description != null) 'description': description,
        if (categoryId != null) 'category': categoryId,
        if (dietaryTags != null) 'dietary_tags': dietaryTags,
        'is_available': isAvailable,
      },
    );
    return FoodItemModel.fromJson(response as Map<String, dynamic>);
  }
}
