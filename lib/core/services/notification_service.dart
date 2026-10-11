import '../models/notification_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class NotificationService {
  final ApiClient _api = ApiClient.instance;

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _api.get(ApiEndpoints.notifications);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
