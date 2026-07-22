import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddProductView extends StatefulWidget {
  const AdminAddProductView({Key? key}) : super(key: key);
  @override
  State<AdminAddProductView> createState() => _AdminAddProductViewState();
}

class _AdminAddProductViewState extends State<AdminAddProductView> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedCategory = 'إلكترونيات';
  bool _isLoading = false;

  final List<String> _categories = ['إلكترونيات', 'ملابس', 'أحذية', 'عطور', 'أخرى'];

  Future<void> _addProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'imageUrl': _imageUrlController.text.trim().isEmpty ? 'https://via.placeholder.com/150' : _imageUrlController.text.trim(),
        'category': _selectedCategory,
        'createdAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إضافة المنتج بنجاح!')));
      Navigator.pop(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج جديد 🛒')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'اسم المنتج')),
            const SizedBox(height: 12),
            TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'السعر')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
              decoration: const InputDecoration(labelText: 'القسم'),
            ),
            const SizedBox(height: 12),
            TextField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'رابط الصورة (اختياري)')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _addProduct,
              child: _isLoading ? const CircularProgressIndicator() : const Text('حفظ المنتج'),
            )
          ],
        ),
      ),
    );
  }
}
