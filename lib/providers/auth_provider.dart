
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/user.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  noVerification
}

enum AuthExceptionCode {
  notAuthenticated,
  emailVerifiedNull,
  userNeedConfirmation,
  invalidEmail,
  userNotFound,
  wrongPassword,
  emailInUse,
  weakPassword;
}

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  User? _user = FirebaseAuth.instance.currentUser;
  AuthStatus _status = AuthStatus.uninitialized;

  AuthStatus get status => _status;
  User? get user => _user;
  AppUser? get appuser => user!=null? AppUser(id: _user!.uid, email: _user!.email, name: _user!.displayName, photo: _user!.photoURL) : null;
  bool registering = false;

  AuthProvider() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen((firebaseUser) async {
      debugPrint('--- auth state listener');
      if (firebaseUser != null ) {

          _user = firebaseUser;
          _status = AuthStatus.authenticated;

      } else {
        _status = AuthStatus.unauthenticated;
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<User> signUp(String name, String email, String password) async {
    late User user;
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user == null) {
        throw AuthExceptionCode.userNotFound;
      }
      user = result.user!;
      await user.updateDisplayName(name);
      final token = await user.getIdToken(true);
      print("@signup token: $token");
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthExceptionCode.invalidEmail;
        case 'email-already-in-use':
          throw AuthExceptionCode.emailInUse;
        case 'weak-password':
          throw AuthExceptionCode.weakPassword;
      }
    }
    notifyListeners();
    return _auth.currentUser!;
  }

  Future<bool> signInEmailPassword(String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (_auth.currentUser == null) {
        _status = AuthStatus.unauthenticated;
        _auth.signOut();
        notifyListeners();
        throw AuthExceptionCode.emailVerifiedNull;
      }
      _status = AuthStatus.authenticated;

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('@AuthProvider#signInEmailPassword Exception: $e');
      notifyListeners();
      switch (e.code) {
        case 'invalid-email':
          throw AuthExceptionCode.invalidEmail;
        case 'user-not-found':
          throw AuthExceptionCode.userNotFound;
        case 'wrong-password':
          throw AuthExceptionCode.wrongPassword;
      }
      return false;
    }


  }

  Future<bool> updateUserPassword(String currentPassword, String newPassword) async {
    if(status != AuthStatus.authenticated) {
      return false;
    }
    final credential = EmailAuthProvider.credential(email: user!.email!, password: currentPassword);
    await user!.reauthenticateWithCredential(credential);
    try {
      await user!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthExceptionCode.invalidEmail;
        case 'email-already-in-use':
          throw AuthExceptionCode.emailInUse;
        case 'weak-password':
          throw AuthExceptionCode.weakPassword;
        case 'wrong-password':
          throw AuthExceptionCode.wrongPassword;
      }
    }
    return true;
  }

  // Sign out function
  Future signOut() async {
    _auth.signOut();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthExceptionCode.invalidEmail;
        case 'user-not-found':
          throw AuthExceptionCode.userNotFound;
        default:
          debugPrint("@AuthProvider#resetPassword e:$e");
          return false;
      }
    }
    return true;
  }

  /// Updated [user] profile image url to [imgUrl].
  Future<void> updateUserProfileImage(String imgUrl) async {
    print("@authProvider#updateUserProfileImage in: $imgUrl");

    await user!.updatePhotoURL(imgUrl);
    await user!.getIdToken(true);

    print("@authProvider#updateUserProfileImage updated");
    notifyListeners();
  }

}

class AuthException implements Exception {
  final AuthExceptionCode _code;
  AuthExceptionCode get code => _code;
  AuthException(this._code);
}

