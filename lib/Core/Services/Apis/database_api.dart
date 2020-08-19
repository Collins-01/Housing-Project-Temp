import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:housing_project/Core/Models/product_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class DatabaseApi {
  CollectionReference _collectionReference =
      Firestore.instance.collection("Products");
  Stream<List<Product>> getUserList() {
    return _collectionReference.snapshots().map((snapShot) => snapShot.documents
        .map((document) => Product.fromJson(document.data, document.documentID))
        .toList());
  }

  Future<QuerySnapshot> getFutureDataCollection() {
    return _collectionReference.getDocuments();
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
    return _collectionReference.add(map);
  }
}

// Cllection/Document/Collection.addd(unique Id)
// ProductList/UserId/User Posts/Document
