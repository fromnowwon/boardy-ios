import Foundation
import Combine

final class AuthService {
    static let shared = AuthService()
    
    func validateToken() -> AnyPublisher<Bool, Error> {
        print("토큰 검증: ", KeychainHelper.standard.read(forKey: "accessToken"))
        guard let token = KeychainHelper.standard.read(forKey: "accessToken") else {
            return Just(false)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: URL(string: "\(Config.BASE_URL)/api/auth/validate")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Bool.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
