class Variation {
  String? name;
  bool? isPrimary;
  bool? isRequired;
  bool? isSingleSelection;
  List<VariationOption>? options;

  Variation({
    this.name,
    this.options,
    this.isPrimary,
    this.isRequired,
    this.isSingleSelection,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      name: json['name'],
      isRequired: json['isRequired'] ?? false,
      isPrimary: json['isPrimary'] ?? false,
      isSingleSelection: json['isSingleSelection'] ?? true,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => VariationOption.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isRequired': isRequired ?? false,
      'isPrimary': isPrimary ?? false,
      'isSingleSelection': isSingleSelection ?? true,
      'options': options?.map((e) => e.toJson()).toList(),
    };
  }
}

class VariationOption {
  String? name;
  double? price;

  VariationOption({this.name, this.price});

  factory VariationOption.fromJson(Map<String, dynamic> json) {
    return VariationOption(
      name: json['name'],
      price: json['price']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}
