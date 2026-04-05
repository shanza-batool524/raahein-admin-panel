import 'user_model.dart';

class DriverModel {
  final int id;
  final int userId;
  final String verificationStatus;
  final String? rejectionReason;
  final DriverDetails? details;
  final UserModel? user;
  final List<VehicleModel>? vehicles;

  DriverModel({
    required this.id,
    required this.userId,
    required this.verificationStatus,
    this.rejectionReason,
    this.details,
    this.user,
    this.vehicles,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      verificationStatus: json['verificationStatus'] ?? 'PENDING',
      rejectionReason: json['rejectionReason'],
      details: json['details'] != null ? DriverDetails.fromJson(json['details']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      vehicles: json['vehicles'] != null 
          ? List<VehicleModel>.from(json['vehicles'].map((x) => VehicleModel.fromJson(x)))
          : null,
    );
  }
}

class DriverDetails {
  final String? licenseNumber;
  final String? cnic;
  final String? cnicFrontImage;
  final String? cnicBackImage;
  final String? ltvLicenseImage;
  final String? selfieImage;
  
  DriverDetails({
    this.licenseNumber,
    this.cnic,
    this.cnicFrontImage,
    this.cnicBackImage,
    this.ltvLicenseImage,
    this.selfieImage,
  });

  factory DriverDetails.fromJson(Map<String, dynamic> json) {
    return DriverDetails(
      licenseNumber: json['licenseNumber'],
      cnic: json['cnic'],
      cnicFrontImage: json['cnicFrontImage'],
      cnicBackImage: json['cnicBackImage'],
      ltvLicenseImage: json['ltvLicenseImage'],
      selfieImage: json['selfieImage'],
    );
  }
}

class VehicleModel {
  final int id;
  final String make;
  final String model;
  final String year;
  final String registrationNumber;
  final String color;
  final String? vehicleFrontImage;
  final String? vehicleBackImage;
  final String? registrationBookImage;

  VehicleModel({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.color,
    this.vehicleFrontImage,
    this.vehicleBackImage,
    this.registrationBookImage,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] ?? 0,
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? '',
      registrationNumber: json['registrationNumber'] ?? '',
      color: json['color'] ?? '',
      vehicleFrontImage: json['vehicleFrontImage'],
      vehicleBackImage: json['vehicleBackImage'],
      registrationBookImage: json['registrationBookImage'],
    );
  }
}
