import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_list_app/list_function/Model/list_model.dart';

class GroceryDatabaseService {
  CollectionReference groceryCollection =
      FirebaseFirestore.instance.collection("GroceryList");

  Stream<List<GroceryModel>> listGrocery() {
    return groceryCollection
        .orderBy("Timestamp", descending: true)
        .snapshots()
        .map(groceryFromFirestore);
  }

  Future createNewItem(String titie) async {
    return await groceryCollection.add({
      "title": titie,
      "isCompleted": false,
      "Timestamp": FieldValue.serverTimestamp(),
    });
  }

// Updates Grocery List
  Future updateItem(uid, bool newCompleteItem) async {
    await groceryCollection.doc(uid).update({"isCompleted": newCompleteItem});
  }

// Deletes Item from Grocery List
  Future deleteItem(uid) async {
    await groceryCollection.doc(uid).delete();
  }

  List<GroceryModel> groceryFromFirestore(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      Map<String, dynamic>? data = e.data() as Map<String, dynamic>?;

      return GroceryModel(
          isCompleted: data?['isCompleted'] ?? true,
          title: data?['title'] ?? "",
          uid: e.id);
    }).toList();
  }
}
