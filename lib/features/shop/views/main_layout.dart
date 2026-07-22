import 'package:flutter/material.dart';
import 'package:firebase_auth/package:firebase_auth.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/routes/app_routes.dart';
import 'home_view.dart';
import 'cart_view.dart';
import '../../tracking/views/track_order_view.dart';
import '../../admin/views/admin_dashboard_view.dart';
import '../../profile/views/profile_view.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final role = await AuthService().getUserRole(user.uid);
      if (mounted) {
        setState(() {
          _isAdmin = (role == 'admin');
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  List<Widget> get _pages => [
    const HomeView(),
    const Scaffold(body: Center(child: Text('الأقسام (قريباً)'))),
    const TrackOrderView(),
    const CartView(),
    _isAdmin ? const AdminDashboardView() : const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
      );
    }

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'الرئيسية'),
          const BottomNavigationBarItem(icon: Icon(Icons.grid_view), activeIcon: Icon(Icons.grid_view_rounded), label: 'الأقسام'),
          const BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), activeIcon: Icon(Icons.local_shipping), label: 'التتبع'),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'السلة'),
          BottomNavigationBarItem(
            icon: Icon(_isAdmin ? Icons.admin_panel_settings_outlined : Icons.person_outline), 
            activeIcon: Icon(_isAdmin ? Icons.admin_panel_settings : Icons.person), 
            label: _isAdmin ? 'الإدارة' : 'حسابي'
          ),
        ],
      ),
    );
  }
}
