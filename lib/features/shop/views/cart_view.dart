import 'package:flutter/material.dart';
import '../../../core/services/cart_service.dart';
import 'checkout_view.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);
  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    final cart = CartService();
    return Scaffold(
      appBar: AppBar(title: const Text('سلة المشتريات 🛒')),
      body: cart.items.isEmpty
          ? const Center(child: Text('السلة فارغة!'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        leading: Image.network(item['imageUrl'], width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image)),
                        title: Text(item['name']),
                        subtitle: Text('${item['price']} ج.م'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => cart.removeFromCart(index));
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الإجمالي: ${cart.totalPrice} ج.م', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutView())),
                        child: const Text('إتمام الطلب'),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
