//
//  DeepLinkHandler.swift
//  AppCoordinator
//
//  Created by iMac on 18/04/26.
//

import Foundation

// MARK: - DeepLinkHandler
/// Map incoming URLs to routes then hand them off to the root coordinator.
public protocol DeepLinkHandling {
    associatedtype RootRoute: Route
    func handle(url: URL) -> RootRoute?
}

public final class DeepLinkHandler<R: Route>: DeepLinkHandling, ObservableObject {

    private let resolver: (URL) -> R?

    public init(resolver: @escaping (URL) -> R?) {
        self.resolver = resolver
    }

    public func handle(url: URL) -> R? {
        resolver(url)
    }
}
