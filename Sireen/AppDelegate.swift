import UIKit
import ParseSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Load Environment Variables
        loadEnvironmentVariables()

        // Initialize Parse SDK
        let appId = String(cString: getenv("APPLICATION_ID"))
        let clientKey = String(cString: getenv("CLIENT_KEY"))
        let serverURL = URL(string: "https://parseapi.back4app.com")!
        ParseSwift.initialize(applicationId: appId,
                              clientKey: clientKey,
                              serverURL: serverURL)

        return true
    }

    private func loadEnvironmentVariables() {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            print("Environment file not found.")
            return
        }

        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let variables = data.components(separatedBy: .newlines)
            
            for variable in variables {
                let keyValuePair = variable.components(separatedBy: "=")
                if keyValuePair.count == 2 {
                    let key = keyValuePair[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let value = keyValuePair[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    setenv(key, value, 1)
                }
            }
        } catch {
            print("Error loading .env file: \(error)")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
    }
}
