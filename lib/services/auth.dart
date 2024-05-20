import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/loginuser.dart';
import '../models/FirebaseUser.dart';
import '../models/registeruser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Define _firestore here

  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  Stream<FirebaseUser?> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }

  Future signInAnonymous() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      return _firebaseUser(user);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  Future signInEmailPassword(LoginUser _login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _login.email.toString(),
              password: _login.password.toString());
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: 'Sai mật khẩu hoặc email', uid: null);
    }
  }

  Future registerEmailPassword(RegisterUser _register) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _register.email.toString(),
              password: _register.password.toString());
      User? user = userCredential.user;
      int isAdminValue = (_register.email == 'admin@gmail.com') ? 1 : 0;
      await addUserInfoToFirestore(
        uid: user!.uid,
        name: _register.name!,
        gender: _register.gender!,
        isAdmin: isAdminValue,
      );
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future<void> addUserInfoToFirestore({
    required String uid,
    required String name,
    required int gender,
    required int isAdmin,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .set({'name': name, 'gender': gender, 'isAdmin': isAdmin});
      print("User Info Added");
    } catch (error) {
      print("Failed to add user info: $error");
    }
  }
}
