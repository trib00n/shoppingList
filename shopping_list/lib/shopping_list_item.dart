import 'package:flutter/material.dart';
import 'shopping_items_screen.dart';
import 'database.dart';
import 'package:share/share.dart';

class ShoppingListItem extends StatelessWidget {
  final String title;
  final bool done;
  final Function remove;
  final Function toggleDone;
  final String userID;
  final DatabaseService databaseService;
  final db;
  final String documentID;
  final BuildContext context;
  const ShoppingListItem(
      this.title,
      this.done,
      this.remove,
      this.toggleDone,
      this.userID,
      this.databaseService,
      this.db,
      this.documentID,
      this.context);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          leading: Checkbox(
            checkColor: Colors.black,
            value: done,
            onChanged: (bool value) => toggleDone(),
            activeColor: Colors.deepOrange,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: done ? Colors.deepOrange : Colors.black,
              decoration:
                  done ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Share.share(
                      "Ein Benutzer möchte mit Ihnen eine Einkaufsliste teilen. \n Bitte geben Sie folgende Daten ein: \n Benutzer ID:\n$userID \n Einkaufsliste:\n$documentID",
                      subject: "Geteilte Einkaufsliste");
                },
                icon: Icon(Icons.share, color: Colors.black),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.black),
                onPressed: () => remove(),
              ),
            ],
          ),
          onTap: () {
            Navigator.push<Widget>(
                context,
                MaterialPageRoute<Widget>(
                    builder: (BuildContext context) => ShoppingItemsScreen(
                        title,
                        userID,
                        databaseService,
                        db,
                        documentID,
                        context)));
          }),
    );
  }
}
