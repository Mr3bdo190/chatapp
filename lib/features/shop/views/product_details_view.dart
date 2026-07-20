import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class ProductDetailsView extends StatelessWidget {
  final String? productId; // هنستقبله بعدين لما نربط بـ Firebase

  const ProductDetailsView({Key? key, this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      // زرار الطلب الثابت في أسفل الشاشة
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // سيتم برمجة إضافة للسلة أو الطلب المباشر
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'اطلب الآن',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add_shopping_cart, color: AppConstants.primaryColor),
                  onPressed: () {
                    // إضافة للسلة
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. صورة المنتج بخاصية الـ Slivers
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: AppConstants.backgroundColor,
            iconTheme: const IconThemeData(color: AppConstants.primaryColor),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(Icons.image_outlined, size: 100, color: Colors.grey),
                ),
              ),
            ),
          ),

          // 2. تفاصيل المنتج
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: AppConstants.backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنتج والسعر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text(
                          'اسم المنتج التجريبي هنا',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '350.00 ج.م',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppConstants.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // التقييم (وهمي حالياً)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      const Text(
                        '4.8 (120 تقييم)',
                        style: TextStyle(
                          color: AppConstants.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // وصف المنتج
                  const Text(
                    'وصف المنتج',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40), // مسافة فارغة أسفل الوصف
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
