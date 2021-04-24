import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class FeatureController extends GetxController {
  var fb;
  var fbref;

  ///inside widget build
  Rx<bool> controlSwitch1;
  bool controlSwitch2;
  bool controlSwitch3;
  bool controlSwitch4;
  fbInitializer() {
    this.fb = FirebaseDatabase.instance;
    this.fbref = fb.reference();
  }

  initializer() async {
    fbInitializer();
    this.controlSwitch1 = await this.fbref.once().then((DataSnapshot snapshot) {
      return snapshot.value["LED"] == 1 ? true : false;
    });
  }
}
