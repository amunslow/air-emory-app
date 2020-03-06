import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAAcHpKKntYmOIOzNKu2D-GWp-HVnZNgxs")
    //GMSPlacesClient.provideAPIKey("AIzaSyAAcHpKKntYmOIOzNKu2D-GWp-HVnZNgxs")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
