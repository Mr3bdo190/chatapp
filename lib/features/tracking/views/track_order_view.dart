import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class TrackOrderView extends StatefulWidget {
  const TrackOrderView({Key? key}) : super(key: key);

  @override
  State<TrackOrderView> createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  bool _isTracking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('تتبع طلبك'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أدخل رقم الهاتف أو كود الطلب',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: '#ORD-12345 أو 01xxxxxxxxx',
                prefixIcon: const Icon(Icons.search, color: AppConstants.textSecondary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppConstants.secondaryColor, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // إظهار نتيجة وهمية مؤقتاً لحد الربط بـ Firebase
                  setState(() {
                    _isTracking = true; 
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                ),
                child: const Text('تتبع الآن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
            
            // ظهور مسار الطلب عند البحث
            if (_isTracking) _buildTrackingTimeline(),
          ],
        ),
      ),
    );
  }

  // ويدجت مسار الطلب (Timeline)
  Widget _buildTrackingTimeline() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Text(
              'طلب رقم: #ORD-98765', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppConstants.primaryColor)
            ),
            const SizedBox(height: 20),
            _buildStatusStep(title: 'تم استلام الطلب', subtitle: '15 يوليو 2026 - 10:00 ص', isCompleted: true, isLast: false),
            _buildStatusStep(title: 'جاري التجهيز', subtitle: '16 يوليو 2026 - 02:30 م', isCompleted: true, isLast: false),
            _buildStatusStep(title: 'في الطريق إليك', subtitle: 'المندوب استلم الشحنة وفي طريقه لك', isCompleted: false, isLast: false, isActive: true),
            _buildStatusStep(title: 'تم التسليم', subtitle: 'في انتظار الاستلام', isCompleted: false, isLast: true),
          ],
        ),
      ),
    );
  }

  // تصميم كل خطوة في المسار
  Widget _buildStatusStep({required String title, required String subtitle, required bool isCompleted, required bool isLast, bool isActive = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : (isActive ? AppConstants.secondaryColor : Colors.grey.shade300),
                shape: BoxShape.circle,
              ),
              child: isCompleted ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompleted || isActive ? AppConstants.textPrimary : AppConstants.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
