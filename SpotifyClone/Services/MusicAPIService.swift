import Foundation

/// Zero-config provider resolver.
///
/// The app does not contain Spotify/SoundCloud credentials and does not scrape
/// or extract protected media streams. Instead, when a user pastes an official
/// Spotify or SoundCloud track URL, the app renders the provider's official
/// player inside the app. This keeps playback on the provider side.
final class MusicAPIService {
    static let shared = MusicAPIService()

    func search(query: String) async -> SearchResults {
        guard let url = URL(string: query.trimmingCharacters(in: .whitespacesAndNewlines)),
              let host = url.host?.lowercased() else {
            return await iTunesAPIClient.search(query: query)
        }

        if let track = providerTrack(from: url, host: host) {
            return SearchResults(tracks: [track])
        }

        return await iTunesAPIClient.search(query: query)
    }

    func trendingHomeTracks() async -> [Track] {
        await iTunesAPIClient.trending()
    }

    private func providerTrack(from url: URL, host: String) -> Track? {
        if host == "open.spotify.com" || host.hasSuffix(".spotify.com") {
            let parts = url.path.split(separator: "/").map(String.init)
            guard let index = parts.firstIndex(of: "track"), parts.indices.contains(index + 1) else { return nil }
            let id = parts[index + 1]
            guard !id.isEmpty else { return nil }
            return Track(id: "spotify-\(id)", title: "Spotify Track", artistName: "Spotify",
                         albumName: "", artworkURL: nil, streamURL: nil, sourceURL: url,
                         duration: 0, source: .spotifyPreview)
        }

        if host == "soundcloud.com" || host.hasSuffix(".soundcloud.com") {
            let parts = url.path.split(separator: "/").map(String.init)
            guard parts.count >= 2 else { return nil }
            let title = parts.dropFirst().joined(separator: " / ")
            return Track(id: "soundcloud-\(url.absoluteString)", title: title.isEmpty ? "SoundCloud Track" : title,
                         artistName: parts.first ?? "SoundCloud", albumName: "", artworkURL: nil,
                         streamURL: nil, sourceURL: url, duration: 0, source: .soundcloud)
        }

        return nil
    }

    func sampleHomeTracks() -> [Track] {
        [
            Track(id: "demo-1", title: "Morning Drive", artistName: "Ambient Collective", albumName: "Sunrise Sessions",
                  artworkURL: URL(string: "https://picsum.photos/seed/morning/400"),
                  streamURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"), sourceURL: nil,
                  duration: 320, source: .local),
            Track(id: "demo-2", title: "Night Pulse", artistName: "Neon Skyline", albumName: "City Lights",
                  artworkURL: URL(string: "https://picsum.photos/seed/night/400"),
                  streamURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"), sourceURL: nil,
                  duration: 245, source: .local)
        ]
    }
}
