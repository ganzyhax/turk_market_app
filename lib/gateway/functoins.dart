import 'dart:io';

import 'package:device_info/device_info.dart';

class HelpFunctions {
  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String res = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String androidId = androidInfo.androidId;
      res = androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      String iosId = iosInfo.identifierForVendor; // iOS device ID
      res = iosId;
    }
    return res;
  }
}
