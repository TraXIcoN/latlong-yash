import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textcontroller = TextEditingController();
  final databaseRef =
      FirebaseDatabase.instance.reference().child("coordinates");
  final Future<FirebaseApp> _future = Firebase.initializeApp();

  List list = [];
  String texttodisplay = "";
  var lat;
  var long;

  @override
  void initState() {
    super.initState();
    cronForLatLong();
  }

  void cronForLatLong() {
    const oneSec = Duration(seconds: 10);

    // ignore: use_function_type_syntax_for_parameters
    Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        texttodisplay = lat + "," + long;
      }); // This statement will be printed after every one second
    });
  }

  void addData(String data) {
    databaseRef.push().set({'lat': data, 'long': '67.666'});
  }

  void printFirebase() {
    databaseRef.once().then((DataSnapshot snapshot) {
      Query lastchield = FirebaseDatabase.instance
          .reference()
          .child("yourchieldfororder")
          .limitToLast(1);
      var LASTMESSAGE = snapshot.value;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print(values);
        lat = values["lat"];
        long = values["long"];
      });
      print(LASTMESSAGE);
      print(lat);
      print(long);
    });
  }

  @override
  Widget build(BuildContext context) {
    printFirebase();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Demo"),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 250.0),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: textcontroller,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Center(
                        child: RaisedButton(
                            color: Colors.pinkAccent,
                            child: const Text("Save to Database"),
                            onPressed: () {
                              addData(textcontroller.text);
                              //call method flutter upload
                            })),
                    const SizedBox(height: 250.0),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(texttodisplay),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
