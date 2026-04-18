//
//  Router.swift
//  AppCoordinator
//
//  Created by iMac on 18/04/26.
//

import SwiftUI
import Combine

// MARK: - Router
/// Owns the NavigationPath and exposes push/pop/popToRoot API.
@MainActor
public final class Router<R: Route>: ObservableObject {

    @Published public var path = NavigationPath()

    // Sheet / full-screen cover
    @Published public var presentedSheet: R?
    @Published public var presentedFullScreen: R?

    public init() {}

    // MARK: Push / Pop
    public func push(_ route: R) {
        path.append(route)
    }

    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    public func popToRoot() {
        path.removeLast(path.count)
    }

    public func pop(to index: Int) {
        let excess = path.count - index - 1
        guard excess > 0 else { return }
        path.removeLast(excess)
    }

    // MARK: Sheet
    public func present(sheet route: R) {
        presentedSheet = route
    }

    public func presentFullScreen(_ route: R) {
        presentedFullScreen = route
    }

    public func dismissSheet() {
        presentedSheet = nil
    }

    public func dismissFullScreen() {
        presentedFullScreen = nil
    }
}
