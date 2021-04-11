import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  final GoogleSignInAccount detailsUser;

  Home({Key key, this.detailsUser}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  GoogleSignIn googleSignIn = GoogleSignIn();

  final fb = FirebaseDatabase.instance;
  final myController = TextEditingController();
  final name = "Name";

  var retrievedName;
  var retrievedHumidity;
  var retrievedTemperature;
  var retrievedLED;

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    return Scaffold(
        appBar: AppBar(
          title: Text("Agro Cloud"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                size: 20.0,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // CircleAvatar(
                //   backgroundImage: NetworkImage(widget.detailsUser.photoUrl),
                //   radius: 50.0,
                // ),
                // SizedBox(height: 10.0),
                // Text(
                //   "Name : " + widget.detailsUser.displayName,
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black,
                //       fontSize: 20.0),
                // ),
                // SizedBox(height: 10.0),
                // Text(
                //   "Email : " + widget.detailsUser.email,
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black,
                //       fontSize: 20.0),
                // ),
                // SizedBox(height: 10.0),
                // // Text(
                // //   "Provider : " + widget.detailsUser.,
                // //   style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 20.0),
                // // ),
                // ElevatedButton(
                //     child: Text("Get Data"),
                //     onPressed: () {
                //       // googleSignIn.signOut().then((value) async {
                //       //   await Future.delayed(Duration(milliseconds: 3000));
                //       //   Navigator.pop(context);
                //       //   // Navigator.pushNamed(context, '/login');
                //       // }).catchError((e) {
                //       //   print(e);
                //       // });
                //       // print('Signed out');
                //     }),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Text(name),
                //     SizedBox(width: 20),
                //     Expanded(child: TextField(controller: myController)),
                //   ],
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     ref.child(name).set(myController.text);
                //   },
                //   child: Text("Submit"),
                // ),
                ElevatedButton(
                  onPressed: () {
                    ref.child("DHT11Humidity").once().then((DataSnapshot data) {
                      print(data.value);
                      print(data.key);
                      setState(() {
                        retrievedHumidity = data.value;
                      });
                    });
                    ref
                        .child("DHT11Temperature")
                        .once()
                        .then((DataSnapshot data) {
                      print(data.value);
                      print(data.key);
                      setState(() {
                        retrievedTemperature = data.value;
                      });
                    });
                    ref.child("LED").once().then((DataSnapshot data) {
                      print(data.value);
                      print(data.key);
                      setState(() {
                        retrievedLED = data.value.toString();
                      });
                    });
                  },
                  child: Text("Get All Data"),
                ),
                ListTile(
                  title: Text("Humidity"),
                  trailing: Text(retrievedHumidity ?? ""),
                ),
                ListTile(
                  title: Text("Temperature"),
                  trailing: Text(retrievedTemperature ?? ""),
                ),
                ListTile(
                  title: Text("Led Status"),
                  trailing: retrievedLED == "0" ? Text("OFF") : Text("ON"),
                ),
                //Text(retrievedName ?? ""),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}
