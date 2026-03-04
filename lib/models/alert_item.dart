// Data Models
import 'package:uuid/uuid.dart';

class AlertLocation {
  final double latitude;
  final double longitude;
  final String address;

  AlertLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude, 'address': address};
  }

  factory AlertLocation.fromJson(Map<String, dynamic> json) {
    return AlertLocation(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      address: json['address'] as String,
    );
  }
}

class AlertItem {
  final String id;
  final String imageUrl;
  final String name;
  final String age;
  final String height;
  final String contact;
  bool isMissing;
  final String description;
  final AlertLocation location;
  final DateTime createdAt;
  final DateTime updatedAt;

  AlertItem({
    String? id,
    required this.imageUrl,
    required this.name,
    required this.age,
    required this.height,
    required this.contact,
    required this.location,
    this.isMissing = true,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  }) : id = id ?? Uuid().v4();

  @override
  String toString() {
    return 'AlertItem(id: $id, imageUrl: $imageUrl,  name: $name, age: $age, duration: $isMissing, description: $description,createdAt: $createdAt,),';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'name': name,
      'age': age,
      'height': height,
      'contact': contact,
      'isMissing': isMissing,
      'description': description,
      'location': location.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AlertItem.fromJson(Map<String, dynamic> json) {
    return AlertItem(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      name: json['name'] as String,
      age: json['age'] as String,
      height: json['height'] as String,
      contact: json['contact'] as String,
      isMissing: json['isMissing'] ?? false,
      description: json['description'] as String,
      location: AlertLocation.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
