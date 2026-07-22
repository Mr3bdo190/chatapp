import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/cart_service.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'إلكترونيات', 'icon': Icons.computer, 'color': Colors.blue},
    {'name': 'ملابس', 'icon': Icons.checkroom, 'color': Colors.pink},
    {'name': 'أحذية', 'icon': Icons.snowshoeing, 'color': Colors.orange},
    {'name': 'عطور', 'icon': Icons.water_drop, 'color': Colors.purple},
    {'name': 'أخرى', 'icon': Icons.category, 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأقسام 🗂️'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final cat = _categories[index];
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProductsView(categoryName: cat['name'])));
              },
              borderRadius: BorderRadius.circular(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cat['icon'], size: 50, color: cat['color']),
                    const SizedBox(height: 12),
                    Text(cat['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryProductsView extends StatelessWidget {
  final String categoryName;
  const CategoryProductsView({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').where('category', isEqualTo: categoryName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('لا توجد منتجات في هذا القسم حالياً 🛒'));

          final products = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: Image.network(product['imageUrl'], fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image, size: 50))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('${product['price']} ج.م', style: const TextStyle(color: Colors.green)),
                          ElevatedButton(
                            onPressed: () {
                              CartService().addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت الإضافة للسلة')));
                            },
                            child: const Text('أضف للسلة'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
