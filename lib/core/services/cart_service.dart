class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  List<Map<String, dynamic>> items = [];

  void addToCart(Map<String, dynamic> product) {
    items.add(product);
  }

  void removeFromCart(int index) {
    items.removeAt(index);
  }

  void clearCart() {
    items.clear();
  }

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + (double.tryParse(item['price'].toString()) ?? 0));
  }
}
