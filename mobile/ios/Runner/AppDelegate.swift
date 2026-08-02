import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let channelName = "examverse/backend_url"
  private let backendKey = "backend_url"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: channelName,
        binaryMessenger: controller.binaryMessenger
      )

      channel.setMethodCallHandler { call, result in
        let defaults = UserDefaults.standard
        switch call.method {
        case "load":
          result(defaults.string(forKey: self.backendKey))
        case "save":
          if let args = call.arguments as? [String: Any], let value = args["value"] as? String {
            defaults.set(value, forKey: self.backendKey)
          } else {
            defaults.removeObject(forKey: self.backendKey)
          }
          result(nil)
        case "clear":
          defaults.removeObject(forKey: self.backendKey)
          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
