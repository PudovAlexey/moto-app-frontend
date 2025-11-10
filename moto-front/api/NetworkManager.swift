import Apollo
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private(set) lazy var apollo: ApolloClient = {
        guard let url = URL(string: "http://localhost:3000/graphql") else {
            fatalError("Invalid GraphQL endpoint URL")
        }
        
        return ApolloClient(url: url)
    }()
}
