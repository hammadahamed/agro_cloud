import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class FeatureController extends GetxController {
  var fb;
  var fbref;

  ///inside widget build
  var controlSwitch1 = true.obs;
  bool controlSwitch2;
  bool controlSwitch3;
  bool controlSwitch4;
  fbInitializer() {
    this.fb = FirebaseDatabase.instance;
    this.fbref = fb.reference();
  }

  initializer() async {
    this.fbInitializer();
    this.controlSwitch1.value =
        await this.fbref.once().then((DataSnapshot snapshot) {
      // print("sanp value : ${snapshot.value["LED"]}");
      return snapshot.value["LED"] == 1 ? true : false;
    });
  }
}
