import 'package:delivery_app/core/models/items/item.dart';
import 'package:delivery_app/core/models/addon.dart';
import 'package:delivery_app/core/models/variation.dart';

class OrderItem {
  Item? item;
  int quantity;
  Map<String, List<String>>? selectedVariations = {};
  List<Addon>? selectedAddons = [];
  String? specialInstructions;


  OrderItem({
    this.item,
    this.quantity = 1,
    this.selectedVariations,
    this.selectedAddons,
    this.specialInstructions,
  });

  double get totalPrice {
    if (item == null) return 0;

    double basePrice = _calculateBasePrice();
    double variationsPrice = _calculateVariationsPrice();
    double addonsPrice = _calculateAddonsPrice();

    return (basePrice + variationsPrice) * quantity + addonsPrice;
  }

  double _calculateBasePrice() {
    if (item?.variations == null ||
        !item!.variations!.any((v) => v.isPrimary == true)) {
      return item?.price ?? 0;
    }

    var primaryVariation =
        item!.variations!.firstWhere((v) => v.isPrimary == true);
    var selectedOption = selectedVariations?[primaryVariation.name!]?.first;

    if (selectedOption == null) return item?.price ?? 0;

    return primaryVariation.options
            ?.firstWhere((o) => o.name == selectedOption,
                orElse: () => VariationOption(price: item?.price ?? 0))
            .price ??
        item?.price ??
        0;
  }

  double _calculateVariationsPrice() {
    if (selectedVariations == null || item?.variations == null) return 0;

    return selectedVariations!.entries.where((entry) {
      var variation = item!.variations!
          .firstWhere((v) => v.name == entry.key, orElse: () => Variation());
      return !variation.isPrimary!;
    }).map((entry) {
      var variation = item!.variations!.firstWhere((v) => v.name == entry.key);
      return entry.value.map((optionName) {
        return variation.options
                ?.firstWhere((o) => o.name == optionName,
                    orElse: () => VariationOption(price: 0))
                .price ??
            0;
      }).fold<double>(0, (sum, price) => sum + price);
    }).fold<double>(0, (sum, price) => sum + price);
  }

  double _calculateAddonsPrice() {
    return selectedAddons?.fold<double>(
            0, (sum, addon) => sum + addon.price!) ??
        0;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> convertedVariations = {};
    if (json['selectedVariations'] != null) {
      (json['selectedVariations'] as Map<String, dynamic>)
          .forEach((key, value) {
        if (value is List) {
          convertedVariations[key] = value.map((e) => e.toString()).toList();
        }
      });
    }

    List<Addon> convertedAddons = [];
    if (json['selectedAddons'] != null) {
      final addonsList = json['selectedAddons'] as List<dynamic>;
      convertedAddons = addonsList.map((addonJson) {
        return addonJson is Map<String, dynamic>
            ? Addon.fromJson(addonJson)
            : Addon();
      }).toList();
    }

    return OrderItem(
      item: json['item'] != null
          ? Item.fromJson(json['item'], json['item']['id'])
          : null,
      quantity: json['quantity'] ?? 1,
      selectedVariations: convertedVariations,
      selectedAddons: convertedAddons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item?.toJson(),
      'quantity': quantity,
      'selectedVariations': selectedVariations,
      'selectedAddons': selectedAddons?.map((e) => e.toJson()).toList(),
    };
  }
}
