import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class SwitchController extends GetxController {
  var fb;
  var fbRef;

  //inside widget build
  Rx<bool> controlSwitch1 = true.obs;
  Rx<bool> controlSwitch2 = true.obs;
  Rx<bool> controlSwitch3 = true.obs;
  Rx<bool> controlSwitch4 = true.obs;

  @override
  void onInit() {
    this.initializer();
    super.onInit();
  }

  fbInitializer() {
    this.fb = FirebaseDatabase.instance;
    this.fbRef = fb.reference();
  }

  initializer() async {
    this.fbInitializer();
    this.controlSwitch1.value =
        await this.fbRef.once().then((DataSnapshot snapshot) {
      return snapshot.value["LED"] == 1 ? true : false;
    });
    this.controlSwitch2.value =
        await this.fbRef.once().then((DataSnapshot snapshot) {
      return snapshot.value["S2"] == 1 ? true : false;
    });
    this.controlSwitch3.value =
        await this.fbRef.once().then((DataSnapshot snapshot) {
      return snapshot.value["S3"] == 1 ? true : false;
    });
    this.controlSwitch4.value =
        await this.fbRef.once().then((DataSnapshot snapshot) {
      return snapshot.value["S4"] == 1 ? true : false;
    });
  }
}
