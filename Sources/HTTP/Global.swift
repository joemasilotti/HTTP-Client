import Foundation

public enum Global {
    public static var requestLoader: RequestLoader = URLSession.shared

    static func resetToDefaults() {
        requestLoader = URLSession.shared
    }
}
