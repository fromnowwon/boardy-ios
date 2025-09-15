import Foundation

struct SignUpRequest: Codable {
    let email: String
    let password: String
    let nickname: String
}
