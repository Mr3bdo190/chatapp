import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({Key? key}) : super(key: key);

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'إلكترونيات';
  final List<String> _categories = ['إلكترونيات', 'ملابس', 'عطور', 'ساعات', 'أحذية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('إضافة منتج جديد'),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // سيتم ربط الرفع بـ Firebase و Cloudinary هنا
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('جاري إضافة المنتج...')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
              ),
              child: const Text('حفظ ونشر المنتج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // مساحة رفع الصورة (مجهزة لـ Cloudinary)
              GestureDetector(
                onTap: () {
                  // سيتم تشغيل Image Picker هنا
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_upload_outlined, size: 50, color: AppConstants.secondaryColor),
                      SizedBox(height: 12),
                      Text('اضغط لرفع صورة المنتج', style: TextStyle(color: AppConstants.textSecondary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // حقول إدخال البيانات
              const Text('تفاصيل المنتج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
              const SizedBox(height: 16),
              
              _buildTextField(label: 'اسم المنتج', hint: 'مثال: ساعة ذكية X Pro'),
              const SizedBox(height: 16),
              
              _buildTextField(label: 'السعر (ج.م)', hint: 'مثال: 450', keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              
              // قائمة اختيار القسم (Dropdown)
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'القسم',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppConstants.secondaryColor, width: 1.5)),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              _buildTextField(label: 'وصف المنتج', hint: 'اكتب تفاصيل ومميزات المنتج هنا...', maxLines: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint, TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppConstants.secondaryColor, width: 1.5)),
      ),
    );
  }
}
