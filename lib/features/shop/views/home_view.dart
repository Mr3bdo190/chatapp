import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. شريط التطبيق العلوي (App Bar)
            SliverAppBar(
              floating: true,
              backgroundColor: AppConstants.backgroundColor,
              elevation: 0,
              title: const Text(
                'Mr Shop',
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: AppConstants.primaryColor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: AppConstants.primaryColor),
                  onPressed: () {},
                ),
              ],
            ),

            // 2. البانر الإعلاني
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.secondaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'خصومات الشتاء تصل لـ 50%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 3. عنوان الأقسام
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'تصفح بالأقسام',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
              ),
            ),

            // 4. شريط الأقسام
            SliverToBoxAdapter(
              child: SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 6,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    List<String> categories = ['الكل', 'إلكترونيات', 'ملابس', 'عطور', 'ساعات', 'أحذية'];
                    bool isSelected = index == 0; 
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? AppConstants.primaryColor : AppConstants.cardColor,
                        borderRadius: BorderRadius.circular(25),
                        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
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
            ),

            // 5. عنوان أحدث المنتجات
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
                child: Text(
                  'أحدث المنتجات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
              ),
            ),

            // 6. شبكة المنتجات (مع إضافة زرار الانتقال)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // الانتقال لشاشة التفاصيل وإرسال رقم المنتج
                        Navigator.pushNamed(
                          context, 
                          AppRoutes.productDetails,
                          arguments: 'prod_${index + 1}',
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppConstants.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: const Center(
                                  child: Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'منتج تجريبي رقم ${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.textPrimary,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    '350.00 ج.م',
                                    style: TextStyle(
                                      color: AppConstants.secondaryColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: 8,
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}
