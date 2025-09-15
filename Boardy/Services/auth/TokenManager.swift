import Foundation
import Combine

final class TokenManager {
    static let shared = TokenManager()

    private init() {}

    func refreshAccessToken() -> AnyPublisher<Bool, Never> {
        guard let refreshToken = KeychainHelper.standard.read(forKey: "refreshToken") else {
            return Just(false).eraseToAnyPublisher()
        }

        let requestBody = RefreshTokenRequest(refreshToken: refreshToken)
        return APIService.shared.post("/api/auth/refresh", body: requestBody)
            .map { (response: RefreshTokenResponse) in
                KeychainHelper.standard.save(response.accessToken, forKey: "accessToken")
                KeychainHelper.standard.save(response.refreshToken, forKey: "refreshToken")
                return true
            }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    func clearTokens() {
        KeychainHelper.standard.clearAll()
    }
}
