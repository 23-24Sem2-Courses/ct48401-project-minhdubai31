import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct484_project/models/user.dart';

const String usersCollectionRef = "users";

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usersRef;

  UserService() {
    _usersRef = _firestore.collection(usersCollectionRef).withConverter<User>(
          fromFirestore: (snapshot, option) => User.fromJson(snapshot.data()!),
          toFirestore: (user, option) => user.toJson(),
        );
  }

  Stream<QuerySnapshot> getUsers() {
    return _usersRef.snapshots();
  }

  Future<DocumentSnapshot> getUser(String userId) {
    return _usersRef.doc(userId).get();
  }

  Future<void> addUser(User user, String userId) async {
    await _usersRef.doc(userId).set(user);
  }

  Future<void> updateUser(String userId, User user) async {
    await _usersRef.doc(userId).update(user.toJson());
  }

  Future<void> deleteUser(String userId) async {
    await _usersRef.doc(userId).delete();
  }
}
