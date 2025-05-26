import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'users';

  Future<void> addUser(UserModel user) async {
    await _firestore.collection(collectionName).doc(user.id).set(user.toJson());
  }

  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection(collectionName)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>)
              ..id = doc.id)
            .toList());
  }

  Future<void> updateUser(String id, Map<String, dynamic> updatedData) async {
    await _firestore.collection(collectionName).doc(id).update(updatedData);
  }

  Future<void> deleteUser(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }
}
