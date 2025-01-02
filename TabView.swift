import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                AppointmentsListView()
                    .tabItem {
                        Label("Citas", systemImage: "list.bullet")
                    }
                CreateAppointmentView()
                    .tabItem {
                        Label("Nueva Cita", systemImage: "plus")
                    }
            }
        }
    }
}
