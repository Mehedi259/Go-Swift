import '../models/notification_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class NotificationService {
  final ApiClient _api = ApiClient.instance;

  Future<List<NotificationModel>> getNotifications({bool? isRead, int page = 1}) async {
    final params = <String, String>{};
    if (isRead != null) params['is_read'] = isRead.toString();
    if (page > 1) params['page'] = page.toString();

    final response = await _api.get(ApiEndpoints.notifications, queryParams: params);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<NotificationModel> markRead(int id) async {
    final response = await _api.post(ApiEndpoints.notificationMarkRead(id));
    return NotificationModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> markAllRead() async {
    await _api.post(ApiEndpoints.notificationMarkAllRead);
  }

  Future<int> getUnreadCount() async {
    final response = await _api.get(ApiEndpoints.notificationUnreadCount);
    if (response is Map && response['unread_count'] != null) {
      return int.tryParse(response['unread_count'].toString()) ?? 0;
    }
    return 0;
  }

  Future<void> clearRead() async {
    await _api.delete(ApiEndpoints.notificationClearRead);
  }
}
