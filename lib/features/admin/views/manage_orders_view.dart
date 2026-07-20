import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class ManageOrdersView extends StatefulWidget {
  const ManageOrdersView({Key? key}) : super(key: key);

  @override
  State<ManageOrdersView> createState() => _ManageOrdersViewState();
}

class _ManageOrdersViewState extends State<ManageOrdersView> {
  // داتا وهمية مؤقتة لحد الربط مع فايربيز
  final List<Map<String, dynamic>> _orders = [
    {'id': '#ORD-12345', 'customer': 'أحمد محمد', 'total': '450 ج.م', 'status': AppConstants.statusPending},
    {'id': '#ORD-98765', 'customer': 'محمود علي', 'total': '800 ج.م', 'status': AppConstants.statusProcessing},
    {'id': '#ORD-55443', 'customer': 'كريم حسن', 'total': '350 ج.م', 'status': AppConstants.statusShipped},
  ];

  // أسماء الحالات بالعربي للعرض
  final Map<String, String> _statusNames = {
    AppConstants.statusPending: 'قيد الانتظار',
    AppConstants.statusProcessing: 'جاري التجهيز',
    AppConstants.statusShipped: 'تم الشحن',
    AppConstants.statusDelivered: 'تم التسليم',
    AppConstants.statusCancelled: 'مرفوض / ملغي',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('إدارة الطلبات'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'طلب: ${order['id']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppConstants.primaryColor),
                    ),
                    Text(
                      order['total'],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.secondaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: AppConstants.textSecondary),
                    const SizedBox(width: 8),
                    Text(order['customer'], style: const TextStyle(color: AppConstants.textSecondary)),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('حالة الطلب:', style: TextStyle(fontWeight: FontWeight.bold)),
                    
                    // قائمة تغيير الحالة
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppConstants.backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: order['status'],
                          icon: const Icon(Icons.arrow_drop_down, color: AppConstants.primaryColor),
                          items: _statusNames.keys.map((String key) {
                            return DropdownMenuItem<String>(
                              value: key,
                              child: Text(
                                _statusNames[key]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: key == AppConstants.statusDelivered 
                                      ? Colors.green 
                                      : (key == AppConstants.statusCancelled ? Colors.red : AppConstants.textPrimary),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              order['status'] = newValue!;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم تحديث حالة الطلب ${order['id']} بنجاح!')),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
