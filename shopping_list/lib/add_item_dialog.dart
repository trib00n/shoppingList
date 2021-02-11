import 'package:flutter/material.dart';

class AddItemDialog extends StatefulWidget {
  final Function(String txt) addItem;
  const AddItemDialog(this.addItem);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String item;

  void save() {
    if (formKey.currentState.validate()) {
      widget.addItem(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Neuen Artikel hinzufügen:'),
      content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                    "Geben Sie einen Namen für einen neuen Einkaufsartikel ein:"),
              ),
              TextFormField(
                onChanged: (String txt) => item = txt,
                onFieldSubmitted: (String txt) => save(),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Feld darf nicht leer sein!';
                  }
                  return null;
                },
              ),
              RaisedButton(
                onPressed: save,
                color: Colors.deepPurple,
                child: Text(
                  'Speichern',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )),
    );
  }
}
