import Foundation
import Combine // 비동기 네트워크 처리

struct SignUpSuccess: Codable {
    let id: Int
    let email: String
    let nickname: String
    let role: String
}

struct SignUpError: Codable {
    let message: String
}

class SignUpService {
    static let shared = SignUpService() // 전역에서 공유하기 위해 싱글톤 패턴 사용
    private let baseURL = Config.BASE_URL
    
    func signUp(email: String, password: String, nickname: String) -> AnyPublisher<SignUpSuccess, Error> {
        guard let url = URL(string: "\(baseURL)/api/auth/signup") else {
            // URL이 잘못되었으면 실패 처리
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "nickname": nickname
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        // Combine으로 네트워크 요청
        return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    if let response = output.response as? HTTPURLResponse, !(200..<300).contains(response.statusCode) {
                        if let errorResponse = try? JSONDecoder().decode(SignUpError.self, from: output.data) {
                            throw NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.message])
                        } else {
                            throw URLError(.badServerResponse)
                        }
                    }
                    return output.data
                }
                .decode(type: SignUpSuccess.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
    }
}
