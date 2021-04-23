import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:agro_cloud/home.dart';

class AuthController extends GetxController {
  GoogleSignInAccount userObj;
  GoogleSignIn googleSignIn = GoogleSignIn();

  check() {
    print("--------------------   im working ");
  }

  signIn() async {
    await googleSignIn.signIn().then((userData) {
      print(
          "--------------- autController/google signin caller-----------------------");
      print(userData);
      this.userObj = userData;
      Get.off(() => Home());
    }).catchError((e) {
      print(
          "\n--------------- autController/google signin ERROR-----------------------");
      print(e);

      print(
          "--------------- autController/google signin ERROR-----------------------\n");
    });
  }
}
