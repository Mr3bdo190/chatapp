import 'package:flutter/material.dart';
import 'package:firebase_auth/package:firebase_auth.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('لوحة تحكم الإدارة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'تسجيل خروج',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نظرة عامة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('الطلبات', '150', Icons.shopping_bag_outlined, Colors.blue)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('قيد الانتظار', '24', Icons.pending_actions, Colors.orange)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('المبيعات', '15,400 ج', Icons.attach_money, Colors.green)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('المنتجات', '45', Icons.inventory_2_outlined, Colors.purple)),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'التحكم السريع',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
            ),
            const SizedBox(height: 16),
            _buildActionTile(
              context,
              title: 'إدارة الطلبات',
              subtitle: 'مراجعة وتحديث حالات طلبات العملاء',
              icon: Icons.local_shipping_outlined,
              onTap: () => Navigator.pushNamed(context, AppRoutes.manageOrders),
            ),
            const SizedBox(height: 12),
            _buildActionTile(
              context,
              title: 'إدارة المنتجات',
              subtitle: 'إضافة، تعديل، أو حذف المنتجات والأقسام',
              icon: Icons.add_box_outlined,
              onTap: () => Navigator.pushNamed(context, AppRoutes.addProduct),
            ),
            const SizedBox(height: 12),
            _buildActionTile(
              context,
              title: 'إدارة المستخدمين (جديد)',
              subtitle: 'عرض بيانات العملاء ومشترياتهم السابقة',
              icon: Icons.people_outline,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.manageUsers);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: AppConstants.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppConstants.backgroundColor, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppConstants.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppConstants.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppConstants.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
