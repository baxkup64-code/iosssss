import SwiftUI

struct SettingsView: View {
    @AppStorage("streamingQuality") private var streamingQuality = "Normal"
    @AppStorage("downloadOverWifiOnly") private var wifiOnly = true
    private let qualities = ["Niedrig", "Normal", "Hoch"]

    var body: some View {
        NavigationStack {
            List {
                Section("Wiedergabe") {
                    Picker("Streaming-Qualität", selection: $streamingQuality) {
                        ForEach(qualities, id: \.self) { Text($0) }
                    }
                    Toggle("Nur über WLAN herunterladen", isOn: $wifiOnly)
                }

                Section("Musikquellen") {
                    LabeledContent("Spotify / SoundCloud", value: "Offizieller Player")
                    Text("Spotify- und SoundCloud-Links werden direkt über die offiziellen eingebetteten Player innerhalb der App wiedergegeben. Es ist kein Discord-Bot und kein Provider-Secret im iPhone-Projekt nötig.")
                        .font(Theme.Font.caption())
                        .foregroundStyle(Theme.Color.textSecondary)
                }

                Section("Über") {
                    LabeledContent("Version", value: "1.0.0")
                    Text("Keine Spotify- oder SoundCloud-Client-Secrets sind in der App enthalten. Provider-Wiedergabe läuft über die offiziellen Embed-Player.")
                        .font(Theme.Font.caption())
                        .foregroundStyle(Theme.Color.textSecondary)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.Color.background.ignoresSafeArea())
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
