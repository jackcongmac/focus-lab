import AVFoundation

final class VoiceManager {
    static let shared = VoiceManager()

    private let synthesizer = AVSpeechSynthesizer()
    private var audioPlayer: AVAudioPlayer?

    // UserDefaults key shared with @AppStorage in GameView
    static let enabledKey = "focuslab.voiceEnabled"

    /// Returns true if voice is currently enabled (defaults to true on first launch).
    var isEnabled: Bool {
        UserDefaults.standard.object(forKey: Self.enabledKey) as? Bool ?? true
    }

    private init() {
        #if os(iOS)
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        #endif
    }

    /// Speaks `text` immediately, interrupting any in-progress utterance.
    /// Does nothing if voice is disabled or text is empty.
    func speak(_ text: String) {
        guard isEnabled, !text.isEmpty else { return }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate            = 0.45   // slightly slower than default (0.5) — child-friendly
        utterance.pitchMultiplier = 1.08   // warmer, less robotic
        utterance.voice           = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }

    /// Plays a bundled MP3 by filename (without extension).
    /// Falls back to TTS with `fallbackText` if the file is missing or fails to load.
    func playBundled(file: String, fallbackText: String) {
        guard isEnabled else { return }
        stop()
        if let url = Bundle.main.url(forResource: file, withExtension: "mp3"),
           let player = try? AVAudioPlayer(contentsOf: url) {
            audioPlayer = player
            audioPlayer?.play()
        } else {
            speak(fallbackText)
        }
    }

    /// Duration of the currently loaded audio file, or 0 if TTS / nothing loaded.
    /// Call this immediately after `playBundled` so the player is already initialised.
    var currentAudioDuration: TimeInterval { audioPlayer?.duration ?? 0 }

    /// Stops any in-progress speech or audio immediately.
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
