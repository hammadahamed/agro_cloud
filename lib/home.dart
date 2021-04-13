import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login.dart';

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
  // var retrievedName;
  // var retrievedHumidity;
  // var retrievedTemperature;
  // var retrievedLED;
  bool ledStatus = false;

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();

    return Scaffold(
        appBar: AppBar(
          title: Text("Agro Cloud"),
          actions: <Widget>[
            InkWell(
              onTap: () {
                print("image clicked");
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          content: Container(
                              height: 150,
                              child: Column(
                                children: [
                                  SizedBox(width: 15),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          radius: 20.0,
                                          backgroundImage: NetworkImage(
                                              widget.detailsUser.photoUrl),
                                        ),
                                      ),
                                      Text(
                                        widget.detailsUser.displayName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Text(widget.detailsUser.email),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await googleSignIn.signOut();
                                        // Navigator.of(context).pushReplacement(
                                        //     MaterialPageRoute(
                                        //         builder: (context) => Login()));
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login()),
                                            (route) => false);
                                      },
                                      child: Text("Sign Out"),
                                    ),
                                  )
                                ],
                              )),
                        ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(widget.detailsUser.photoUrl),
                ),
              ),
            ),
            // IconButton(
            //   icon: Icon(
            //     Icons.exit_to_app,
            //     size: 20.0,
            //     color: Colors.white,
            //   ),
            //   tooltip: "EXIT",
            //   onPressed: () async {
            //     await googleSignIn.signOut();

            //   },
            // ),
          ],
        ),
        body: StreamBuilder(
          stream: ref.onValue,
          builder: (context, snap) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // //   "Provider : " + widget.detailsUser.,
                    ElevatedButton(
                      onPressed: () {
                        print(snap.data.snapshot.value["DHT11Humidity"]);
                        // ref.child("DHT11Humidity").once().then((DataSnapshot data)
                        // {
                        //   print(data.value);
                        //   print(data.key);
                        //   setState(() {
                        //     retrievedHumidity = data.value;
                        //   });
                        // });
                        // ref
                        //     .child("DHT11Temperature")
                        //     .once()
                        //     .then((DataSnapshot data) {
                        //   print(data.value);
                        //   print(data.key);
                        //   setState(() {
                        //     retrievedTemperature = data.value;
                        //   });
                        // });
                        // ref.child("LED").once().then((DataSnapshot data) {
                        //   print(data.value);
                        //   print(data.key);
                        //   setState(() {
                        //     retrievedLED = data.value.toString();
                        //     if (retrievedLED == "0") {
                        //       ledStatus = false;
                        //     } else {
                        //       ledStatus = true;
                        //     }
                        //   });
                        // });
                      },
                      child: Text("Get All Data"),
                    ),
                    ListTile(
                      title: Text("Humidity"),
                      trailing: Text(snap.data.snapshot.value["DHT11Humidity"]),
                    ),
                    ListTile(
                      title: Text("Temperature"),
                      trailing:
                          Text(snap.data.snapshot.value["DHT11Temperature"]),
                    ),
                    ListTile(
                      title: Text("Led Status"),
                      trailing: snap.data.snapshot.value["LED"] == 0
                          ? Text("OFF")
                          : Text("ON"),
                    ),
                    ListTile(
                      title: Text("Switch"),
                      trailing: Switch(
                          value: ledStatus,
                          onChanged: (value) {
                            setState(() {
                              ledStatus = value;
                              if (ledStatus) {
                                ref.child("LED").set(1);
                              } else {
                                ref.child("LED").set(0);
                              }
                              print(ledStatus);
                            });
                          }),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
