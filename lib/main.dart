import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

void main() async {
  // تهيئة النظام قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة فايربيز باستخدام الكود مباشرة لتجنب أخطاء البناء
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
