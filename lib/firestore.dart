import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedFirestore() async {
  final firestore = FirebaseFirestore.instance;

  // Categories
  final categories = [
    {"id": "laptops", "name": "Laptops"},
    {"id": "smartphones", "name": "Smartphones"},
    {"id": "tablets", "name": "Tablets"},
    {"id": "accessories", "name": "Accessories"},
  ];

  // Enhanced items with all Item model properties
  final items = {
    "laptops": [
      {
        "title": "Dell XPS 13",
        "price": 150000.0,
        "isAvailable": true,
        "isFeatured": true,
        "description": "Ultra-portable laptop with stunning InfinityEdge display and premium build quality. Perfect for professionals and students.",
        "caution": "Keep away from extreme temperatures. Handle with care.",
        "imageUrl": "https://example.com/dell-xps-13.jpg",
        "technicalSpecs": {
          "Processor": "Intel Core i7-1250U",
          "RAM": "16GB LPDDR5",
          "Storage": "512GB SSD",
          "Display": "13.4-inch FHD+ Touch",
          "Graphics": "Intel Iris Xe",
          "Weight": "1.24 kg",
          "Battery": "Up to 12 hours",
          "OS": "Windows 11 Home"
        },
        "variations": [
          {
            "id": "dell-xps-i5",
            "title": "Intel i5 Variant",
            "price": 130000.0,
            "specs": {"Processor": "Intel Core i5-1235U", "RAM": "8GB"}
          },
          {
            "id": "dell-xps-i7",
            "title": "Intel i7 Variant",
            "price": 150000.0,
            "specs": {"Processor": "Intel Core i7-1250U", "RAM": "16GB"}
          }
        ],
        "addons": [
          {
            "id": "dell-mouse",
            "title": "Wireless Mouse",
            "price": 3000.0,
            "description": "Dell Premium Wireless Mouse"
          },
          {
            "id": "dell-bag",
            "title": "Laptop Bag",
            "price": 5000.0,
            "description": "Premium Dell Laptop Bag"
          }
        ]
      },
      {
        "title": "MacBook Air M2",
        "price": 220000.0,
        "isAvailable": true,
        "isFeatured": true,
        "description": "Revolutionary MacBook Air with Apple M2 chip delivers incredible performance and all-day battery life.",
        "caution": "Use only genuine Apple chargers. Avoid exposure to liquids.",
        "imageUrl": "https://example.com/macbook-air-m2.jpg",
        "technicalSpecs": {
          "Processor": "Apple M2 8-core CPU",
          "RAM": "8GB Unified Memory",
          "Storage": "256GB SSD",
          "Display": "13.6-inch Liquid Retina",
          "Graphics": "8-core GPU",
          "Weight": "1.24 kg",
          "Battery": "Up to 18 hours",
          "OS": "macOS Ventura"
        },
        "variations": [
          {
            "id": "macbook-8gb",
            "title": "8GB RAM / 256GB",
            "price": 220000.0,
            "specs": {"RAM": "8GB", "Storage": "256GB"}
          },
          {
            "id": "macbook-16gb",
            "title": "16GB RAM / 512GB",
            "price": 280000.0,
            "specs": {"RAM": "16GB", "Storage": "512GB"}
          }
        ],
        "addons": [
          {
            "id": "magic-mouse",
            "title": "Magic Mouse",
            "price": 15000.0,
            "description": "Apple Magic Mouse 2"
          },
          {
            "id": "usb-c-hub",
            "title": "USB-C Hub",
            "price": 8000.0,
            "description": "7-in-1 USB-C Hub"
          }
        ]
      }
    ],
    "smartphones": [
      {
        "title": "iPhone 14 Pro",
        "price": 280000.0,
        "isAvailable": true,
        "isFeatured": true,
        "description": "The most advanced iPhone yet with Dynamic Island, 48MP main camera, and A16 Bionic chip.",
        "caution": "Use screen protector to prevent scratches. Avoid dropping on hard surfaces.",
        "imageUrl": "https://example.com/iphone-14-pro.jpg",
        "technicalSpecs": {
          "Processor": "A16 Bionic chip",
          "RAM": "6GB",
          "Storage": "128GB",
          "Display": "6.1-inch Super Retina XDR",
          "Camera": "48MP Main + 12MP Ultra Wide",
          "Battery": "Up to 23 hours video",
          "OS": "iOS 16",
          "5G": "Yes"
        },
        "variations": [
          {
            "id": "iphone-128gb",
            "title": "128GB",
            "price": 280000.0,
            "specs": {"Storage": "128GB"}
          },
          {
            "id": "iphone-256gb",
            "title": "256GB",
            "price": 320000.0,
            "specs": {"Storage": "256GB"}
          },
          {
            "id": "iphone-512gb",
            "title": "512GB",
            "price": 380000.0,
            "specs": {"Storage": "512GB"}
          }
        ],
        "addons": [
          {
            "id": "iphone-case",
            "title": "Silicone Case",
            "price": 5000.0,
            "description": "Apple iPhone 14 Pro Silicone Case"
          },
          {
            "id": "lightning-cable",
            "title": "Lightning Cable",
            "price": 3000.0,
            "description": "Apple Lightning to USB-C Cable (1m)"
          }
        ]
      },
      {
        "title": "Samsung Galaxy S23",
        "price": 250000.0,
        "isAvailable": true,
        "isFeatured": false,
        "description": "Premium Android flagship with exceptional camera system and stunning display technology.",
        "caution": "Keep device dry. Use original Samsung charger for optimal performance.",
        "imageUrl": "https://example.com/samsung-s23.jpg",
        "technicalSpecs": {
          "Processor": "Snapdragon 8 Gen 2",
          "RAM": "8GB",
          "Storage": "256GB",
          "Display": "6.1-inch Dynamic AMOLED 2X",
          "Camera": "50MP Main + 12MP Ultra Wide",
          "Battery": "3900mAh",
          "OS": "Android 13",
          "5G": "Yes"
        },
        "variations": [
          {
            "id": "s23-256gb",
            "title": "256GB",
            "price": 250000.0,
            "specs": {"Storage": "256GB"}
          },
          {
            "id": "s23-512gb",
            "title": "512GB",
            "price": 290000.0,
            "specs": {"Storage": "512GB"}
          }
        ],
        "addons": [
          {
            "id": "samsung-case",
            "title": "Clear Case",
            "price": 4000.0,
            "description": "Samsung Galaxy S23 Clear Case"
          },
          {
            "id": "wireless-charger",
            "title": "Wireless Charger",
            "price": 6000.0,
            "description": "Samsung 15W Wireless Charger"
          }
        ]
      }
    ],
    "tablets": [
      {
        "title": "iPad Pro 11\"",
        "price": 200000.0,
        "isAvailable": true,
        "isFeatured": true,
        "description": "The most advanced iPad Pro ever with M2 chip, Liquid Retina display, and Apple Pencil support.",
        "caution": "Handle screen with care. Use Apple Pencil only with compatible tips.",
        "imageUrl": "https://example.com/ipad-pro-11.jpg",
        "technicalSpecs": {
          "Processor": "Apple M2 8-core CPU",
          "RAM": "8GB",
          "Storage": "128GB",
          "Display": "11-inch Liquid Retina",
          "Camera": "12MP Wide + 10MP Ultra Wide",
          "Battery": "Up to 10 hours",
          "OS": "iPadOS 16",
          "Connectivity": "Wi-Fi 6E"
        },
        "variations": [
          {
            "id": "ipad-128gb",
            "title": "128GB Wi-Fi",
            "price": 200000.0,
            "specs": {"Storage": "128GB", "Connectivity": "Wi-Fi"}
          },
          {
            "id": "ipad-256gb",
            "title": "256GB Wi-Fi",
            "price": 240000.0,
            "specs": {"Storage": "256GB", "Connectivity": "Wi-Fi"}
          },
          {
            "id": "ipad-cellular",
            "title": "128GB Wi-Fi + Cellular",
            "price": 250000.0,
            "specs": {"Storage": "128GB", "Connectivity": "Wi-Fi + Cellular"}
          }
        ],
        "addons": [
          {
            "id": "apple-pencil",
            "title": "Apple Pencil (2nd Gen)",
            "price": 25000.0,
            "description": "Apple Pencil for iPad Pro"
          },
          {
            "id": "magic-keyboard",
            "title": "Magic Keyboard",
            "price": 35000.0,
            "description": "Magic Keyboard for iPad Pro 11-inch"
          }
        ]
      },
      {
        "title": "Samsung Galaxy Tab S8",
        "price": 150000.0,
        "isAvailable": true,
        "isFeatured": false,
        "description": "Premium Android tablet with S Pen included and desktop-like productivity features.",
        "caution": "S Pen is small - store safely when not in use. Avoid extreme temperatures.",
        "imageUrl": "https://example.com/galaxy-tab-s8.jpg",
        "technicalSpecs": {
          "Processor": "Snapdragon 8 Gen 1",
          "RAM": "8GB",
          "Storage": "128GB",
          "Display": "11-inch TFT LCD",
          "Camera": "13MP Rear + 12MP Front",
          "Battery": "8000mAh",
          "OS": "Android 12",
          "Connectivity": "Wi-Fi 6E"
        },
        "variations": [
          {
            "id": "tab-s8-128gb",
            "title": "128GB",
            "price": 150000.0,
            "specs": {"Storage": "128GB"}
          },
          {
            "id": "tab-s8-256gb",
            "title": "256GB",
            "price": 180000.0,
            "specs": {"Storage": "256GB"}
          }
        ],
        "addons": [
          {
            "id": "s-pen-tips",
            "title": "S Pen Replacement Tips",
            "price": 2000.0,
            "description": "Set of 3 S Pen replacement tips"
          },
          {
            "id": "tab-keyboard",
            "title": "Book Cover Keyboard",
            "price": 18000.0,
            "description": "Samsung Galaxy Tab S8 Book Cover Keyboard"
          }
        ]
      }
    ],
    "accessories": [
      {
        "title": "Sony WH-1000XM5 Headphones",
        "price": 85000.0,
        "isAvailable": true,
        "isFeatured": true,
        "description": "Industry-leading noise canceling headphones with exceptional sound quality and 30-hour battery life.",
        "caution": "Clean ear cups regularly. Avoid excessive volume levels to protect hearing.",
        "imageUrl": "https://example.com/sony-wh1000xm5.jpg",
        "technicalSpecs": {
          "Type": "Over-ear wireless",
          "Driver": "30mm",
          "Frequency Response": "4Hz-40kHz",
          "Battery Life": "30 hours",
          "Charging": "USB-C Quick Charge",
          "Connectivity": "Bluetooth 5.2",
          "Weight": "250g",
          "Noise Canceling": "Yes"
        },
        "variations": [
          {
            "id": "sony-black",
            "title": "Midnight Black",
            "price": 85000.0,
            "specs": {"Color": "Midnight Black"}
          },
          {
            "id": "sony-silver",
            "title": "Platinum Silver",
            "price": 85000.0,
            "specs": {"Color": "Platinum Silver"}
          }
        ],
        "addons": [
          {
            "id": "carrying-case",
            "title": "Premium Carrying Case",
            "price": 8000.0,
            "description": "Sony Premium Headphone Carrying Case"
          },
          {
            "id": "audio-cable",
            "title": "3.5mm Audio Cable",
            "price": 2000.0,
            "description": "High-quality 1.2m audio cable"
          }
        ]
      },
      {
        "title": "Anker Power Bank 20000mAh",
        "price": 12000.0,
        "isAvailable": true,
        "isFeatured": false,
        "description": "High-capacity portable charger with PowerIQ technology for fast charging multiple devices.",
        "caution": "Do not expose to water or extreme heat. Charge fully before first use.",
        "imageUrl": "https://example.com/anker-powerbank.jpg",
        "technicalSpecs": {
          "Capacity": "20000mAh",
          "Input": "USB-C 18W",
          "Output": "2x USB-A + 1x USB-C",
          "Fast Charging": "PowerIQ 3.0",
          "Weight": "490g",
          "Dimensions": "158 x 74 x 19mm",
          "Safety": "MultiProtect System",
          "LED Indicator": "Yes"
        },
        "variations": [
          {
            "id": "anker-20000",
            "title": "20000mAh",
            "price": 12000.0,
            "specs": {"Capacity": "20000mAh"}
          },
          {
            "id": "anker-26800",
            "title": "26800mAh",
            "price": 15000.0,
            "specs": {"Capacity": "26800mAh"}
          }
        ],
        "addons": [
          {
            "id": "usb-c-cable",
            "title": "USB-C Cable",
            "price": 1500.0,
            "description": "Anker USB-C to USB-C Cable (1m)"
          },
          {
            "id": "travel-pouch",
            "title": "Travel Pouch",
            "price": 2000.0,
            "description": "Compact travel pouch for power bank"
          }
        ]
      },
      {
        "title": "Apple AirPods Pro (2nd Gen)",
        "price": 55000.0,
        "isAvailable": true,
        "isFeatured": true,
        "description": "Advanced wireless earbuds with Active Noise Cancellation and Spatial Audio for immersive listening.",
        "caution": "Clean regularly with dry cloth. Store in charging case when not in use.",
        "imageUrl": "https://example.com/airpods-pro-2.jpg",
        "technicalSpecs": {
          "Type": "In-ear wireless",
          "Chip": "Apple H2",
          "Battery": "6 hours + 24 hours with case",
          "Charging": "Lightning + MagSafe + Qi",
          "Water Resistance": "IPX4",
          "Connectivity": "Bluetooth 5.3",
          "Features": "ANC, Transparency Mode",
          "Touch Controls": "Yes"
        },
        "variations": [
          {
            "id": "airpods-pro-white",
            "title": "White",
            "price": 55000.0,
            "specs": {"Color": "White"}
          }
        ],
        "addons": [
          {
            "id": "airpods-case",
            "title": "Silicone Case",
            "price": 3000.0,
            "description": "Apple AirPods Pro Silicone Case"
          },
          {
            "id": "ear-tips",
            "title": "Replacement Ear Tips",
            "price": 2500.0,
            "description": "Set of replacement silicone ear tips"
          }
        ]
      }
    ]
  };

  try {
    
    print("🔥 Starting Firestore seeding...");
    // Clear existing data (optional - remove if you want to keep existing data)
    print("🧹 Clearing existing data...");
    
    // Delete existing items
    final existingItems = await firestore.collection("foods").get();
    for (var doc in existingItems.docs) {
      await doc.reference.delete();
    }
    
    // Delete existing categories
    final existingCategories = await firestore.collection("categories").get();
    for (var doc in existingCategories.docs) {
      await doc.reference.delete();
    }

    // Seed categories
    print("📁 Seeding categories...");
    for (var category in categories) {
      await firestore.collection("categories").doc(category["id"]).set({
        "name": category["name"],
        "enabled": true,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
      print("✓ Added category: ${category["name"]}");
    }

    // Seed items
    print("📦 Seeding items...");
    int totalItems = 0;
    
    for (var categoryEntry in items.entries) {
      final categoryId = categoryEntry.key;
      final categoryItems = categoryEntry.value;

      for (var item in categoryItems) {
        // Prepare the item data
        Map<String, dynamic> itemData = {
          "title": item["title"],
          "categoryId": categoryId,
          "price": item["price"],
          "isAvailable": item["isAvailable"] ?? true,
          "isFeatured": item["isFeatured"] ?? false,
          "description": item["description"],
          "caution": item["caution"],
          "imageUrl": item["imageUrl"],
          "technicalSpecs": item["technicalSpecs"] ?? {},
          "variations": item["variations"] ?? [],
          "addons": item["addons"] ?? [],
          "createdAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
        };

        // Add to Firestore
        await firestore.collection("items").add(itemData);
        totalItems++;
        print("✓ Added item: ${item["title"]}");
      }
    }

    print("🎉 Firestore seeding completed successfully!");
    print("📊 Summary:");
    print("   • Categories: ${categories.length}");
    print("   • Items: $totalItems");
    print("   • Collections: categories, foods");
    
  } catch (e) {
    print("❌ Error during seeding: $e");
    rethrow;
  }
}

// Helper function to call from your app
Future<void> initializeFirebaseData() async {
  try {
    await seedFirestore();
    print("🚀 Firebase initialization completed!");
  } catch (e) {
    print("💥 Failed to initialize Firebase data: $e");
  }
}