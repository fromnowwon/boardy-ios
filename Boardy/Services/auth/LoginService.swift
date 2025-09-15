import Foundation
import Combine

class LoginService {
    static let shared = LoginService()
    private init() {}

    /// 로그인 API 호출 + 토큰 저장
    func login(email: String, password: String) -> AnyPublisher<Void, Error> {
        let body = LoginRequest(email: email, password: password)
        
        return APIService.shared.post("/api/auth/login", body: body)
            .handleEvents(receiveOutput: { (response: LoginResponse) in
                KeychainHelper.standard.save(response.accessToken, forKey: "accessToken")
                KeychainHelper.standard.save(response.refreshToken, forKey: "refreshToken")
            })
            .map { _ in () } // 반환값을 Void로 변환
            .eraseToAnyPublisher()
    }

    /// 로그아웃 (토큰 삭제)
    func logout() {
        KeychainHelper.standard.delete(forKey: "accessToken")
        KeychainHelper.standard.delete(forKey: "refreshToken")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        print("로그아웃 완료 - 토큰 삭제 및 상태 초기화")
    }
}
