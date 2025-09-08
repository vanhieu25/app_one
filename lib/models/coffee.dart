class Coffee {
  final String name;
  final String imagePath;
  final String price;
  final String? size;
  final int? quantity;

  Coffee({
    required this.name,
    required this.imagePath,
    required this.price,
    this.size,
    this.quantity = 1,
  });

  Coffee copyWith({
    String? name,
    String? imagePath,
    String? price,
    String? size,
    int? quantity,
  }) {
    return Coffee(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }
}
