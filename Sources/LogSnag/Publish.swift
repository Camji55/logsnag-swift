import Foundation

///Options for publishing LogSnag events
public struct PublishOptions: Codable, Equatable {
    let channel: String
    let description: String?
    let event: String
    let icon: String?
    let notify: Bool?
    var project: String?
    var userId: String?
    var autoAddUserId: Bool?
    
    /// Creates a `PublishOptions` object to send to LogSnag
    /// - Parameters:
    ///   - channel: Channel name
    ///   - event: Event name
    ///   - description: Event description (default `nil`)
    ///   - icon: Event icon (emoji)  (default `nil`)
    ///   - notify: Send push notification  (default `nil`)
    ///   - userId: User ID  (default `nil`)
    ///   - autoAddUserId: Automatically add user ID to event  (default `nil`)
    public init(
        channel: String,
        event: String,
        description: String? = nil,
        icon: String? = nil,
        notify: Bool? = nil,
        userId: String? = nil,
        autoAddUserId: Bool? = nil
    ) {
        self.channel = channel
        self.event = event
        self.description = description
        self.icon = icon
        self.notify = notify
        self.userId = userId
        self.autoAddUserId = autoAddUserId
    }
    
    enum CodingKeys: String, CodingKey {
         case channel, description, event, icon, notify, project
         case userId = "user_id"
         case autoAddUserId
     }
}
