class SupportTicketModel {
  final int id;
  final String subject;
  final String message;
  final String? category;
  final String status;
  final String? createdAt;

  SupportTicketModel({
    required this.id,
    required this.subject,
    required this.message,
    this.category,
    this.status = 'open',
    this.createdAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      subject: json['subject']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      category: json['category']?.toString(),
      status: json['status']?.toString() ?? 'open',
      createdAt: json['created_at']?.toString(),
    );
  }
}
