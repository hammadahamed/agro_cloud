import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  var fb;
  var fbRef;

  var date = [].obs;
  var time = [].obs;
  var humidity = [].obs;
  var temperature = [].obs;
  var allRow = [].obs;

// init methods
  void onInit() {
    this.fbInitializer();
    super.onInit();
  }

  fbInitializer() {
    this.fb = FirebaseDatabase.instance;
    this.fbRef = fb.reference();
  }

  getData() async {
    time.clear();
    humidity.clear();
    allRow.clear();

    await fbRef.child("allData").once().then((DataSnapshot data) {
      print(">>>>>>>>>>>>>>>>>>> snapshot data :  $data");
      print(">>>>>>>>>>>>>>>>>>> snapshot data.value :  ${data.value}");
      for (var i = 0; i < data.value.length; i++) {
        print("-----------> inside loop data :  ${data.value[i]}");

        var temp = data.value[i].split("@");
        this.date.add(temp[0]);
        this.time.add(temp[1]);
        this.humidity.add(temp[2]);
        this.temperature.add(temp[3]);
      }
    });
  }
}
