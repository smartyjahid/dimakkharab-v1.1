import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dimagkharab/newsidebar.dart';
import 'package:provider/provider.dart';
import 'package:dimagkharab/homepage.dart';

class newuser extends StatefulWidget {
  @override
  _newuser createState() => _newuser();
}

class _newuser extends State<newuser> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onpressedback,
      child: Scaffold(
        appBar: AppBar(),
        drawer: Maindrawer(),
        body: StreamBuilder(
          stream: getuserdataSnapShot(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('bhai wait kr....');
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildTripCard(context, snapshot.data.documents[index]));
          },
        ),
      ),
    );
  }

  Future<bool> _onpressedback() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are You Want To Exit ?"),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("no")),
          FlatButton(
              onPressed: () => Navigator.pop(context, true), child: Text("yes"))
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getuserdataSnapShot(BuildContext context) async* {
    Firestore _firestore = Firestore.instance;
// data retriveing....
    FirebaseAuth _firebase = FirebaseAuth.instance;
    FutureOr<String> uid =
        await _firebase.currentUser().then((user) => user.uid);

    yield* _firestore
        .collection("crackerdetails")
        .document(uid.toString())
        .collection("using")
        .snapshots();
  }

  Widget buildTripCard(BuildContext context, DocumentSnapshot using) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Row(
                  children: [
                    Text(
                      using['name'],
                      style: TextStyle(fontSize: 30.0),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Row(
                  children: [
                    Text(
                      using['branch'],
                      style: TextStyle(fontSize: 30.0),
                    ),
                    Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
