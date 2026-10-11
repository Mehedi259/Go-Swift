import '../models/support_ticket_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class SupportService {
  final ApiClient _api = ApiClient.instance;

  Future<SupportTicketModel> submitTicket({
    required String subject,
    required String message,
    String? category,
  }) async {
    final response = await _api.post(
      ApiEndpoints.supportTicketsSubmit,
      body: {
        'subject': subject,
        'message': message,
        if (category != null) 'category': category,
      },
    );
    return SupportTicketModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<SupportTicketModel>> getMyTickets() async {
    final response = await _api.get(ApiEndpoints.mySupportTickets);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => SupportTicketModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
