import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersView extends StatelessWidget {
  const AdminOrdersView({Key? key}) : super(key: key);

  // دالة لتحديث حالة الطلب في قاعدة البيانات
  Future<void> _updateStatus(String orderId, String newStatus) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الطلبات 📦')),
      body: StreamBuilder<QuerySnapshot>(
        // جلب الطلبات مترتبة من الأحدث للأقدم
        stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد طلبات حتى الآن', style: TextStyle(fontSize: 18)));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              
              // معالجة حالة الطلب
              final String status = data['status'] ?? 'pending';
              final List<String> validStatuses = ['pending', 'shipped', 'delivered'];
              final safeStatus = validStatuses.contains(status) ? status : 'pending';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.receipt_long, color: Colors.white),
                  ),
                  title: Text('تليفون: ${data['customerPhone'] ?? 'غير متوفر'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('العنوان: ${data['shippingAddress'] ?? 'غير متوفر'}'),
                  ),
                  isThreeLine: true,
                  trailing: DropdownButton<String>(
                    value: safeStatus,
                    underline: Container(), // إخفاء الخط السفلي لشكل أنظف
                    items: const [
                      DropdownMenuItem(value: 'pending', child: Text('مراجعة ⏳', style: TextStyle(color: Colors.orange))),
                      DropdownMenuItem(value: 'shipped', child: Text('في الطريق 🚚', style: TextStyle(color: Colors.blue))),
                      DropdownMenuItem(value: 'delivered', child: Text('تم التوصيل ✅', style: TextStyle(color: Colors.green))),
                    ],
                    onChanged: (val) {
                      if (val != null) _updateStatus(doc.id, val);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
