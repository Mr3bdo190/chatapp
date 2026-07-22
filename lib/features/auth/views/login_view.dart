import 'package:flutter/material.dart';
import 'package:firebase_auth/package:firebase_auth.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      CustomSnackbar.show(context: context, message: 'يرجى إدخال البريد وكلمة المرور', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final userCred = await AuthService().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (!mounted) return;
      
      // توجيه مبدئي للشاشة الرئيسية (المرحلة القادمة هنفصل التابات جوه الـ MainLayout حسب الرول)
      CustomSnackbar.show(context: context, message: 'مرحباً بعودتك!');
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      
    } on FirebaseAuthException catch (e) {
      CustomSnackbar.show(context: context, message: 'بيانات الدخول غير صحيحة', isError: true);
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.storefront, size: 80, color: AppConstants.primaryColor),
                    const SizedBox(height: 16),
                    Text('Mr Shop', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppConstants.primaryColor)),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text('تسجيل الدخول', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
              const SizedBox(height: 8),
              const Text('مرحباً بك مجدداً! يرجى إدخال بياناتك', style: TextStyle(color: AppConstants.textSecondary)),
              const SizedBox(height: 32),
              
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('تسجيل الدخول', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ليس لديك حساب؟ '),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
                    child: const Text('إنشاء حساب جديد', style: TextStyle(color: AppConstants.secondaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
