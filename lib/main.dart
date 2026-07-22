import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // هنفعلها بعد إضافة ملف فايربيز
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

void main() async {
  // تهيئة النظام قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();
  
  // await Firebase.initializeApp(); // سيتم تفعيلها فور إضافة ملف google-services.json
  
  runApp(const AffiliateStoreApp());
}

class AffiliateStoreApp extends StatelessWidget {
  const AffiliateStoreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mr Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
