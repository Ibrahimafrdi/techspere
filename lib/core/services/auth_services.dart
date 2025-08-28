import 'dart:collection';

import 'package:delivery_app/core/models/appUser.dart';
import 'package:delivery_app/core/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthServices {
  final DatabaseServices _databaseServices = DatabaseServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  User? user;
  AppUser appUser = AppUser();

  AuthServices() {
    init();
  }

  Future<void> init() async {
    user = _auth.currentUser;

    if (user != null) {
      appUser = await _databaseServices.getUser(user!.uid) ?? AppUser();
    }
  }
 

  // ✅ Email sign in
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  Future<UserCredential> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    try {
      return await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'app-check-token-invalid') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'Security verification failed. Please try again.',
        );
      }
      throw FirebaseAuthException(
        code: e.code,
        message: _getFriendlyErrorMessage(e.code),
      );
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  String _getFriendlyErrorMessage(String code) {
    switch (code) {
      case 'invalid-verification-code':
        return 'Invalid OTP code. Please try again';
      case 'session-expired':
        return 'OTP session expired. Please request a new code';
      default:
        return 'Authentication failed. Please try again';
    }
  }

  Future<void> register(AppUser appUser) async {
    this.appUser = appUser;

    await _databaseServices.createUser(appUser);
    return;
  }
  

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
