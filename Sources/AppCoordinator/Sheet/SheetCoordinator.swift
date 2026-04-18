//
//  SheetCoordinator.swift
//  AppCoordinator
//
//  Created by iMac on 18/04/26.
//

import SwiftUI

// MARK: - SheetCoordinator
@MainActor
public final class SheetCoordinator<S: Identifiable & Hashable>: ObservableObject {

    @Published public var activeSheet: S?
    @Published public var activeFullScreen: S?

    public init() {}

    public func present(_ sheet: S, fullScreen: Bool = false) {
        if fullScreen {
            activeFullScreen = sheet
        } else {
            activeSheet = sheet
        }
    }

    public func dismiss() {
        activeSheet = nil
        activeFullScreen = nil
    }
}

// MARK: - View modifier
public struct SheetCoordinatorModifier<S: Identifiable & Hashable, SheetContent: View>: ViewModifier {

    @ObservedObject var coordinator: SheetCoordinator<S>
    let sheetContent: (S) -> SheetContent   // ← renamed from `content` to `sheetContent`

    public func body(content view: Content) -> some View {  // ← `content` is now only ViewModifier's param
        view
            .sheet(item: $coordinator.activeSheet) { sheet in
                sheetContent(sheet)
            }
            .fullScreenCover(item: $coordinator.activeFullScreen) { sheet in
                sheetContent(sheet)
            }
    }
}

// MARK: - View extension
public extension View {
    func withSheetCoordinator<S: Identifiable & Hashable, SheetContent: View>(
        _ coordinator: SheetCoordinator<S>,
        @ViewBuilder sheetContent: @escaping (S) -> SheetContent
    ) -> some View {
        modifier(SheetCoordinatorModifier(coordinator: coordinator, sheetContent: sheetContent))
    }
}
