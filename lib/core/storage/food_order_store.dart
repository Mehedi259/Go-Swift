import 'dart:convert';
import '../models/food_model.dart';
import 'local_storage.dart';

class FoodOrderStore {
  static const String _keyOrders = 'gs_restaurant_food_orders_v1';

  static Future<List<FoodOrderModel>> getOrders() async {
    await LocalStorage.init();
    final jsonStr = LocalStorage.prefs.getString(_keyOrders);
    if (jsonStr == null || jsonStr.trim().isEmpty) {
      return [];
    }
    try {
      final list = jsonDecode(jsonStr) as List;
      final parsed = list
          .whereType<Map<String, dynamic>>()
          .map((e) => FoodOrderModel.fromJson(e))
          .where((o) => o.id != 8421)
          .toList();
      return parsed;
    } catch (_) {
      return [];
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

  static Future<void> clear() async {
    await LocalStorage.init();
    await LocalStorage.prefs.remove(_keyOrders);
  }
}
