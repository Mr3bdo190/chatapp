import 'package:flutter/material.dart';
import '../../features/shop/views/main_layout.dart';
import '../../features/shop/views/product_details_view.dart';
import '../../features/shop/views/cart_view.dart';
import '../../features/shop/views/checkout_view.dart';
import '../../features/tracking/views/track_order_view.dart';
import '../../features/admin/views/admin_dashboard_view.dart';
import '../../features/admin/views/add_product_view.dart';
import '../../features/admin/views/manage_orders_view.dart';
import '../../features/admin/views/manage_users_view.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/signup_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/';
  static const String productDetails = '/product_details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String trackOrder = '/track_order';
  static const String admin = '/admin';
  static const String addProduct = '/add_product';
  static const String manageOrders = '/manage_orders';
  static const String manageUsers = '/manage_users';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupView());
      case home:
        return MaterialPageRoute(builder: (_) => const MainLayout());
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
        return MaterialPageRoute(builder: (_) => const AdminDashboardView());
      case addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductView());
      case manageOrders:
        return MaterialPageRoute(builder: (_) => const ManageOrdersView());
      case manageUsers:
        return MaterialPageRoute(builder: (_) => const ManageUsersView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginView());
    }
  }
}
