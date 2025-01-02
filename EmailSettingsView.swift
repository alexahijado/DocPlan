struct EmailSettingsView: View {
    @State private var senderEmail: String = ""
    @State private var message: String?

    var body: some View {
        VStack {
            Text("Configurar Correo de Envío")
                .font(.title)
                .padding()

            TextField("Correo Electrónico", text: $senderEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Guardar") {
                saveSenderEmail()
            }

            if let message = message {
                Text(message)
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
    }

    func saveSenderEmail() {
        guard !senderEmail.isEmpty else {
            message = "El correo no puede estar vacío"
            return
        }

        // Simula una solicitud al backend
        let url = URL(string: "http://localhost:5000/api/auth/updateEmail")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["senderEmail": senderEmail])

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    message = "Error al guardar: \(error.localizedDescription)"
                } else {
                    message = "Correo guardado correctamente"
                }
            }
        }.resume()
    }
}
