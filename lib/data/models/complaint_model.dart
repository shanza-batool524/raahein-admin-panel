import 'user_model.dart';

class ComplaintModel {
  final int id;
  final int userId;
  final int? rideId;
  final String subject;
  final String description;
  final String status;
  final DateTime? createdAt;
  final UserModel? user;

  ComplaintModel({
    required this.id,
    required this.userId,
    this.rideId,
    required this.subject,
    required this.description,
    required this.status,
    this.createdAt,
    this.user,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      rideId: json['rideId'],
      subject: json['subject'] ?? 'No Subject',
      description: json['description'] ?? 'No Description',
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
