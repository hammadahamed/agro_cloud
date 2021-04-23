import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';



class FeatureController extends GetxController {
   final fb = FirebaseDatabase.instance;
   //final ref = fb.reference();   ///inside widget build
  bool controlSwitch1;
  bool controlSwitch2;
  bool controlSwitch3;
  bool controlSwitch4;
  //  initializer()
  //  {
  //     StreamBuilder(builder: ref.onValue , builder: (context, snap){return Text(snap.data.snapshot.value["LED"])})

  //  }
}
