import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  changeLoadingState(bool state) {
    _loading = state;
    notifyListeners();
  }

  Future<bool> signup(
      {required String emailAddress,
      required String password,
      required String name,
      required String userType}) async {
    try {
      changeLoadingState(true);

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      if (credential.user == null) return false;

      // Optionally, you can store additional user information in Firestore or Realtime Database
      // For example, you can create a user profile document with the user's name and type
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'name': name,
        'userType': userType,
        'email': emailAddress,
        'createdAt': Timestamp.now(),
      });

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    } finally {
      changeLoadingState(false);
    }
  }

  Future<String?> login(
      {required String emailAddress, required String password}) async {
    try {
      changeLoadingState(true);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      if (credential.user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          return userData['userType'];
        }
        return credential.user!.uid; // Return user ID or any other identifier
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    } finally {
      changeLoadingState(false);
    }
  }

  Future<void> signOut() async {
    try {
      changeLoadingState(true);
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    } finally {
      changeLoadingState(false);
    }
  }
}
