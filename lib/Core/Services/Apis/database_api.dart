import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:housing_project/Core/Models/product_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class DatabaseApi {
  CollectionReference _collectionReference =
      Firestore.instance.collection("Products");
  CollectionReference _userProfileCollectionReference =
      Firestore.instance.collection("UserProfile");
  Stream<List<Product>> getUserList() {
    return _collectionReference.snapshots().map((snapShot) => snapShot.documents
        .map((document) => Product.fromJson(document.data, document.documentID))
        .toList());
  }

  Future<QuerySnapshot> getFutureDataCollection() {
    return _collectionReference.getDocuments();
  }

  Stream<QuerySnapshot> fetchUserProfileData() async* {
    yield* _userProfileCollectionReference.snapshots();
  }

  Stream<QuerySnapshot> getStreamdataCollection() async* {
    yield* _collectionReference.snapshots();
  }

  Stream<QuerySnapshot> fetchRefreshedDocumentsAsStream() async* {
    yield* _collectionReference.orderBy("state", descending: true).snapshots();
  }

  Future<DocumentSnapshot> getDocumentsById(String id) async {
    return _collectionReference.document(id).get();
  }

  Future<void> deleteDocument(String id) async {
    return _collectionReference.document(id).delete();
  }

  Future<void> updateDocument(Map map, String id) async {
    return _collectionReference.document(id).updateData(map);
  }

  Future<void> addDocument(Map map) async {
    // String uid = (await FirebaseAuth.instance.currentUser()).uid;
    return _collectionReference.add(map);
  }

  Future<void> addProfileDocument(Map map) async {
    String uid = (await FirebaseAuth.instance.currentUser()).uid;
    return _collectionReference
        .document(uid)
        .collection("USER")
        .document()
        .setData(map);
  }
}
