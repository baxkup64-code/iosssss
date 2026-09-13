import SwiftUI
import WebKit

struct ProviderPlayerView: UIViewRepresentable {
    let trackURL: URL
    let source: TrackSource

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = []
        }
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.allowsBackForwardNavigationGestures = false
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let embedURL: URL?
        switch source {
        case .spotifyPreview:
            let parts = trackURL.path.split(separator: "/").map(String.init)
            if let i = parts.firstIndex(of: "track"), parts.indices.contains(i + 1) {
                embedURL = URL(string: "https://open.spotify.com/embed/track/\(parts[i + 1])?theme=0")
            } else {
                embedURL = nil
            }
        case .soundcloud:
            var components = URLComponents(string: "https://w.soundcloud.com/player/")!
            components.queryItems = [
                URLQueryItem(name: "url", value: trackURL.absoluteString),
                URLQueryItem(name: "auto_play", value: "true"),
                URLQueryItem(name: "hide_related", value: "true"),
                URLQueryItem(name: "show_comments", value: "false"),
                URLQueryItem(name: "show_user", value: "true"),
                URLQueryItem(name: "show_reposts", value: "false"),
                URLQueryItem(name: "show_teaser", value: "false")
            ]
            embedURL = components.url
        case .local:
            embedURL = nil
        }

        guard let embedURL else { return }
        let request = URLRequest(url: embedURL, cachePolicy: .useProtocolCachePolicy)
        if webView.url != embedURL {
            webView.load(request)
        }
    }
}
