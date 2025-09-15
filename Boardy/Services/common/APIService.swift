import Foundation
import Combine

struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

struct RefreshTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

final class APIService {
    static let shared = APIService()
    private let baseURL = Config.BASE_URL
    private init() {}
    
    private var refreshCancellable: AnyCancellable?

    /// GET 요청
    func get<T: Decodable>(_ path: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        addAuthHeader(&request)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryCatch { [weak self] error -> AnyPublisher<(data: Data, response: URLResponse), Error> in
                guard let self = self else {
                    throw error
                }
                return self.handle401(for: request)
            }
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    /// POST 요청
    func post<T: Decodable, U: Encodable>(_ path: String, body: U) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeader(&request)

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryCatch { [weak self] error -> AnyPublisher<(data: Data, response: URLResponse), Error> in
                guard let self = self else { throw error }
                return self.handle401(for: request)
            }
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }


    /// Authorization 헤더 추가
    private func addAuthHeader(_ request: inout URLRequest) {
        if let token = KeychainHelper.standard.read(forKey: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
    
    /// 401 발생 시 Refresh Token으로 재발급 후 요청 재시도
    private func handle401(for originalRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        return TokenManager.shared.refreshAccessToken()
            .flatMap { success -> AnyPublisher<(data: Data, response: URLResponse), Error> in
                guard success else {
                    return Fail(error: URLError(.userAuthenticationRequired))
                        .eraseToAnyPublisher()
                }

                var retryRequest = originalRequest
                self.addAuthHeader(&retryRequest)
                return URLSession.shared.dataTaskPublisher(for: retryRequest)
                    .map { ($0.data, $0.response) }
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
