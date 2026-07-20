import 'package:flutter/material.dart';
import '../../features/shop/views/home_view.dart';
import '../../features/shop/views/product_details_view.dart';
import '../../features/shop/views/cart_view.dart';
import '../../features/shop/views/checkout_view.dart';
import '../../features/tracking/views/track_order_view.dart';

class AppRoutes {
  static const String home = '/';
  static const String productDetails = '/product_details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String trackOrder = '/track_order';
  static const String admin = '/admin';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case productDetails:
        final args = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => ProductDetailsView(productId: args));
      case cart:
        return MaterialPageRoute(builder: (_) => const CartView());
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutView());
      case trackOrder:
        return MaterialPageRoute(builder: (_) => const TrackOrderView());
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
