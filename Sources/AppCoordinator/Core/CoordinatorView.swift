//
//  CoordinatorView.swift
//  AppCoordinator
//
//  Created by iMac on 18/04/26.
//

import SwiftUI

// MARK: - CoordinatorView
/// Drop-in SwiftUI view. Pass your Coordinator and a root view builder.
public struct CoordinatorView<C: Coordinator, Root: View>: View {

    @StateObject private var coordinator: C
    private let root: (C) -> Root

    public init(coordinator: @autoclosure @escaping () -> C,
                @ViewBuilder root: @escaping (C) -> Root) {
        _coordinator = StateObject(wrappedValue: coordinator())
        self.root = root
    }

    public var body: some View {
        NavigationStack(path: Binding(
            get: { coordinator.router.path },
            set: { coordinator.router.path = $0 }
        )) {
            root(coordinator)
                .navigationDestination(for: C.RouteType.self) { route in
                    coordinator.view(for: route)
                }
                // Sheet overlay
                .sheet(item: Binding(
                    get: { coordinator.router.presentedSheet },
                    set: { coordinator.router.presentedSheet = $0 }
                )) { route in
                    coordinator.view(for: route)
                }
                // Full-screen overlay
                .fullScreenCover(item: Binding(
                    get: { coordinator.router.presentedFullScreen },
                    set: { coordinator.router.presentedFullScreen = $0 }
                )) { route in
                    coordinator.view(for: route)
                }
        }
        .environmentObject(coordinator.router)
        .onAppear { coordinator.start() }
    }
}
