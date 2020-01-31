import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/brew.dart';
import 'package:flutter_firebase/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference collectionReference =
      Firestore.instance.collection("users");

  Future updateUserData(String sugars, String name, int strength) async {
    return await collectionReference
        .document(uid)
        .setData({'sugars': sugars, 'name': name, 'strength': strength});
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
    );
  }

  // list from snapshot
  List<Brew> _brewListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
          name: doc.data['name'] ?? '',
          strength: doc.data['strength'] ?? 0,
          sugars: doc.data['sugars'] ?? '0');
    }).toList();
  }

  // get users stream
  Stream<List<Brew>> get users {
    return collectionReference.snapshots().map(_brewListFromSnapShot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return collectionReference
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
