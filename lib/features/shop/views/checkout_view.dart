import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('إتمام الطلب'),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // تنفيذ الطلب وتوليد رقم التتبع
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تأكيد الطلب بنجاح!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.secondaryColor,
              ),
              child: const Text(
                'تأكيد الطلب الآن',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'بيانات التوصيل',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
            ),
            const SizedBox(height: 20),
            _buildTextField(label: 'الاسم بالكامل', icon: Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'رقم الهاتف (الأساسي لتتبع طلبك)', 
              icon: Icons.phone_android_outlined, 
              keyboardType: TextInputType.phone
            ),
            const SizedBox(height: 16),
            _buildTextField(label: 'المحافظة / المدينة', icon: Icons.location_city_outlined),
            const SizedBox(height: 16),
            _buildTextField(label: 'العنوان بالتفصيل', icon: Icons.home_outlined, maxLines: 3),
            
            const SizedBox(height: 30),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppConstants.primaryColor.withOpacity(0.1)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: AppConstants.primaryColor),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'الدفع عند الاستلام. سيتم التواصل معك لتأكيد الطلب قبل الشحن.',
                      style: TextStyle(color: AppConstants.textPrimary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label, 
    required IconData icon, 
    TextInputType? keyboardType, 
    int maxLines = 1
  }) {
    return TextField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppConstants.textSecondary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.secondaryColor, width: 1.5),
        ),
      ),
    );
  }
}
