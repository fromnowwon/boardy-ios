import Foundation

struct SignUpResponse: Codable {
    let id: Int
    let email: String
    let nickname: String
    let role: String
}
