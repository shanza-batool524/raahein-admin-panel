class RideModel {
  final int id;
  final String status;
  final bool isSuspicious;
  final String pickupLocation;
  final String dropoffLocation;
  final double? fare;
  final DateTime? createdAt;
  final List<dynamic>? bookings;

  RideModel({
    required this.id,
    required this.status,
    required this.isSuspicious,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.fare,
    this.createdAt,
    this.bookings,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? 'UNKNOWN',
      isSuspicious: json['isSuspicious'] ?? false,
      pickupLocation: json['pickupLocation'] ?? 'Unknown Pickup',
      dropoffLocation: json['dropoffLocation'] ?? 'Unknown Dropoff',
      fare: json['fare'] != null ? double.tryParse(json['fare'].toString()) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      bookings: json['bookings'],
    );
  }
}
