import 'user_model.dart';

class AuthResponseModel {
  final String access;
  final String? refresh;
  final UserModel user;
  final String? message;

  AuthResponseModel({
    required this.access,
    this.refresh,
    required this.user,
    this.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      access: json['access']?.toString() ?? '',
      refresh: json['refresh']?.toString(),
      user: json['user'] is Map<String, dynamic>
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : UserModel(id: 0, email: '', fullName: '', role: 'customer'),
      message: json['message']?.toString(),
    );
  }
}
