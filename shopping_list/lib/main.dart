import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'add_list_dialog.dart';
import 'add_share_dialog.dart';
import 'shopping_list_item.dart';
import 'database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  runApp(MaterialApp(home: ShoppingList(), debugShowCheckedModeBanner: false));
}

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  int _page = 0;
  String sharedUid = "";
  List remoteList;
  var callOnce = true;
  bool ready = false;
  Function floatingActionButtonFunction;
  FirebaseUser user;
  DatabaseService databaseService;
  final db = Firestore.instance;

  Widget bodyFunction() {
    switch (_page) {
      case 0:
        ready = false;
        callOnce = true;
        floatingActionButtonFunction = newShoppingList;
        return FutureBuilder(
            future: connectToFirebase(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return new StreamBuilder<QuerySnapshot>(
                  stream: db
                      .collection('ShoppingLists')
                      .document(user.uid)
                      .collection("list")
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      var doc = snapshot.data.documents;
                      return ListView.builder(
                          itemCount: doc.length,
                          itemBuilder: (context, i) {
                            return ShoppingListItem(
                                doc[i].data['name'],
                                doc[i].data['checked'],
                                () => deleteShoppingList(doc[i].documentID),
                                () => toggleDone(doc[i].documentID,
                                    doc[i].data['checked'], user.uid),
                                user.uid,
                                databaseService,
                                db,
                                doc[i].documentID,
                                context);
                          });
                    }
                  },
                );
              }
            });
        break;
      case 1:
        floatingActionButtonFunction = newShare;
        if (callOnce) {
          databaseService.getSharedUid().then((value) async {
            setState(() {
              remoteList = value.data["sharedUsers"];
              ready = true;
              callOnce = false;
            });
          });
        }
        return FutureBuilder(
            future: connectToFirebase(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                StreamBuilder<QuerySnapshot> streamB;
                if (ready) {
                  remoteList.forEach((element) {
                    sharedUid = element["remoteUid"].toString();
                    Column(
                      children: [
                        streamB = new StreamBuilder<QuerySnapshot>(
                          stream: db
                              .collection('ShoppingLists')
                              .document(sharedUid)
                              .collection("list")
                              .snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              var doc = snapshot.data.documents;
                              return ListView.builder(
                                  itemCount: doc.length,
                                  itemBuilder: (context, i) {
                                    if (element["listUid"].toString() ==
                                        doc[i].documentID) {
                                      return ShoppingListItem(
                                          doc[i].data['name'],
                                          doc[i].data['checked'],
                                          () => deleteShare(sharedUid, i),
                                          () => toggleDone(
                                              doc[i].documentID,
                                              doc[i].data['checked'],
                                              sharedUid),
                                          sharedUid,
                                          databaseService,
                                          db,
                                          doc[i].documentID,
                                          context);
                                    } else
                                      return Container(
                                        height: 45,
                                        color: Colors.red,
                                        child: Center(
                                          child: Text(
                                            'Keine geteile Einkaufsliste gefunden!',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
                                  });
                            }
                          },
                        ),
                      ],
                    );
                  });
                }
                if (streamB != null) {
                  return streamB;
                } else {
                  return Container(
                    height: 45,
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        'Keine geteile Einkaufsliste gefunden!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              }
            });
        break;
    }
  }

  void addShoppingList(String listName) {
    databaseService.addShoppingList(listName);

    Navigator.pop(context);
  }

  void addShare(String userID, String listID) {
    databaseService.setShare(userID, listID);
    Navigator.pop(context);
    setState(() {
      ready = false;
      callOnce = true;
    });
  }

  void deleteShare(String userID, int arrayID) {
    databaseService.deleteShare(userID, arrayID);
    setState(() {
      ready = false;
      callOnce = true;
    });
  }

  void deleteShoppingList(String documentID) {
    databaseService.deleteShoppingList(documentID);
  }

  void toggleDone(String listName, bool value, String userID) {
    databaseService.toggleShoppingList(listName, !value, userID);
  }

  void newShoppingList() {
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AddListDialog(addShoppingList);
        });
  }

  void newShare() {
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AddShareDialog(addShare, databaseService);
        });
  }

  Future<void> connectToFirebase() async {
    final FirebaseAuth authenticate = FirebaseAuth.instance;
    AuthResult result = await authenticate.signInAnonymously();
    user = result.user;
    databaseService = DatabaseService(user.uid);
  }

  @override
  void initState() {
    super.initState();
    connectToFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einkaufslisten"),
        backgroundColor: Colors.deepOrange,
      ),
      body: bodyFunction(),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.deepOrange,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 50,
        items: <Widget>[
          Icon(Icons.library_add_sharp, size: 20, color: Colors.black),
          Icon(Icons.share, size: 20, color: Colors.black),
        ],
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: floatingActionButtonFunction,
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
