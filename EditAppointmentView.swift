import SwiftUI

struct EditAppointmentView: View {
    @State var appointment: Appointment
    @State private var newDate = Date()
    @State private var status = "pending"
    @State private var isLoading = false
    @State private var message: String?

    var body: some View {
        VStack {
            Form {
                DatePicker("Nueva Fecha", selection: $newDate, displayedComponents: .date)

                Picker("Estado", selection: $status) {
                    Text("Pendiente").tag("pending")
                    Text("Confirmada").tag("confirmed")
                    Text("Cancelada").tag("cancelled")
                }

                Button("Actualizar Cita") {
                    updateAppointment()
                }
            }

            if let message = message {
                Text(message)
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .onAppear {
            if let date = ISO8601DateFormatter().date(from: appointment.date) {
                newDate = date
            }
            status = appointment.status
        }
    }

    func updateAppointment() {
        isLoading = true
        let dateString = ISO8601DateFormatter().string(from: newDate)
        HTTPClient.shared.updateAppointment(id: appointment.id, date: dateString, status: status) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    message = "Cita actualizada correctamente"
                case .failure(let error):
                    message = "Error al actualizar cita: \(error.localizedDescription)"
                }
            }
        }
    }
}
