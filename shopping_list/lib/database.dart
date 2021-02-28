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

    shoppingLists.document(userID).updateData({"sharedUsers": []});

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
        {"name": listName, "checked": false}
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

  Future checkIfRemoteExists(String remoteUserId, String remoteListId) async {
    if ((await shoppingLists
            .document(remoteUserId)
            .collection("list")
            .document(remoteListId)
            .get())
        .exists) {
      return true;
    } else {
      return false;
    }
  }

  Future getSharedUid() async {
    return shoppingLists.document(userID).get();
  }

  Future setShare(String remoteUserID, String listID) async {
    return await shoppingLists.document(userID).setData({
      'sharedUsers': [
        {"remoteUid": remoteUserID, "listUid": listID}
      ]
    }, merge: true);
  }

  Future deleteShare(String remoteUserID, int arrayID) async {
    Map<dynamic, dynamic> map;
    await shoppingLists
        .document(userID)
        .get()
        .then((DocumentSnapshot snapshot) {
      map = snapshot.data;
    });

    return await shoppingLists.document(userID).updateData({
      'sharedUsers': FieldValue.arrayRemove(
        [map['sharedUsers'][arrayID]],
      )
    });
  }
}
