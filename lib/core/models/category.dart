class Category {
  String? id;
  String? name;
  bool? isAvailable;

  Category({this.id, this.name, this.isAvailable});

  factory Category.fromJson(Map<String, dynamic> json, [id]) {
    return Category(
      id: id,
      name: json['name'],
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isAvailable': isAvailable ?? true,
    };
  }
}
