class Favorites {
  String? userId;
  List<String>? itemIds;

  Favorites({this.userId, this.itemIds});

  factory Favorites.fromJson(Map<String, dynamic> json) {
    return Favorites(
      userId: json['userId'],
      itemIds: List<String>.from(json['itemIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'itemIds': itemIds,
    };
  }
}
