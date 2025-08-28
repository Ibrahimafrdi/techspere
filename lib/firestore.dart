import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedFirestore() async {
  final firestore = FirebaseFirestore.instance;

  // Categories (Electronics)
  final categories = [
    {"id": "laptops", "name": "Laptops"},
    {"id": "smartphones", "name": "Smartphones"},
    {"id": "tablets", "name": "Tablets"},
    {"id": "accessories", "name": "Accessories"},
  ];

  // Foods collection (but we’ll store electronics items here)
  final foods = {
    "laptops": [
      {"name": "Dell XPS 13", "price": 150000},
      {"name": "MacBook Air M2", "price": 220000},
    ],
    "smartphones": [
      {"name": "iPhone 14 Pro", "price": 280000},
      {"name": "Samsung Galaxy S23", "price": 250000},
    ],
    "tablets": [
      {"name": "iPad Pro 11\"", "price": 200000},
      {"name": "Samsung Galaxy Tab S8", "price": 150000},
    ],
    "accessories": [
      {"name": "Sony WH-1000XM5 Headphones", "price": 85000},
      {"name": "Anker Power Bank 20000mAh", "price": 12000},
    ],
  };

  for (var cat in categories) {
    await firestore.collection("categories").doc(cat["id"]).set({
      "name": cat["name"],
      "enabled": true,
    });

    for (var item in foods[cat["id"]]!) {
      await firestore.collection("foods").add({
        ...item,
        "categoryId": cat["id"],
      });
    }
  }

  print("✅ Firestore seeded successfully with /categories + /foods (admin panel compatible)!");
}
