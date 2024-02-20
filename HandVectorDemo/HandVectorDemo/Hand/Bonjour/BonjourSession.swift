import Foundation
import MultipeerConnectivity
import os.log

public typealias InvitationCompletionHandler = (_ result: Result<Peer, Error>) -> Void

final public class BonjourSession: NSObject {

    // MARK: - Type Definitions

    public struct Configuration {

        public enum Invitation {
            case automatic
            case custom((Peer) throws -> (context: Data, timeout: TimeInterval)?)
            case none
        }

        public struct Security {

            public typealias InvitationHandler = (Peer, Data?, @escaping (Bool) -> Void) -> Void
            public typealias CertificateHandler = ([Any]?, MCPeerID, @escaping (Bool) -> Void) -> Void

            public var identity: [Any]?
            public var encryptionPreference: MCEncryptionPreference
            public var invitationHandler: InvitationHandler
            public var certificateHandler: CertificateHandler

            public init(identity: [Any]?,
                        encryptionPreference: MCEncryptionPreference,
                        invitationHandler: @escaping InvitationHandler,
                        certificateHandler: @escaping CertificateHandler) {
                self.identity = identity
                self.encryptionPreference = encryptionPreference
                self.invitationHandler = invitationHandler
                self.certificateHandler = certificateHandler
            }

            public static let `default` = Security(identity: nil,
                                                   encryptionPreference: .none,
                                                   invitationHandler: { _, _, handler in handler(true) },
                                                   certificateHandler:  { _, _, handler in handler(true) })

        }

        public var serviceType: String
        public var peerName: String
        public var defaults: UserDefaults
        public var security: Security
        public var invitation: Invitation
        
        public init(serviceType: String,
                    peerName: String,
                    defaults: UserDefaults,
                    security: Security,
                    invitation: Invitation) {
            precondition(peerName.utf8.count <= 63, "peerName can't be longer than 63 bytes")

            self.serviceType = serviceType
            self.peerName = peerName
            self.defaults = defaults
            self.security = security
            self.invitation = invitation
        }

        public static let `default` = Configuration(serviceType: "Bonjour",
                                                    peerName: MCPeerID.defaultDisplayName,
                                                    defaults: .standard,
                                                    security: .default,
                                                    invitation: .automatic)
    }


    public enum BonjourSessionError: LocalizedError {
        case connectionToPeerfailed

        var localizedDescription: String {
            switch self {
            case .connectionToPeerfailed: return "Failed to connect to peer."
            }
        }
    }

    public struct Usage: OptionSet {
        public let rawValue: UInt

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public static let receive = Usage(rawValue: 0x1)
        public static let transmit = Usage(rawValue: 0x2)
        public static let combined: Usage = [.receive, .transmit]
    }

    // MARK: - Public Properties

    public let usage: Usage
    public let configuration: Configuration
    public let localPeerID: MCPeerID

    public private(set) var availablePeers: Set<Peer> = [] {
        didSet {
            guard self.availablePeers != oldValue
            else { return }
            self.sessionQueue.async {
                self.onAvailablePeersDidChange?(Array(self.availablePeers))
            }
        }
    }
    public var connectedPeers: Set<Peer> { self.availablePeers.filter { $0.isConnected } }

    // MARK: - Handlers

    public var onStartReceiving: ((_ resourceName: String, _ peer: Peer) -> Void)?
    public var onReceiving: ((_ resourceName: String, _ peer: Peer, _ progress: Double) -> Void)?
    public var onFinishReceiving: ((_ resourceName: String, _ peer: Peer, _ localURL: URL?, _ error: Error?) -> Void)?
    public var onReceive: ((_ data: Data, _ peer: Peer) -> Void)?
    public var onPeerDiscovery: ((_ peer: Peer) -> Void)?
    public var onPeerLoss: ((_ peer: Peer) -> Void)?
    public var onPeerConnection: ((_  peer: Peer) -> Void)?
    public var onPeerDisconnection: ((_  peer: Peer) -> Void)?
    public var onAvailablePeersDidChange: ((_ peers: [Peer]) -> Void)?

    // MARK: - Private Properties

    private lazy var session: MCSession = {
        let session = MCSession(peer: self.localPeerID,
                                securityIdentity: self.configuration.security.identity,
                                encryptionPreference: self.configuration.security.encryptionPreference)
        session.delegate = self
        return session
    }()

    private lazy var browser: MCNearbyServiceBrowser = {
        let browser = MCNearbyServiceBrowser(peer: self.localPeerID,
                                             serviceType: self.configuration.serviceType)
        browser.delegate = self
        return browser
    }()

    private lazy var advertiser: MCNearbyServiceAdvertiser = {
        let advertiser = MCNearbyServiceAdvertiser(peer: self.localPeerID,
                                                   discoveryInfo: nil,
                                                   serviceType: self.configuration.serviceType)
        advertiser.delegate = self
        return advertiser
    }()

    private var invitationCompletionHandlers: [MCPeerID: InvitationCompletionHandler] = [:]
    private var progressWatchers: [String: ProgressWatcher] = [:]
    private let sessionQueue = DispatchQueue(label: "Bonjour.Session", qos: .userInteractive)


    // MARK: - Init

    public init(usage: Usage = .combined,
                configuration: Configuration = .default) {
        self.usage = usage
        self.configuration = configuration
        self.localPeerID = MCPeerID.fetchOrCreate(with: configuration)
    }

    public func start() {
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .debug,
               #function)
        #endif
        
        if self.usage.contains(.receive) {
            self.advertiser.startAdvertisingPeer()
        }
        if self.usage.contains(.transmit) {
            self.browser.startBrowsingForPeers()
        }
    }
    
    public func stop() {
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .debug,
               #function)
        #endif
        
        if self.usage.contains(.receive) {
            self.advertiser.stopAdvertisingPeer()
        }
        if self.usage.contains(.transmit) {
            self.browser.stopBrowsingForPeers()
        }
    }

    public func invite(_ peer: Peer,
                       with context: Data?,
                       timeout: TimeInterval,
                       completion: InvitationCompletionHandler?) {
        self.invitationCompletionHandlers[peer.peerID] = completion

        self.browser.invitePeer(peer.peerID,
                                to: self.session,
                                withContext: context,
                                timeout: timeout)
    }

    public func broadcast(_ data: Data) {
        guard !self.session.connectedPeers.isEmpty
        else {
            #if DEBUG
            os_log("Not broadcasting message: no connected peers",
                   log: .default,
                   type: .error)
            #endif
            return
        }

        do {
            try self.session.send(data,
                                  toPeers: self.session.connectedPeers,
                                  with: .reliable)
        } catch {
            #if DEBUG
            os_log("Could not send data",
                   log: .default,
                   type: .error)
            #endif
            return
        }
    }

    public func send(_ data: Data,
                     to peers: [Peer]) {
        do {
            try self.session.send(data,
                                  toPeers: peers.map { $0.peerID },
                                  with: .reliable)
        } catch {
            #if DEBUG
            os_log("Could not send data",
                   log: .default,
                   type: .error)
            #endif
            return
        }
    }

    public func sendResource(at url: URL,
                             resourceName: String,
                             to peer: Peer,
                             progressHandler: ((Double) -> Void)?,
                             completionHandler: ((Error?) -> Void)?) {
        let completion: ((Error?) -> Void)? = { error in
            self.progressWatchers[resourceName] = nil
            completionHandler?(error)
        }

        let progress = self.session.sendResource(at: url,
                                                 withName: resourceName,
                                                 toPeer: peer.peerID,
                                                 withCompletionHandler: completion)
        if let progress = progress,
            let progressHandler = progressHandler {
            let progressWatcher = ProgressWatcher(progress: progress)
            self.progressWatchers[resourceName] = progressWatcher
            progressWatcher.progressHandler = progressHandler
        }
    }

    // MARK: - Private

    private func didDiscover(_ peer: Peer) {
        self.availablePeers.insert(peer)
        self.onPeerDiscovery?(peer)
    }

    private func handleDidStartReceiving(resourceName: String,
                                         from peerID: MCPeerID,
                                         progress: Progress) {
        guard let peer = self.availablePeers.first(where: { $0.peerID == peerID })
        else { return }
        let progressWatcher = ProgressWatcher(progress: progress)
        self.progressWatchers[resourceName] = progressWatcher
        progressWatcher.progressHandler = { progress in
            self.onReceiving?(resourceName, peer, progress)
        }
        self.onStartReceiving?(resourceName, peer)
    }

    private func handleDidFinishReceiving(resourceName: String,
                                          from peerID: MCPeerID,
                                          at localURL: URL?,
                                          withError error: Error?) {
        guard let peer = self.availablePeers.first(where: { $0.peerID == peerID })
        else { return }
        self.progressWatchers[resourceName] = nil
        self.onFinishReceiving?(resourceName, peer, localURL, error)
    }

    private func handleDidReceived(_ data: Data,
                                   peerID: MCPeerID) {
           guard let peer = self.availablePeers.first(where: { $0.peerID == peerID })
           else { return }
           self.onReceive?(data, peer)
       }

    private func handlePeerRemoved(_ peerID: MCPeerID) {
        guard let peer = self.availablePeers.first(where: { $0.peerID == peerID })
        else { return }
        self.availablePeers.remove(peer)
        self.onPeerLoss?(peer)
    }

    private func handlePeerConnected(_ peer: Peer) {
        self.setConnected(true, on: peer)
        self.onPeerConnection?(peer)
    }

    private func handlePeerDisconnected(_ peer: Peer) {
        self.setConnected(false, on: peer)
        self.onPeerDisconnection?(peer)
    }

    private func setConnected(_ connected: Bool, on peer: Peer) {
        guard let idx = self.availablePeers.firstIndex(where: { $0.peerID == peer.peerID })
        else { return }

        var mutablePeer = self.availablePeers[idx]
        mutablePeer.isConnected = connected
        self.availablePeers.remove(peer)
        self.availablePeers.insert(mutablePeer)
    }

}

// MARK: - Session delegate

extension BonjourSession: MCSessionDelegate {

    public func session(_ session: MCSession,
                        peer peerID: MCPeerID,
                        didChange state: MCSessionState) {
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .debug,
               #function)
        #endif
        
        guard let peer = self.availablePeers.first(where: { $0.peerID == peerID })
        else { return }

        let handler = self.invitationCompletionHandlers[peerID]

        self.sessionQueue.async {
            switch state {
            case .connected:
                handler?(.success(peer))
                self.invitationCompletionHandlers[peerID] = nil
                self.handlePeerConnected(peer)
            case .notConnected:
                handler?(.failure(BonjourSessionError.connectionToPeerfailed))
                self.invitationCompletionHandlers[peerID] = nil
                self.handlePeerDisconnected(peer)
            case .connecting:
                break
            @unknown default:
                break
            }
        }
    }

    public func session(_ session: MCSession,
                        didReceive data: Data,
                        fromPeer peerID: MCPeerID) {
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .debug,
               #function)
        #endif
        self.handleDidReceived(data, peerID: peerID)
    }

    public func session(_ session: MCSession,
                        didReceive stream: InputStream,
                        withName streamName: String,
                        fromPeer peerID: MCPeerID) {
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .debug,
               #function)
        #endif
    }

    public func session(_ session: MCSession,
                        didStartReceivingResourceWithName resourceName: String,
                        fromPeer peerID: MCPeerID,
                        with progress: Progress) {
        self.handleDidStartReceiving(resourceName: resourceName,
                                     from: peerID,
                                     progress: progress)
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .debug,
               #function)
        #endif
    }

    public func session(_ session: MCSession,
                        didFinishReceivingResourceWithName resourceName: String,
                        fromPeer peerID: MCPeerID,
                        at localURL: URL?,
                        withError error: Error?) {
        self.handleDidFinishReceiving(resourceName: resourceName,
                                      from: peerID,
                                      at: localURL,
                                      withError: error)
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .debug,
               #function)
        #endif
    }
    
    public func session(_ session: MCSession,
                        didReceiveCertificate certificate: [Any]?,
                        fromPeer peerID: MCPeerID,
                        certificateHandler: @escaping (Bool) -> Void) {
        self.configuration.security.certificateHandler(certificate,
                                                       peerID,
                                                       certificateHandler)
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .debug,
               #function)
        #endif
    }

}

// MARK: - Browser delegate

extension BonjourSession: MCNearbyServiceBrowserDelegate {

    public func browser(_ browser: MCNearbyServiceBrowser,
                        foundPeer peerID: MCPeerID,
                        withDiscoveryInfo info: [String : String]?) {
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .debug,
               #function)
        #endif

        do {
            let peer = try Peer(peer: peerID, discoveryInfo: info)

            self.didDiscover(peer)

            switch configuration.invitation {
            case .automatic:
                browser.invitePeer(peerID,
                                   to: self.session,
                                   withContext: nil,
                                   timeout: 10.0)
            case .custom(let inviter):
                guard let invite = try inviter(peer)
                else {
                    #if DEBUG
                    os_log("Custom invite not sent for peer %@",
                           log: .default,
                           type: .error,
                           String(describing: peer))
                    #endif
                    return
                }
                
                browser.invitePeer(peerID,
                                   to: self.session,
                                   withContext: invite.context,
                                   timeout: invite.timeout)
            case .none:
                #if DEBUG
                os_log("Auto-invite disabled",
                       log: .default,
                       type: .debug)
                #endif
                return
            }
        } catch {
            #if DEBUG
            os_log("Failed to initialize peer based on peer ID %@: %{public}@",
                   log: .default,
                   type: .error,
                   String(describing: peerID),
                   String(describing: error))
            #endif
        }
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser,
                        lostPeer peerID: MCPeerID) {
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .debug,
               #function)
        #endif
        self.handlePeerRemoved(peerID)
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser,
                        didNotStartBrowsingForPeers error: Error) {
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .error,
               #function)
        #endif
    }
    

}

// MARK: - Advertiser delegate

extension BonjourSession: MCNearbyServiceAdvertiserDelegate {

    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                           didReceiveInvitationFromPeer peerID: MCPeerID,
                           withContext context: Data?,
                           invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .debug,
               #function)
        #endif

        guard let peer = self.availablePeers.first(where: { $0.peerID == peerID })
        else { return }

        self.configuration.security.invitationHandler(peer, context, { [weak self] decision in
            guard let self = self
            else { return }
            invitationHandler(decision, decision ? self.session : nil)
        })
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                           didNotStartAdvertisingPeer error: Error) {
        #if DEBUG
        os_log("%{public}@",
               log: .default,
               type: .error,
               #function)
        #endif
    }

}
