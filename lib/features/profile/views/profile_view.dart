import 'package:flutter/material.dart';
import 'package:firebase_auth/package:firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('يرجى تسجيل الدخول'));
    }

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('حسابي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            },
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('لا توجد بيانات متاحة'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppConstants.primaryColor,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  userData['name'] ?? 'بدون اسم',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppConstants.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  userData['email'] ?? '',
                  style: const TextStyle(fontSize: 16, color: AppConstants.textSecondary),
                ),
                const SizedBox(height: 30),
                _buildInfoTile(Icons.phone_outlined, 'رقم الهاتف', userData['phone'] ?? 'غير متوفر'),
                const SizedBox(height: 12),
                _buildInfoTile(Icons.shopping_bag_outlined, 'طلباتي', 'عرض سجل الطلبات السابقة'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: AppConstants.textSecondary, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
