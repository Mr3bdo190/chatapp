import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // داتا المنتجات مطابقة للصورة لتوضيح التصميم
    final List<Map<String, String>> products = [
      {
        'name': 'Apple iPhone 13\n(سعة 128 جيجابايت)',
        'price': '350.00 ج.م',
        'rating': '4.5',
        'image': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=500' // صورة موبايل
      },
      {
        'name': 'Samsung Galaxy Watch 5\n',
        'price': '350.00 ج.م',
        'rating': '4.7',
        'image': 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?q=80&w=500' // صورة ساعة
      },
      {
        'name': 'حقيبة ظهر كلاسيكية\nمقاومة للماء',
        'price': '250.00 ج.م',
        'rating': '4.2',
        'image': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=500' // صورة حقيبة
      },
      {
        'name': 'عطر ديور سوفاج\n(للرجال)',
        'price': '1200.00 ج.م',
        'rating': '4.9',
        'image': 'https://images.unsplash.com/photo-1594034181428-4e0d0e53c083?q=80&w=500' // صورة عطر
      },
    ];

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.storefront, color: AppConstants.primaryColor, size: 28),
            SizedBox(width: 8),
            Text('Mr Shop', style: TextStyle(color: AppConstants.primaryColor, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: AppConstants.primaryColor), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: AppConstants.primaryColor), onPressed: () => Navigator.pushNamed(context, AppRoutes.cart)),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. البانر الإعلاني
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: const NetworkImage('https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=2070'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                  ),
                ),
                child: const Center(
                  child: Text('خصومات الشتاء تصل لـ 50%', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            // 2. عنوان الأقسام
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('تصفح بالأقسام', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
            ),

            // 3. شريط الأقسام (تصميم الـ Chips)
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  List<String> categories = ['الكل', 'إلكترونيات', 'ملابس', 'عطور', 'ساعات'];
                  bool isSelected = index == 0;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: isSelected ? AppConstants.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: isSelected ? AppConstants.primaryColor : Colors.grey.shade300),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppConstants.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),

            // 4. عنوان المنتجات
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 16.0),
              child: Text('أحدث المنتجات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
            ),

            // 5. شبكة المنتجات (مطابقة للصورة)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.62, // تم ضبطه لاحتواء الصورة والنصوص بوضوح
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: 'prod_${index + 1}'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(product['image']!, fit: BoxFit.cover, width: double.infinity),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.textPrimary, fontSize: 13),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product['price']!,
                                      style: const TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.w900, fontSize: 14),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 14),
                                        const SizedBox(width: 2),
                                        Text(product['rating']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
