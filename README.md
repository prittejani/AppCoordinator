# AppCoordinator

A lightweight, type-safe navigation coordinator for SwiftUI.  
Built on top of `NavigationStack` and `NavigationPath` — scales from a simple single-screen app all the way to large, modular, multi-feature projects.

---

## ✨ Features

- ✅ Type-safe routing via generic `Route` enums
- ✅ `NavigationStack` + `NavigationPath` based — no UIKit dependency
- ✅ Push, pop, popToRoot out of the box
- ✅ Sheet and full-screen cover support
- ✅ Alert coordination
- ✅ Deep link handling (URL → Route)
- ✅ Works in small and large modular apps
- ✅ Clean separation — views know nothing about navigation logic

---

## 📋 Requirements

| Platform | Minimum |
|----------|---------|
| iOS      | 16.0+   |
| macOS    | 13.0+   |
| Swift    | 5.9+    |
| Xcode    | 15.0+   |

---

## 📦 Installation

### Swift Package Manager (Xcode)

1. Open your project in Xcode
2. Go to **File → Add Package Dependencies**
3. Paste the URL:

```
https://github.com/YOUR_USERNAME/AppCoordinator
```

4. Select **Up to Next Major Version** → `1.0.0`
5. Click **Add Package**

### Swift Package Manager (`Package.swift`)

```swift
dependencies: [
    .package(url: "https://github.com/YOUR_USERNAME/AppCoordinator", from: "1.0.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["AppCoordinator"]
    )
]
```

---

## 🚀 Quick Start

### 1. Define your routes

```swift
import AppCoordinator

enum HomeRoute: Route {
    case dashboard
    case profile(userID: String)
    case settings
}
```

### 2. Create a coordinator

```swift
import AppCoordinator
import SwiftUI

@MainActor
final class HomeCoordinator: Coordinator {

    let router = Router<HomeRoute>()

    func start() { }

    @ViewBuilder
    func view(for route: HomeRoute) -> some View {
        switch route {
        case .dashboard:
            DashboardView()
        case .profile(let userID):
            ProfileView(userID: userID)
        case .settings:
            SettingsView()
        }
    }
}
```

### 3. Wire it into your app

```swift
import SwiftUI
import AppCoordinator

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: HomeCoordinator()) { coordinator in
                DashboardView()
            }
        }
    }
}
```

### 4. Navigate from any view

```swift
struct DashboardView: View {
    @EnvironmentObject var router: Router<HomeRoute>

    var body: some View {
        VStack(spacing: 16) {
            Button("Open Profile") {
                router.push(.profile(userID: "abc123"))
            }
            Button("Open Settings as Sheet") {
                router.present(sheet: .settings)
            }
            Button("Go Back") {
                router.pop()
            }
            Button("Go to Root") {
                router.popToRoot()
            }
        }
    }
}
```

---

## 🔗 Deep Linking

```swift
let handler = DeepLinkHandler<HomeRoute> { url in
    guard url.host == "home" else { return nil }
    switch url.path {
    case "/dashboard": return .dashboard
    case "/settings":  return .settings
    default:           return nil
    }
}

// In your App
.onOpenURL { url in
    if let route = handler.handle(url: url) {
        router.push(route)
    }
}
```

---

## 🚨 Alert Coordination

```swift
// In your coordinator or view
let alertCoordinator = AlertCoordinator()

alertCoordinator.show(AlertItem(
    title: "Delete Item",
    message: "This action cannot be undone.",
    primaryButton: .destructive(Text("Delete")) {
        // handle delete
    },
    secondaryButton: .cancel()
))

// Attach to your view
ContentView()
    .withAlertCoordinator(alertCoordinator)
```

---

## 📄 Sheet Coordination

```swift
enum MySheet: Identifiable, Hashable {
    case camera
    case imagePicker
    case paywall

    var id: Self { self }
}

let sheetCoordinator = SheetCoordinator<MySheet>()

// Present a sheet
sheetCoordinator.present(.camera)

// Present full screen
sheetCoordinator.present(.paywall, fullScreen: true)

// Dismiss
sheetCoordinator.dismiss()

// Attach to your view
ContentView()
    .withSheetCoordinator(sheetCoordinator) { sheet in
        switch sheet {
        case .camera:      CameraView()
        case .imagePicker: ImagePickerView()
        case .paywall:     PaywallView()
        }
    }
```

---

## 🏗 Architecture Overview

```
App Entry (@main)
    └── AppCoordinator (root)
            ├── AuthCoordinator
            │     ├── Router<AuthRoute>
            │     └── Auth Views (Login, Register, ForgotPassword)
            ├── HomeCoordinator
            │     ├── Router<HomeRoute>
            │     └── Home Views (Dashboard, Profile)
            └── SettingsCoordinator
                  ├── Router<SettingsRoute>
                  └── Settings Views (Preferences, Account, Help)
```

---

## 📁 Package Structure

```
Sources/
└── AppCoordinator/
    ├── AppCoordinator.swift        ← public umbrella
    ├── Core/
    │   ├── Coordinator.swift       ← base protocol
    │   ├── Router.swift            ← NavigationPath wrapper
    │   └── CoordinatorView.swift   ← root SwiftUI view
    ├── Sheet/
    │   └── SheetCoordinator.swift  ← sheet & fullScreenCover
    ├── Alert/
    │   └── AlertCoordinator.swift  ← alert management
    └── DeepLink/
        └── DeepLinkHandler.swift   ← URL → Route mapping
```

---

## 🔄 Navigation API Reference

### `Router<R: Route>`

| Method | Description |
|--------|-------------|
| `push(_ route: R)` | Push a route onto the stack |
| `pop()` | Pop the top route |
| `popToRoot()` | Pop all routes back to root |
| `pop(to index: Int)` | Pop to a specific stack index |
| `present(sheet:)` | Present a route as a sheet |
| `presentFullScreen(_:)` | Present a route as full screen cover |
| `dismissSheet()` | Dismiss the current sheet |
| `dismissFullScreen()` | Dismiss the full screen cover |

---

## 🧪 Testing

Because `Router` is a plain `ObservableObject` with no SwiftUI dependency, you can unit test navigation logic directly:

```swift
import XCTest
@testable import AppCoordinator

final class HomeCoordinatorTests: XCTestCase {

    @MainActor
    func testPushRoute() {
        let coordinator = HomeCoordinator()
        coordinator.router.push(.profile(userID: "123"))
        XCTAssertEqual(coordinator.router.path.count, 1)
    }

    @MainActor
    func testPopToRoot() {
        let coordinator = HomeCoordinator()
        coordinator.router.push(.dashboard)
        coordinator.router.push(.settings)
        coordinator.router.popToRoot()
        XCTAssertEqual(coordinator.router.path.count, 0)
    }
}
```

---

## 📝 License

AppCoordinator is available under the **MIT License**.  
See the [LICENSE](LICENSE) file for full details.

---

## 🤝 Contributing

Contributions are welcome! Please open an issue first to discuss what you'd like to change.

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

<p align="center">Made with ❤️ for the SwiftUI community</p>
