import Foundation
import MultipeerConnectivity.MCPeerID

extension MCPeerID {

    static func fetchOrCreate(with config: BonjourSession.Configuration) -> MCPeerID {
        self.fetchExisting(with: config) ?? .init(displayName: config.peerName)
    }
    private static func fetchExisting(with config: BonjourSession.Configuration) -> MCPeerID? {
        guard let data = config.defaults.data(forKey: Self.defaultsKey)
        else { return nil }
        do {
            let peer = try NSKeyedUnarchiver.unarchivedObject(ofClass: MCPeerID.self, from: data)
            guard peer?.displayName == config.peerName
            else { return nil }
            return peer
        } catch {
            return nil
        }
    }
    private static let defaultsKey = "_bonjour.peerID"


}

#if os(iOS) || os(tvOS)
import UIKit

public extension MCPeerID {
    static var defaultDisplayName: String { UIDevice.current.name }
}

#else

//import Cocoa

public extension MCPeerID {
    static var defaultDisplayName: String { "Unknown Mac" }
}

#endif
