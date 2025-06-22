import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fix_my_area/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ... (no changes to getUserDetails, signIn, or signOut)
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  Future<UserModel?> getUserDetails() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
    } catch (e) {
      debugPrint("Error fetching user details: $e");
    }
    return null;
  }
  
  Future<UserCredential?> signUpWithEmailAndPassword(String name, String email, String phone, String password, bool isServiceProvider) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      List<String> defaultServices = isServiceProvider ? ['Plumbing', 'Electrical', 'Cleaning'] : [];
      String defaultBio = isServiceProvider ? 'Experienced and reliable professional dedicated to quality service.' : '';
      String defaultRate = isServiceProvider ? 'From 5,000 RWF/hr' : '';

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'role': isServiceProvider ? 'provider' : 'customer',
        'createdAt': Timestamp.now(),
        'services': defaultServices,
        'bio': defaultBio, // Add default bio
        'rate': defaultRate, // Add default rate
        'photoUrl': '', // Default empty photo URL
      });
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Exception: ${e.message}");
      rethrow;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Exception: ${e.message}");
      rethrow;
    }
  }
  
  Future<List<UserModel>> getProvidersByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'provider')
          .where('services', arrayContains: category)
          .get();

      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint("Error fetching providers: $e");
      return [];
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
