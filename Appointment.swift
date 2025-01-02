import Foundation

struct Appointment: Codable {
    let id: String
    let doctor: User
    let patient: User
    let date: String
    let status: String
}

struct User: Codable {
    let id: String
    let name: String
    let email: String
}
