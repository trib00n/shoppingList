import 'package:flutter/material.dart';
import 'database.dart';

class ShoppingItem extends StatelessWidget {
  final String title;
  final bool done;
  final Function remove;
  final Function toggleDone;
  final String userID;
  final DatabaseService databaseService;
  final db;
  final String documentID;
  const ShoppingItem(this.title, this.done, this.remove, this.toggleDone,
      this.userID, this.databaseService, this.db, this.documentID);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
        leading: Checkbox(
          value: done,
          onChanged: (bool value) => toggleDone(),
          activeColor: Colors.deepPurple,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: done ? Colors.deepPurple : Colors.black,
            decoration: done ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.black),
          onPressed: () => remove(),
        ),
      ),
    );
  }
}
