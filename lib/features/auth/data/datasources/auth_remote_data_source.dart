import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<AppUserModel?> watchAuthUser() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }

      final userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();

      final data = userDoc.data();
      return AppUserModel(
        id: firebaseUser.uid,
        name: (data?['name'] as String?) ?? firebaseUser.displayName ?? '',
        email: (data?['email'] as String?) ?? firebaseUser.email ?? '',
      );
    });
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final credentials = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credentials.user?.updateDisplayName(fullName);

    final userId = credentials.user?.uid;
    if (userId == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }

    await _firestore.collection('users').doc(userId).set({
      'name': fullName,
      'email': email,
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
