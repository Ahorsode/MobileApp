class MenuItem {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final int stock;
  final String category; // Breakfast, Lunch, Snacks
  final double averageRating;
  final int ratingCount;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.stock,
    required this.category,
    this.averageRating = 0.0,
    this.ratingCount = 0,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map, String docId) {
    return MenuItem(
      id: docId,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? 'https://via.placeholder.com/150',
      stock: map['stock'] ?? 0,
      category: map['category'] ?? 'Lunch',
      averageRating: (map['averageRating'] ?? 0.0).toDouble(),
      ratingCount: map['ratingCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'stock': stock,
      'category': category,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
    };
  }
}
