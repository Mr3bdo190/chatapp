import 'package:firebase_auth/package:firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تسجيل حساب جديد وحفظ البيانات
  Future<UserCredential?> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // حفظ بيانات اليوزر في فايربيز بصلاحية (user) مبدئياً
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'phone': phone,
        'email': email,
        'role': 'user', // الكلمة السحرية للتفريق
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // تسجيل الدخول
  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // جلب صلاحية المستخدم (هل هو أدمن أم عميل؟)
  Future<String> getUserRole(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return (doc.data() as Map<String, dynamic>)['role'] ?? 'user';
    }
    return 'user';
  }
}
