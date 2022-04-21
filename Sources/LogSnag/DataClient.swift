import Combine
import Foundation

protocol LogSnagDataClientProvider {
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    @available(tvOS 15.0, *)
    @available(watchOS 8.0, *)
    func data(for request: URLRequest) async throws -> Bool
    
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<Bool, Error>
}

struct LogSnagDataClient: LogSnagDataClientProvider {
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    @available(tvOS 15.0, *)
    @available(watchOS 8.0, *)
    func data(for request: URLRequest) async throws -> Bool {
        let (_, response) = try await URLSession.shared.data(for: request)
        
        return try handleResponse(response: response)
    }
    
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<Bool, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { _, response in
                try handleResponse(response: response)
            }
            .eraseToAnyPublisher()
    }
    
    private func handleResponse(response: URLResponse) throws -> Bool {
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.cannotParseResponse)
        }
        
        guard response.statusCode >= 200, response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        return true
    }
}
