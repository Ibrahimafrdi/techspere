import 'package:delivery_app/core/models/addon.dart';
import 'package:delivery_app/core/models/variation.dart';

class Item {
  String? id;
  String? title;
  String? categoryId;
  double? price;
  bool? isAvailable;
  bool? isFeatured;
  String? description;
  String? caution;
  String? imageUrl;
  List<Variation>? variations;
  List<Addon>? addons;

  Item({
    this.id,
    this.title,
    this.categoryId,
    this.price,
    this.isAvailable,
    this.isFeatured,
    this.description,
    this.caution,
    this.imageUrl,
    this.variations,
    this.addons,
  });

  @override
  String toString() {
    return 'Item(id: $id, title: $title, price: $price, available: $isAvailable)';
  }


  factory Item.fromJson(Map<String, dynamic> json, [id]) {
    return Item(
      id: id,
      title: json['title'] as String?,
      categoryId: json['categoryId'] as String?,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'] as double?,
      isAvailable: json['isAvailable'] ?? true,
      isFeatured: json['isFeatured'] as bool?,
      description: json['description'] as String?,
      caution: json['caution'] as String?,
      imageUrl: json['imageUrl'] as String?,
      variations: (json['variations'] as List<dynamic>?)
          ?.map((e) => Variation.fromJson(e as Map<String, dynamic>))
          .toList(),
      addons: (json['addons'] as List<dynamic>?)
          ?.map((e) => Addon.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categoryId': categoryId,
      'price': price,
      'isAvailable': isAvailable ?? true,
      'isFeatured': isFeatured,
      'description': description,
      'caution': caution,
      'imageUrl': imageUrl,
      'variations': variations?.map((e) => e.toJson()).toList(),
      'addons': addons?.map((e) => e.toJson()).toList(),
    };
  }
}
