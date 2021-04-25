import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  var fb;
  var fbRef;
  var db;

  List<String> date = [];
  List<String> time = [];
  List<String> humidity = [];
  List<String> temperature = [];
  var allRow = [];

  get getdate => this.date;

  var isDataLoading = false.obs;

// init methods is this
  void onInit() {
    this.fbInitializer();
    super.onInit();
  }

  fbInitializer() {
    this.fb = FirebaseDatabase.instance;
    // this.db = FirebaseDatabase.;
    this.fbRef = fb.reference();
  }

  var numberOfValues = 50;
  // DATA FETCHER ----------------->
  getData() async {
    // db = FirebaseDatabase.g
    isDataLoading.value = true;
    date.clear();
    time.clear();
    humidity.clear();
    temperature.clear();
    allRow.clear();

    await Future.delayed(Duration(seconds: 1));
    await fbRef.child("allData").once().then((DataSnapshot data) {
      print(">>>>>>>>>>>>>>>>>>> snapshot data :  $data");
      print(">>>>>>>>>>>>>>>>>>> snapshot data.value :  ${data.value.length}");
      var length = data.value.length;
      var i = 0;
      data.value.forEach((key, value) {
        // print("-----------> inside loop data :  $value");
        if (i < length - numberOfValues) {
          i++;
        } else {
          var temp = value.split("@");
          print(temp);
          this.date.add(temp[0].toString());
          this.time.add(temp[1].toString());
          this.humidity.add(temp[2].toString());
          this.temperature.add(temp[3].toString());

          i++;
        }
      });
    });

    // var x = await FirebaseDatabase.instance
    //     .reference()
    //     .child("DataArray")
    //     .orderByChild('dateTime')
    //     .limitToLast(10);

    // print(">>>> (${date.length}) - date \n>>> $date");
    // print(">>>> (${time.length}) - time \n>>> $time");
    // print(">>>> (${humidity.length}) - humidity \n>>> $humidity");
    // print(">>>> (${temperature.length}) - temperature \n>>> $temperature");
    // var x = time;
    // x.sort();
    // print("\n >>>>>>>>>> sorted >>>>>> $x");

    isDataLoading.value = false;
  }
}
