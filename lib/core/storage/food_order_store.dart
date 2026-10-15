import 'dart:convert';
import '../models/food_model.dart';
import 'local_storage.dart';

class FoodOrderStore {
  static const String _keyOrders = 'gs_restaurant_food_orders_v1';

  static Future<List<FoodOrderModel>> getOrders() async {
    await LocalStorage.init();
    final jsonStr = LocalStorage.prefs.getString(_keyOrders);
    if (jsonStr == null || jsonStr.trim().isEmpty) {
      // Seed initial sample order from mmridul207@gmail.com to test restaurant reception
      final initial = _createSeedOrder();
      await saveOrders([initial]);
      return [initial];
    }
    try {
      final list = jsonDecode(jsonStr) as List;
      final parsed = list
          .whereType<Map<String, dynamic>>()
          .map((e) => FoodOrderModel.fromJson(e))
          .toList();
      if (parsed.isEmpty) {
        final initial = _createSeedOrder();
        await saveOrders([initial]);
        return [initial];
      }
      return parsed;
    } catch (_) {
      return [_createSeedOrder()];
    }
  }

  static Future<void> saveOrders(List<FoodOrderModel> orders) async {
    await LocalStorage.init();
    final jsonStr = jsonEncode(orders.map((o) => o.toJson()).toList());
    await LocalStorage.prefs.setString(_keyOrders, jsonStr);
  }

  static Future<FoodOrderModel> addOrder(FoodOrderModel order) async {
    final current = await getOrders();
    // Prepend new order at the top
    final updated = [order, ...current.where((o) => o.id != order.id)];
    await saveOrders(updated);
    return order;
  }

  static Future<void> updateStatus(int orderId, String newStatus) async {
    final current = await getOrders();
    final updated = current.map((o) {
      if (o.id == orderId) {
        return o.copyWith(status: newStatus.toLowerCase());
      }
      return o;
    }).toList();
    await saveOrders(updated);
  }

  static Future<FoodOrderModel?> getOrderById(int orderId) async {
    final list = await getOrders();
    for (final o in list) {
      if (o.id == orderId) return o;
    }
    return null;
  }

  static FoodOrderModel _createSeedOrder() {
    return FoodOrderModel(
      id: 8421,
      orderNumber: '#GS-8421',
      status: 'placed',
      restaurantName: 'cheta',
      customerFullName: 'dfg',
      customerEmail: 'mmridul207@gmail.com',
      deliveryAddress: 'Albany Marina, Slip B-12, Paradise Island',
      subtotal: 96.00,
      serviceFee: 12.50,
      deliveryFee: 0.00,
      totalAmount: 108.50,
      createdAt: DateTime.now().toIso8601String(),
      items: [
        FoodOrderItemModel(
          id: 1,
          name: 'Fresh Conch Salad Martini',
          quantity: 1,
          price: 28.00,
        ),
        FoodOrderItemModel(
          id: 2,
          name: 'Grilled Spiny Lobster Tail',
          quantity: 1,
          price: 68.00,
        ),
      ],
    );
  }
}
