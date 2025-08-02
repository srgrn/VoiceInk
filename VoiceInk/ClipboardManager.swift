import SwiftUI
import AppKit

struct ClipboardManager {
    // Custom pasteboard type for VoiceInk transcriptions
    static let voiceInkPasteboardType = NSPasteboard.PasteboardType("com.prakashjoshipax.VoiceInk.transcription")
    
    enum ClipboardError: Error {
        case copyFailed
        case accessDenied
    }
    
    static func copyToClipboard(_ text: String) -> Bool {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        let item = NSPasteboardItem()
        item.setString(text, forType: .string)
//        item.setString(text, forType: ClipboardManager.voiceInkPasteboardType)
        return pasteboard.writeObjects([item])
    }
    
    static func getClipboardContent() -> String? {
        return NSPasteboard.general.string(forType: .string)
    }
}

struct ClipboardMessageModifier: ViewModifier {
    @Binding var message: String
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if !message.isEmpty {
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                            .transition(.opacity)
                            .animation(.easeInOut, value: message)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
            )
    }
}

extension View {
    func clipboardMessage(_ message: Binding<String>) -> some View {
        self.modifier(ClipboardMessageModifier(message: message))
    }
}
