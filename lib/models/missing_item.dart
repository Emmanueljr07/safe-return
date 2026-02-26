class MissingItem {
  final String? id;
  final String message;
  final String? imagePath;
  final double? latitude;
  final double? longitude;
  final String? address;
  final DateTime createdAt;

  MissingItem({
    this.id,
    required this.message,
    this.imagePath,
    this.latitude,
    this.longitude,
    this.address,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'image_path': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MissingItem.fromJson(Map<String, dynamic> json) {
    return MissingItem(
      id: json['id'],
      message: json['message'],
      imagePath: json['image_path'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
