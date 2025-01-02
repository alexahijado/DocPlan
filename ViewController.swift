import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        HTTPClient.shared.login(email: "test@example.com", password: "password123") { result in
            switch result {
            case .success(let token):
                print("Login successful. Token: \(token)")
                self.fetchAppointments()
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }

    func fetchAppointments() {
        HTTPClient.shared.getAppointments { result in
            switch result {
            case .success(let appointments):
                print("Fetched appointments: \(appointments)")
            case .failure(let error):
                print("Failed to fetch appointments: \(error.localizedDescription)")
            }
        }
    }
}
