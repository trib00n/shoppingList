import 'package:flutter/material.dart';
import 'database.dart';

class AddShareDialog extends StatefulWidget {
  final Function(String userIDtxt, String listIDtxt) addItem;
  final DatabaseService databaseService;
  const AddShareDialog(this.addItem, this.databaseService);

  @override
  _AddShareDialogState createState() => _AddShareDialogState();
}

class _AddShareDialogState extends State<AddShareDialog> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String userIDtxt;
  String listIDtxt;

  void save() async {
    if (formKey.currentState.validate()) {
      if ((await widget.databaseService
          .checkIfRemoteExists(userIDtxt.trim(), listIDtxt.trim()))) {
        widget.addItem(userIDtxt, listIDtxt);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Neue geteilte Einkaufsliste hinzufügen:'),
      content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                    "Geben Sie eine Benutzer UID und eine Einkaufslisten ID ein:"),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Benutzer UID:",
                ),
                onChanged: (String userUID) => userIDtxt = userUID,
                onFieldSubmitted: (String txt) => save(),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Feld darf nicht leer sein!';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Einkaufslisten ID:",
                ),
                onChanged: (String listID) => listIDtxt = listID,
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
