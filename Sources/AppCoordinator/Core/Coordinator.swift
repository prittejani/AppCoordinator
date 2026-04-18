//
//  Coordinator.swift
//  AppCoordinator
//
//  Created by iMac on 18/04/26.
//

import SwiftUI
import Combine

// MARK: - Route protocol
/// Every feature defines its own Route enum conforming to this.
public protocol Route: Hashable, Identifiable {}

public extension Route {
    var id: Self { self }
}

// MARK: - Coordinator protocol
/// Base protocol all coordinators conform to.
@MainActor
public protocol Coordinator: ObservableObject {
    associatedtype RouteType: Route
    associatedtype Body: View

    var router: Router<RouteType> { get }

    /// Build the SwiftUI view for a given route.
    @ViewBuilder func view(for route: RouteType) -> Body

    /// Called when this coordinator should start.
    func start()
}
