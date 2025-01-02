import Foundation

struct HTTPClient {
    static let shared = HTTPClient()
    private let baseURL = "http://localhost:5000/api"

    func request<T: Decodable>(endpoint: String, method: String, body: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 400, userInfo: nil)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // CRUD Operations
    func getAppointments(completion: @escaping (Result<[Appointment], Error>) -> Void) {
        request(endpoint: "/appointments", method: "GET", completion: completion)
    }

    func createAppointment(doctorId: String, patientId: String, date: String, completion: @escaping (Result<Appointment, Error>) -> Void) {
        let body: [String: Any] = ["doctor": doctorId, "patient": patientId, "date": date]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "Invalid JSON", code: 400, userInfo: nil)))
            return
        }
        request(endpoint: "/appointments", method: "POST", body: jsonData, completion: completion)
    }

    func updateAppointment(id: String, date: String, status: String, completion: @escaping (Result<Appointment, Error>) -> Void) {
        let body: [String: Any] = ["date": date, "status": status]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "Invalid JSON", code: 400, userInfo: nil)))
            return
        }
        request(endpoint: "/appointments/\(id)", method: "PUT", body: jsonData, completion: completion)
    }

    func deleteAppointment(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        request(endpoint: "/appointments/\(id)", method: "DELETE") { (result: Result<[String: String], Error>) in
            switch result {
            case .success(let response):
                completion(.success(response["message"] ?? "Deleted successfully"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
