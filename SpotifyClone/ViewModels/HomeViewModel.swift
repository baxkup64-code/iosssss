import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var recentlyPlayed: [Track] = []
    @Published var madeForYou: [Track] = []
    @Published var newReleases: [Album] = []
    @Published var isLoading = false

    private let api = MusicAPIService.shared

    func load() async {
        isLoading = true
        defer { isLoading = false }

        // iTunes needs no API key at all, so this works immediately.
        let trending = await api.trendingHomeTracks()
        if !trending.isEmpty {
            recentlyPlayed = trending.shuffled()
            madeForYou = Array(trending.reversed())
        } else {
            // Offline fallback so Home is never empty.
            let demo = api.sampleHomeTracks()
            recentlyPlayed = demo.shuffled()
            madeForYou = demo.reversed()
        }

        newReleases = []
    }
}
