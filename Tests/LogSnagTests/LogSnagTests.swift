import Combine
@testable import LogSnag
import XCTest

class MockDataClient: LogSnagDataClientProvider {
    var logs: [PublishOptions] = []
    
    private lazy var jsonDecoder = JSONDecoder()
    
    init() {}
    
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    @available(tvOS 15.0, *)
    @available(watchOS 8.0, *)
    func data(for request: URLRequest) async throws -> Bool {
        guard let data = request.httpBody else {
            XCTFail()
            return false
        }
        
        var log = try jsonDecoder.decode(PublishOptions.self, from: data)
        log.project = nil
        
        logs.append(log)
        return true
    }
    
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<Bool, Error> {
        guard let data = request.httpBody else {
            XCTFail()
            return Just(false)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        do {
            var log = try jsonDecoder.decode(PublishOptions.self, from: data)
            log.project = nil
            
            logs.append(log)
            
            return Just(true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            XCTFail(error.localizedDescription)
            
            return Just(false)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

class LogSnagTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    @available(tvOS 15.0, *)
    @available(watchOS 8.0, *)
    func testAsyncAwaitClient() async throws {
        let dataClient = MockDataClient()
        let client = LogSnagClient(
            dataClient: dataClient,
            project: "test-project",
            token: "TEST-TOKEN"
        )
        
        let success = try await client.asyncPublish(
            options: PublishOptions(
                channel: "test-channel",
                event: name
            )
        )
        
        XCTAssertTrue(success)
        
        XCTAssertEqual(
            dataClient.logs,
            [
                PublishOptions(channel: "test-channel", event: name, description: nil, icon: nil)
            ]
        )
    }
    
    func testCombineClient() {
        let dataClient = MockDataClient()
        let client = LogSnagClient(
            dataClient: dataClient,
            project: "test-project",
            token: "TEST-TOKEN"
        )
    
        var success: Bool = false
        
        client.publish(
            options: PublishOptions(
                channel: "test-channel",
                event: name
            )
        )
        .receive(on: ImmediateScheduler.shared)
        .sink(
            receiveCompletion: { _ in },
            receiveValue: { success = $0 }
        )
        .store(in: &cancellables)
        
        XCTAssertTrue(success)
        
        XCTAssertEqual(
            dataClient.logs,
            [
                PublishOptions(channel: "test-channel", event: name, description: nil, icon: nil)
            ]
        )
    }
}
