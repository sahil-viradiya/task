import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  /// Add or Update User
  Future<void> addOrUpdateUser(dynamic user) async {
    await usersCollection
        .doc(user.id.toString())
        .set(user.toJson(), SetOptions(merge: true));
  }

  /// Delete User
  Future<void> deleteUser(int userId) async {
    await usersCollection.doc(userId.toString()).delete();
  }
}
