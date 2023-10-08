class Product {
  final String? id;
  final String name;
  final String description;
  final String? imageUrl; // Cambio: URL de la imagen es opcional
  final double price;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl, // Cambio: URL de la imagen es opcional
  });
}
