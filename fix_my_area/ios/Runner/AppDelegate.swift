import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    import GoogleMaps

    GMSServices.provideAPIKey("AIzaSyAFakTYk8VDGxa_BLRTHgMcTKbuqA3Avc8")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
