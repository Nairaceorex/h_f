import 'package:device_info_plus/device_info_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> checkIsEmu() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  var phoneModel = androidInfo.model;
  var buildProduct = androidInfo.product;
  var buildHardware = androidInfo.hardware;
  var result = (androidInfo.fingerprint.startsWith("generic") ||
      phoneModel.contains("google_sdk") ||
      phoneModel.contains("droid4x") ||
      phoneModel.contains("Emulator") ||
      phoneModel.contains("Android SDK built for x86") ||
      androidInfo.manufacturer.contains("Genymotion") ||
      buildHardware == "goldfish" ||
      buildHardware == "vbox86" ||
      buildProduct == "sdk" ||
      buildProduct == "google_sdk" ||
      buildProduct == "sdk_x86" ||
      buildProduct == "vbox86p" ||
      androidInfo.brand.contains('google') ||
      androidInfo.board.toLowerCase().contains("nox") ||
      androidInfo.bootloader.toLowerCase().contains("nox") ||
      buildHardware.toLowerCase().contains("nox") ||
      !androidInfo.isPhysicalDevice ||
      buildProduct.toLowerCase().contains("nox"));
  if (result) return true;
  result = result ||
      (androidInfo.brand.startsWith("generic") &&
          androidInfo.device.startsWith("generic"));
  if (result) return true;
  result = result || ("google_sdk" == buildProduct);
  return result;
}

Future<bool> checkConnection() async {
  bool result = await InternetConnectionChecker().hasConnection;
  return result;
}
