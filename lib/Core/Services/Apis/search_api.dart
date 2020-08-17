import 'package:cloud_firestore/cloud_firestore.dart';

class SearchApi {
  static Firestore database = Firestore.instance;
  String ref = "Products";

  // var collectionReference=database.collection("Products").orderBy("state","town",).getDocuments();

  Future<List<DocumentSnapshot>> getListOfSearchData() =>
      database.collection(ref).getDocuments().then((snapshot) {
        return snapshot.documents;
      });
  Future<List<DocumentSnapshot>> getSuggestionList(
          String query, String suggestion) =>
      database
          .collection(ref)
          .where(query, isEqualTo: suggestion)
          .getDocuments()
          .then((snapshots) => snapshots.documents);

  // Stream<List<DocumentSnapshot> getSuggetstionListAsStream(String suggestion) =>
  //     database.collection(ref).where("town", isEqualTo: suggestion).snapshots();
}
