// import 'dart:io';

// import 'package:appsflyer_sdk/appsflyer_sdk.dart';
// import 'package:app_tracking_transparency/app_tracking_transparency.dart';

// import 'utils.dart';

// class AppsFlyerService {
//   late AppsflyerSdk appsflyerSdk;
//   String? appsflyerId;

//   Future<void> initAppsFlyer({
//     required String devKey,
//     required String appId,
//     bool isDebug = false,
//   }) async {
//     try {
//       if (Platform.isIOS) {
//         final TrackingStatus status =
//             await AppTrackingTransparency.trackingAuthorizationStatus;

//         if (status == TrackingStatus.notDetermined) {
//           await AppTrackingTransparency.requestTrackingAuthorization();
//         }
//         await AppTrackingTransparency.getAdvertisingIdentifier();
//       }

//       final AppsFlyerOptions options = AppsFlyerOptions(
//         afDevKey: devKey,
//         appId: appId,
//         showDebug: isDebug,
//         timeToWaitForATTUserAuthorization: 15,
//       );

//       appsflyerSdk = AppsflyerSdk(options);

//       await appsflyerSdk.initSdk(
//         registerConversionDataCallback: true,
//         registerOnAppOpenAttributionCallback: true,
//         registerOnDeepLinkingCallback: true,
//       );

//       appsflyerSdk.startSDK();

//       // Получение appsflyerId
//       appsflyerId = await appsflyerSdk.getAppsFlyerUID();
//       logger('AppsFlyer ID: $appsflyerId');

//       appsflyerSdk.onInstallConversionData((data) {
//         logger('Conversion Data: $data');
//       });

//       appsflyerSdk.onAppOpenAttribution((data) {
//         logger('App Open Attribution: $data');
//       });

//       logger('AppsFlyer initialized successfully');
//     } catch (e) {
//       logger('Error initializing AppsFlyer: $e');
//     }
//   }

//   void logEvent(String eventName, Map eventValues) {
//     appsflyerSdk.logEvent(eventName, eventValues);
//   }

//   String? getAppsFlyerId() => appsflyerId;
// }
