import Foundation
import Combine

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

class LoginService {
    static let shared = LoginService() // 싱글톤으로 사용
    private let baseURL = Config.BASE_URL
    
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        print("baseURL::", baseURL)
        
        guard let url = URL(string: "\(baseURL)/api/auth/login") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = LoginRequest(email: email, password: password)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: LoginResponse.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
    }
}
