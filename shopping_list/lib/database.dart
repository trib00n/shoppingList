import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String userID;
  DatabaseService(this.userID);
  final firestoreInstance = Firestore.instance;
  final CollectionReference shoppingLists =
      Firestore.instance.collection('ShoppingLists');

  Future addShoppingList(String key) async {
    DocumentReference docRef =
        shoppingLists.document(userID).collection("list").document();

    return await shoppingLists
        .document(userID)
        .collection("list")
        .document(docRef.documentID)
        .setData({"name": key, "checked": false, "items": []});
  }

  Future toggleShoppingList(String documentID, bool value, userID) async {
    return await shoppingLists
        .document(userID)
        .collection("list")
        .document(documentID)
        .updateData({"checked": value});
  }

  Future toggleShoppingItem(
      String documentID, int itemID, Map itemMap, bool value, userID) async {
    itemMap['items'][itemID]["checked"] = value;

    return await shoppingLists
        .document(userID)
        .collection("list")
        .document(documentID)
        .updateData(itemMap);
  }

  Future addShoppingItem(
      String listName, String documentID, String userID) async {
    return await shoppingLists
        .document(userID)
        .collection("list")
        .document(documentID)
        .setData({
      'items': FieldValue.arrayUnion([
        {"name": listName, "checked": false, "count": 1}
      ])
    }, merge: true);
  }

  Future deleteShoppingItem(
      String documentID, int itemID, Map itemMap, String userID) async {
    return await shoppingLists
        .document(userID)
        .collection("list")
        .document(documentID)
        .updateData({
      'items': FieldValue.arrayRemove(
        [itemMap['items'][itemID]],
      )
    });
  }

  Future deleteShoppingList(String documentID) async {
    return await shoppingLists
        .document(userID)
        .collection("list")
        .document(documentID)
        .delete();
  }

  Future checkIfUserExists() async {
    if ((await shoppingLists.document(userID).get()).exists) {
      return true;
    } else {
      return false;
    }
  }

  Future getSharedUid() async {
    return shoppingLists.document(userID).get();
  }

  Future setShare(String remoteUserID, String listID) async {
    await shoppingLists
        .document(remoteUserID)
        .collection("list")
        .document(listID)
        .setData({'sharedUid': userID}, merge: true);

    return await shoppingLists
        .document(userID)
        .setData({'sharedUser': remoteUserID}, merge: true);
  }

  Future deleteShare(String remoteUserID, String listID) async {
    await shoppingLists
        .document(remoteUserID)
        .collection("list")
        .document(listID)
        .updateData({'sharedUid': FieldValue.delete()});

    return await shoppingLists
        .document(userID)
        .setData({'sharedUser': FieldValue.delete()});
  }
}
