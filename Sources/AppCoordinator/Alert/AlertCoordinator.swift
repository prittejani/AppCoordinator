//
//  AlertCoordinator.swift
//  AppCoordinator
//
//  Created by iMac on 18/04/26.
//

import SwiftUI

// MARK: - AlertItem
public struct AlertItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let primaryButton: Alert.Button
    public let secondaryButton: Alert.Button?

    public init(title: String,
                message: String? = nil,
                primaryButton: Alert.Button = .default(Text("OK")),
                secondaryButton: Alert.Button? = nil) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }

    public var alert: Alert {
        if let secondary = secondaryButton {
            return Alert(title: Text(title),
                         message: message.map { Text($0) },
                         primaryButton: primaryButton,
                         secondaryButton: secondary)
        }
        return Alert(title: Text(title),
                     message: message.map { Text($0) },
                     dismissButton: primaryButton)
    }
}

// MARK: - AlertCoordinator
@MainActor
public final class AlertCoordinator: ObservableObject {
    @Published public var currentAlert: AlertItem?

    public init() {}

    public func show(_ alert: AlertItem) {
        currentAlert = alert
    }

    public func dismiss() {
        currentAlert = nil
    }
}

// MARK: - View extension
public extension View {
    func withAlertCoordinator(_ coordinator: AlertCoordinator) -> some View {
        alert(item: Binding(
            get: { coordinator.currentAlert },
            set: { coordinator.currentAlert = $0 }
        )) { item in
            item.alert
        }
    }
}
