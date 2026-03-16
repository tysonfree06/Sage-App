import UIKit
import Flutter
import StoreKit

//Original
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

//New
// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     let controller = window?.rootViewController as! FlutterViewController
//     let channel = FlutterMethodChannel(name: "storekit_helper",
//                                        binaryMessenger: controller.binaryMessenger)

//     channel.setMethodCallHandler { call, result in
//       if call.method == "getJWSTokens" {
//         if #available(iOS 15.0, *) {
//           Task {
//             let tokens = await self.fetchJWSTokens()
//             result(tokens)
//           }
//         } else {
//           result(FlutterError(code: "UNAVAILABLE",
//                               message: "StoreKit2 requires iOS 15+",
//                               details: nil))
//         }
//       } else {
//         result(FlutterMethodNotImplemented)
//       }
//     }
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }

//   @available(iOS 15.0, *)
//   func fetchJWSTokens() async -> [String] {
//     var jwsTokens: [String] = []
//     for await verificationResult in Transaction.currentEntitlements {
//       if case .verified(let transaction) = verificationResult {
//         jwsTokens.append(transaction.jwsRepresentation)
//       }
//     }
//     return jwsTokens
//   }
// }

//New (Merged)

// @available(iOS 15.0, *)
// typealias SK2Transaction = StoreKit.Transaction

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     // ✅ Keep Flutter plugin registration
//     GeneratedPluginRegistrant.register(with: self)
    
//     // ✅ Add your custom StoreKit MethodChannel
//     let controller = window?.rootViewController as! FlutterViewController
//     let channel = FlutterMethodChannel(
//       name: "storekit_helper",
//       binaryMessenger: controller.binaryMessenger
//     )

//     channel.setMethodCallHandler { call, result in
//       if call.method == "getJWSTokens" {
//         if #available(iOS 15.0, *) {
//           Task {
//             let tokens = await self.fetchJWSTokens()
//             result(tokens)
//           }
//         } else {
//           result(FlutterError(
//             code: "UNAVAILABLE",
//             message: "StoreKit2 requires iOS 15+",
//             details: nil
//           ))
//         }
//       } else {
//         result(FlutterMethodNotImplemented)
//       }
//     }
    
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }

//   @available(iOS 15.0, *)
//   func fetchJWSTokens() async -> [String] {
//     var jwsTokens: [String] = []
//     for await verificationResult in Transaction.currentEntitlements {
//       if case .verified(let transaction) = verificationResult {
//         // Explicitly tell compiler it's StoreKit.Transaction
//         let sk2Transaction: SK2Transaction = transaction
//         jwsTokens.append(sk2Transaction.jwsRepresentation)
//       }
//     }
//     return jwsTokens
//   }
// }
