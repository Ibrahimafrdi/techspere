import 'package:cloud_firestore/cloud_firestore.dart';

class Addon {
  String? id;
  String? name;
  double? price;
  bool? isAvailable;

  Addon({
    this.id,
    this.name,
    this.price,
    this.isAvailable,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'isAvailable': isAvailable ?? true,
    };
  }

  factory Addon.fromJson(Map<String, dynamic> map, [id]) {
    return Addon(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      isAvailable: map['isAvailable'] ?? true,
    );
  }
}
