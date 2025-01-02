import SwiftUI

struct CreateAppointmentView: View {
    @State private var doctorId: String = "12345" // Simula el ID del doctor autenticado
    @State private var patientId: String = ""
    @State private var appointmentDate = Date()
    @State private var patients: [User] = []
    @State private var isLoading = false
    @State private var message: String?

    var body: some View {
        VStack {
            Text("Crear Cita")
                .font(.largeTitle)
                .padding()

            if isLoading {
                ProgressView()
            } else {
                Form {
                    Picker("Seleccionar Paciente", selection: $patientId) {
                        ForEach(patients, id: \.id) { patient in
                            Text(patient.name).tag(patient.id)
                        }
                    }
                    
                    DatePicker("Fecha de la Cita", selection: $appointmentDate, displayedComponents: .date)

                    Button("Crear Cita") {
                        createAppointment()
                    }
                    .disabled(patientId.isEmpty)
                }   
            }

            if let message = message {
                Text(message)
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .onAppear {
            fetchPatients()
        }
    }

    func fetchPatients() {
        isLoading = true
        HTTPClient.shared.getPatients { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let patientsList):
                    self.patients = patientsList
                case .failure(let error):
                    self.message = "Error al cargar pacientes: \(error.localizedDescription)"
                }
            }
        }
    }

    func createAppointment() {
        isLoading = true
        let dateString = ISO8601DateFormatter().string(from: appointmentDate)
        HTTPClient.shared.createAppointment(doctorId: doctorId, patientId: patientId, date: dateString) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    message = "Cita creada con éxito"
                case .failure(let error):
                    message = "Error al crear cita: \(error.localizedDescription)"
                }
            }
        }
    }
}

func deleteAppointment(id: String) {
    HTTPClient.shared.deleteAppointment(id: id) { result in
        DispatchQueue.main.async {
            switch result {
            case .success:
                appointments.removeAll { $0.id == id }
            case .failure(let error):
                print("Error al eliminar cita: \(error.localizedDescription)")
            }
        }
    }
}
