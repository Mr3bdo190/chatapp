import 'package:flutter/material.dart';
import '../../features/shop/views/home_view.dart';

class AppRoutes {
  static const String home = '/';
  static const String trackOrder = '/track_order';
  static const String admin = '/admin';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case trackOrder:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('تتبع الطلب'))));
      case admin:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('لوحة الإدارة'))));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('الصفحة غير موجودة: ${settings.name}')),
          ),
        );
    }
  }
}
