class SystemSettingsModel {
  final int id;
  final double baseFare;
  final double perKmRate;
  final double surgeMultiplier;
  final String? safetyMessage;
  final String? announcement;

  SystemSettingsModel({
    required this.id,
    this.baseFare = 0.0,
    this.perKmRate = 0.0,
    this.surgeMultiplier = 1.0,
    this.safetyMessage,
    this.announcement,
  });

  factory SystemSettingsModel.fromJson(Map<String, dynamic> json) {
    return SystemSettingsModel(
      id: json['id'] ?? 0,
      baseFare: json['baseFare'] != null ? double.tryParse(json['baseFare'].toString()) ?? 0.0 : 0.0,
      perKmRate: json['perKmRate'] != null ? double.tryParse(json['perKmRate'].toString()) ?? 0.0 : 0.0,
      surgeMultiplier: json['surgeMultiplier'] != null ? double.tryParse(json['surgeMultiplier'].toString()) ?? 1.0 : 1.0,
      safetyMessage: json['safetyMessage'],
      announcement: json['announcement'],
    );
  }
}
