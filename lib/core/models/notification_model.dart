class NotificationModel {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final String? createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? json['message']?.toString() ?? '',
      isRead: json['is_read'] == true,
      createdAt: json['created_at']?.toString(),
    );
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
