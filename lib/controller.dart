import 'package:get/get.dart';

class Controller extends GetxController{
  var username = "".obs;
  setUsername(String u) => username=RxString(u);
}