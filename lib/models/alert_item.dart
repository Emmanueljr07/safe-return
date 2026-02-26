// Data Models
import 'package:uuid/uuid.dart';

class AlertItem {
  final String id;
  final String imageUrl;
  final String name;
  final String age;
  final bool isMissing;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  AlertItem({
    String? id,
    required this.imageUrl,
    required this.name,
    required this.age,
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
      'isMissing': isMissing,
      'description': description,
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
      isMissing: json['isMissing'] ?? false,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
