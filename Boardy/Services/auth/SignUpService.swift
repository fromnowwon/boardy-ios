import Foundation
import Combine

class SignUpService {
    static let shared = SignUpService()

    func signUp(email: String, password: String, nickname: String) -> AnyPublisher<SignUpResponse, Error> {
        let body = SignUpRequest(email: email, password: password, nickname: nickname)
        return APIService.shared.post("/api/auth/signup", body: body)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
