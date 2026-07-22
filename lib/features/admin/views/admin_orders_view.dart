import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersView extends StatelessWidget {
  const AdminOrdersView({Key? key}) : super(key: key);

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
              
              final String status = data['status'] ?? 'pending';
              final List<String> validStatuses = ['pending', 'shipped', 'delivered'];
              final safeStatus = validStatuses.contains(status) ? status : 'pending';
              
              final List<dynamic> items = data['items'] ?? [];
              final double totalAmount = (data['totalAmount'] ?? 0.0).toDouble();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.receipt_long, color: Colors.white),
                  ),
                  title: Text('تليفون: ${data['customerPhone'] ?? 'غير متوفر'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('الإجمالي: $totalAmount ج.م | العنوان: ${data['shippingAddress'] ?? 'غير متوفر'}'),
                  trailing: DropdownButton<String>(
                    value: safeStatus,
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(value: 'pending', child: Text('مراجعة ⏳', style: TextStyle(color: Colors.orange, fontSize: 12))),
                      DropdownMenuItem(value: 'shipped', child: Text('في الطريق 🚚', style: TextStyle(color: Colors.blue, fontSize: 12))),
                      DropdownMenuItem(value: 'delivered', child: Text('تم التوصيل ✅', style: TextStyle(color: Colors.green, fontSize: 12))),
                    ],
                    onChanged: (val) {
                      if (val != null) _updateStatus(doc.id, val);
                    },
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('المنتجات المطلوبة في الأوردر:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                          const Divider(),
                          ...items.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item['name']} (x1)', style: const TextStyle(fontWeight: FontWeight.w500)),
                                Text('${item['price']} ج.م', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
