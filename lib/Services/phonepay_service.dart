// Step 1: Add phonepe_payment_sdk, crypto packages in your pubspec.yaml file .
// Step 2: Inside android’s build.gradle file add this code:
// allprojects {
//     repositories {
//         google()
//         mavenCentral()
//         maven {
//             url "https://phonepe.mycloudrepo.io/public/repositories/phonepe-intentsdk-android"
//         }
//     }
// }

import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonepayService {
  static Future<bool> init(
      String environment, String appId, String merchantId, bool enableLogging) async {
    try {
      bool result = await PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging);
      print('PhonePe SDK Initialized - $result');
      return result;
    } catch (error) {
      print('PhonePe SDK Initialization Error: $error');
      return false; 
    }
  }
}
