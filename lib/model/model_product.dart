class Product {
  String id;
  String product;
  String price;
  String description;
  String product_url;
  String sku;
  String category;
  String thumbnail;

  Product(
      {required this.id,
      required this.product,
      required this.price,
      required this.description,
      required this.product_url,
      required this.sku,
      required this.category,
      required this.thumbnail});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['_id'] ?? "",
        product: json['product'] ?? "",
        price: json['price'].toString() ?? "0",
        description: json['description'] ?? "",
        product_url: json['product_url'] ?? "",
        sku: json['sku'] ?? "",
        category: json['category'] ?? "",
        thumbnail: json['thumbnail'] ?? "");
  }
}
