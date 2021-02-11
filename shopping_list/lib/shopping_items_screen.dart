import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/add_item_dialog.dart';
import 'database.dart';
import 'shopping_item.dart';

class ShoppingItemsScreen extends StatelessWidget {
  final String title;
  final String userID;
  final DatabaseService databaseService;
  final db;
  final String documentID;
  final BuildContext c;
  const ShoppingItemsScreen(this.title, this.userID, this.databaseService,
      this.db, this.documentID, this.c);

  void deleteShoppingItem(
      String documentID, int itemID, Map itemMap, String userID) {
    databaseService.deleteShoppingItem(documentID, itemID, itemMap, userID);
  }

  void toggleDoneItem(
      String documentID, int itemID, Map itemMap, bool value, String userID) {
    databaseService.toggleShoppingItem(
        documentID, itemID, itemMap, !value, userID);
  }

  void addShoppingListItem(String listName) {
    databaseService.addShoppingItem(listName, documentID, userID);
    Navigator.pop(c);
  }

  void newShoppingListItem() {
    showDialog<AlertDialog>(
        context: c,
        builder: (BuildContext context) {
          return AddItemDialog(addShoppingListItem);
        });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Einkaufsliste: $title"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: db
            .collection('ShoppingLists')
            .document(userID)
            .collection("list")
            .document(documentID)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            items = snapshot.data.data;
            return ListView.builder(
                itemCount: items['items'].length,
                itemBuilder: (context, i) {
                  return ShoppingItem(
                      items['items'][i]['name'],
                      items['items'][i]['checked'],
                      () => deleteShoppingItem(documentID, i, items, userID),
                      () => toggleDoneItem(documentID, i, items,
                          items['items'][i]['checked'], userID),
                      userID,
                      databaseService,
                      db,
                      documentID);
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: newShoppingListItem,
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
