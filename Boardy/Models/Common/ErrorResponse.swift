import Foundation

struct ErrorResponse: Codable, Error {
    let code: Int?
    let message: String?
}
