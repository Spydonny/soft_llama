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

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String message) async {
    final currentUID = _auth.currentUser!.uid;
    final currentUEmail = _auth.currentUser!.email!;
    final timestamp = Timestamp.now();
    final correctMessage = message.trim();

    Message newMessage = Message(
        senderID: currentUID,
        senderEmail: currentUEmail,
        message: correctMessage,
        timestamp: timestamp
    );

    String chatRoomID = currentUID;
    await _firestore.collection('message_rooms').doc(chatRoomID).collection(
        'messages').add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String uid) {
    String chatRoomID = uid;
    DateTime thresholdDate = DateTime.now().subtract(const Duration(days: 1));

    return _firestore.collection('message_rooms').doc(chatRoomID)
        .collection('messages').orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      snapshot.docs.removeWhere((doc) {
        DateTime messageTime = (doc['timestamp'] as Timestamp).toDate();
        return messageTime.isBefore(thresholdDate);
      });
      return snapshot;
    });
  }
}

class Message {
  final String senderID;
  final String senderEmail;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
