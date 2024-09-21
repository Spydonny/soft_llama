import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //login
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
        throw Exception("Error: ${e.message}");
    } catch (e) {
      // Catch other general errors
      throw Exception("Unknown error: ${e.toString()}");
    }
  }

  //logout
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //sign up
  Future<UserCredential> signUpWithEmailPassword(String email, String password,
      String firstname, String lastname, String grade) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _firestore.collection('Users').doc(userCredential.user!.uid).set(
          {
            'uid' : userCredential.user!.uid,
            'firstname': firstname,
            'lastname': lastname,
            'grade': grade,
            'email' : email
          }
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}