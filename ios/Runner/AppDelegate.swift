import UIKit
import Flutter
import Firebase        // Import Firebase
import GoogleMaps      // Import Google Maps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Google Maps with the API key
    GMSServices.provideAPIKey("AIzaSyCcgUJR0ydF-EoRepY5XODc6diNqI4MHgc")

    // Configure Firebase
    FirebaseApp.configure()

    // Register generated Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
