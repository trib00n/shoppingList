import 'package:flutter/material.dart';

class AddListDialog extends StatefulWidget {
  final void Function(String txt) addItem;
  const AddListDialog(this.addItem);

  @override
  _AddListDialogState createState() => _AddListDialogState();
}

class _AddListDialogState extends State<AddListDialog> {
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
      title: Text('Neue Einkaufsliste hinzufügen:'),
      content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                    "Geben Sie einen Namen für die neue Einkaufsliste ein:"),
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
                color: Colors.deepOrange,
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
