import UIKit

enum TermsURL {
    case personalInformation
    case serviceUse
    
    var url: String {
        switch self {
        case .personalInformation:
            return "https://early-badge-c69.notion.site/d687ee3399a44fbcbc577ee3a73a54e4"
        case .serviceUse:
            return "https://equal-kiwi-602.notion.site/9021bea8cf1841fc8a83d26a06c8e72c"
        }
    }
}

extension TermsURL {
    static func openURLSafari(type: TermsURL) {
        guard let openUrl = URL(string: type.url), UIApplication.shared.canOpenURL(openUrl) else { return }
        UIApplication.shared.open(openUrl)
    }
}
