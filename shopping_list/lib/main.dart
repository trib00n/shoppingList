import 'package:flutter/material.dart';

void main() => runApp(
    MaterialApp(home: ShoppingList(), debugShowCheckedModeBanner: false));

final List<String> shoppingLists = [
  'Einkaufsliste 1',
  'Einkaufsliste 2',
  'Einkaufsliste 3'
];

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Einkaufslisten-App"),
          backgroundColor: Color.fromRGBO(35, 152, 185, 100),
        ),
        body: ListView.builder(
          itemCount: shoppingLists.length,
          itemBuilder: (context, i) {
            return ShoppingListItem(shoppingLists[i], (i+1).toString());
          },
        ));
  }
}

class ShoppingListItem extends StatelessWidget {
  final String title;
  final String number;
  const ShoppingListItem(this.title,this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
        leading:  Text(
          "#" + number,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.black54),
        ),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.black54),
        ),
        trailing: Icon(Icons.edit),
      ),
    );
  }
}
