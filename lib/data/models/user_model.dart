class UserModel {
  final int id;
  final String? phone;
  final String? role;
  final String? status;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    this.phone,
    this.role,
    this.status,
    this.firstName,
    this.lastName,
    this.email,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      phone: json['phone'],
      role: json['role'],
      status: json['status'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
