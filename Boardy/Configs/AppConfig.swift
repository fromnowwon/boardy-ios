import Foundation

struct Config {
    static let BASE_URL: String = {
        guard let host = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              !host.isEmpty else {
            fatalError("BASE_URL이 설정되어 있지 않습니다.")
        }
        // 호출할 때 https:// 붙여서 반환
        return "https://\(host)"
    }()
}
