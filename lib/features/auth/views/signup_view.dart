import 'package:flutter/material.dart';
import 'package:firebase_auth/package:firebase_auth.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/routes/app_routes.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSignup() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      CustomSnackbar.show(context: context, message: 'يرجى ملء جميع الحقول', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await AuthService().signUp(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (!mounted) return;
      CustomSnackbar.show(context: context, message: 'تم إنشاء الحساب بنجاح!');
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'حدث خطأ في التسجيل';
      if (e.code == 'weak-password') errorMessage = 'كلمة المرور ضعيفة جداً';
      if (e.code == 'email-already-in-use') errorMessage = 'البريد الإلكتروني مسجل مسبقاً';
      CustomSnackbar.show(context: context, message: errorMessage, isError: true);
    } catch (e) {
      CustomSnackbar.show(context: context, message: 'حدث خطأ غير متوقع', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: AppConstants.primaryColor)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('إنشاء حساب جديد', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
            const SizedBox(height: 8),
            const Text('انضم إلينا الآن للتمتع بأفضل العروض', style: TextStyle(color: AppConstants.textSecondary)),
            const SizedBox(height: 32),
            
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'الاسم بالكامل', prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 16),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'رقم الهاتف', prefixIcon: const Icon(Icons.phone_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 16),
            TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 16),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: 'كلمة المرور', prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                style: ElevatedButton.styleFrom(backgroundColor: AppConstants.secondaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('تسجيل الحساب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
