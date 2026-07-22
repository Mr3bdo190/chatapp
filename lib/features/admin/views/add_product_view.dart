import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({Key? key}) : super(key: key);

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
  String _selectedCategory = 'إلكترونيات';
  final List<String> _categories = ['إلكترونيات', 'ملابس', 'عطور', 'ساعات', 'أحذية'];
  
  bool _isLoading = false;
  bool _isUploadingImage = false;
  
  File? _imageFile;
  String? _uploadedImageUrl;

  // تم تصحيح اسم السحابة بناءً على مراجعتك يا رياسة
  final String cloudName = 'dtrtgbtss'; 
  final String uploadPreset = 'Memory'; 

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isUploadingImage = true;
      });

      try {
        final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
        final request = http.MultipartRequest('POST', uri);
        
        request.fields['upload_preset'] = uploadPreset;
        request.files.add(await http.MultipartFile.fromPath('file', pickedFile.path));

        final response = await request.send();
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);

        if (response.statusCode == 200) {
          setState(() {
            _uploadedImageUrl = jsonMap['secure_url'];
            _isUploadingImage = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم رفع الصورة بنجاح!'), backgroundColor: Colors.green),
            );
          }
        } else {
          String errorMsg = jsonMap['error']['message'] ?? 'فشل الرفع';
          if (errorMsg.contains('Unknown API key')) {
            throw Exception('تأكد من مطابقة اسم السحابة واسم الـ Preset وأنه Unsigned في Cloudinary');
          } else {
            throw Exception(errorMsg);
          }
        }
      } catch (e) {
        setState(() {
          _imageFile = null;
          _isUploadingImage = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _saveProductToFirebase() async {
    if (_formKey.currentState!.validate()) {
      if (_uploadedImageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى رفع صورة للمنتج أولاً'), backgroundColor: Colors.orange),
        );
        return;
      }

      setState(() => _isLoading = true);
      
      try {
        await FirebaseFirestore.instance.collection('products').add({
          'name': _nameController.text.trim(),
          'price': double.parse(_priceController.text.trim()),
          'category': _selectedCategory,
          'description': _descController.text.trim(),
          'image': _uploadedImageUrl,
          'rating': '5.0', 
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إضافة المنتج بنجاح!'), backgroundColor: Colors.green),
          );
          _nameController.clear();
          _priceController.clear();
          _descController.clear();
          setState(() {
            _selectedCategory = 'إلكترونيات';
            _imageFile = null;
            _uploadedImageUrl = null;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(title: const Text('إضافة منتج جديد')),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveProductToFirebase,
              style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryColor),
              child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('حفظ ونشر المنتج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              GestureDetector(
                onTap: _isUploadingImage ? null : _pickAndUploadImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                    image: _imageFile != null
                        ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _isUploadingImage
                      ? const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor))
                      : _imageFile == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.cloud_upload_outlined, size: 50, color: AppConstants.secondaryColor),
                                SizedBox(height: 12),
                                Text('اضغط لرفع صورة المنتج', style: TextStyle(color: AppConstants.textSecondary)),
                              ],
                            )
                          : const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 24),
              const Text('تفاصيل المنتج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
              const SizedBox(height: 16),
              _buildTextField(label: 'اسم المنتج', hint: 'مثال: ساعة ذكية X Pro', controller: _nameController),
              const SizedBox(height: 16),
              _buildTextField(label: 'السعر (ج.م)', hint: 'مثال: 450', keyboardType: TextInputType.number, controller: _priceController),
              const SizedBox(height: 16),
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
                onChanged: (String? newValue) => setState(() => _selectedCategory = newValue!),
              ),
              const SizedBox(height: 16),
              _buildTextField(label: 'وصف المنتج', hint: 'اكتب تفاصيل ومميزات المنتج هنا...', maxLines: 4, controller: _descController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint, required TextEditingController controller, TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
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
