import Foundation
import Combine // 비동기 네트워크 처리

struct SignUpRequest: Codable { let email: String; let password: String; let nickname: String }
struct SignUpResponse: Codable { let id: Int; let email: String; let nickname: String; let role: String }

class SignUpService {
    static let shared = SignUpService()

    func signUp(email: String, password: String, nickname: String) -> AnyPublisher<SignUpResponse, Error> {
        let body = SignUpRequest(email: email, password: password, nickname: nickname)
        return APIService.shared.post("/api/auth/signup", body: body)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
