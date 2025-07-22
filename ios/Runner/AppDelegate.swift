import Flutter
import UIKit
import GoogleMaps
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyDKp5KwtiGq9niTaQso8WxfAaL6ZYtR3bs")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
