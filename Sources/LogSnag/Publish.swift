import Foundation

///Options for publishing LogSnag events
public struct PublishOptions: Codable, Equatable {
    let channel: String
    let description: String?
    let event: String
    let icon: String?
    let notify: Bool?
    var project: String?
    
    /// Creates a `PublishOptions` object to send to LogSnag
    /// - Parameters:
    ///   - channel: Channel name
    ///   - event: Event name
    ///   - description: Event description (default `nil`)
    ///   - icon: Event icon (emoji)  (default `nil`)
    ///   - notify: Send push notification  (default `nil`)
    public init(
        channel: String,
        event: String,
        description: String? = nil,
        icon: String? = nil,
        notify: Bool? = nil
    ) {
        self.channel = channel
        self.event = event
        self.description = description
        self.icon = icon
        self.notify = notify
    }
}
