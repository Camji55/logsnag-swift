import Combine
import Foundation

/// LogSnag Client
public class LogSnagClient {
    
    private let dataClient: LogSnagDataClientProvider
    private let project: String
    private let token: String
    
    private lazy var jsonEncoder = JSONEncoder()
    
    init(
        dataClient: LogSnagDataClientProvider,
        project: String,
        token: String
    ) {
        self.dataClient = dataClient
        self.project = project
        self.token = token
    }
    
    /// Construct a new LogSnag instance
    /// - Parameters:
    /// - project: Your project slug
    /// - token: Your API token. See docs.logsnag.com for details
    public init(
        project: String,
        token: String
    ) {
        self.project = project
        self.token = token
        self.dataClient = LogSnagDataClient()
    }
    
    private func createAuthorizationHeader() -> String {
        "Bearer \(token)"
    }
    
    private func request(options: PublishOptions) -> URLRequest {
        var request = URLRequest(url: URL(string: Constants.logSnagEndpoint)!)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": createAuthorizationHeader()
        ]
        
        var options = options
        options.project = project
        
        if options.autoAddUserId == true, options.userId == nil  {
            options.userId = generateOrRetrieveUserId()
            options.autoAddUserId = nil
        }
        
        request.httpBody = try? jsonEncoder.encode(options)
        
        return request
    }
    
    /// Publish a new event to LogSnag
    /// - Parameter options
    /// - Returns: true when successfully published
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    @available(tvOS 15.0, *)
    @available(watchOS 8.0, *)
    @discardableResult
    public func asyncPublish(options: PublishOptions) async throws -> Bool {
        try await dataClient.data(for: request(options: options))
    }
    
    /// Publish a new event to LogSnag
    /// - Parameter options
    /// - Returns: Combine `Publisher`
    public func publish(options: PublishOptions) -> AnyPublisher<Bool, Error> {
        dataClient.dataTaskPublisher(for: request(options: options))
    }
    
    private func generateOrRetrieveUserId() -> String {
        // Retrieve the user ID if it's already been generated.
        if let existingId = UserDefaults.standard.string(forKey: "logSnagUserId") {
            return existingId
        } else {
            // Generate a new user ID if one does not exist, then store it for future use.
            let newId = UUID().uuidString
            UserDefaults.standard.setValue(newId, forKey: "logSnagUserId")
            return newId
        }
    }
}
