// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sources",
    platforms: [
        .iOS(.v12),
    ],
    // MARK: - Products
    products: [

        // MARK: Configurations
        .library(name: "ShowioConfiguration", targets: ["ShowioConfiguration"]),

        // MARK: Flows
        .library(name: "RootFlow", targets: ["RootFlow"]),

        // MARK: Screens
        .library(name: "ShowSearchScreen", targets: ["ShowSearchScreen"]),
        .library(name: "ShowDetailsScreen", targets: ["ShowDetailsScreen"]),

        // MARK: Scenes
        .library(name: "ShowSearchScene", targets: ["ShowSearchScene"]),
        .library(name: "ShowDetailsScene", targets: ["ShowDetailsScene"]),
        .library(name: "ShowCollectionScene", targets: ["ShowCollectionScene"]),

        // MARK: Services
        .library(name: "ShowService", targets: ["ShowService"]),

        // MARK: Shared
        .library(name: "API", targets: ["API"]),
        .library(name: "Resources", targets: ["Resources"]),
        .library(name: "Styling", targets: ["Styling"]),
        .library(name: "ProgressBarView", targets: ["ProgressBarView"]),
        .library(name: "ShowDetailsTransition", targets: ["ShowDetailsTransition"]),

        // MARK: Common
        .library(name: "Promises", targets: ["Promises"]),
        .library(name: "ConstraintLayout", targets: ["ConstraintLayout"]),
        .library(name: "GradientView", targets: ["GradientView"]),
        .library(name: "CollapsingTextView", targets: ["CollapsingTextView"]),
        .library(name: "HighlightingButton", targets: ["HighlightingButton"]),
        .library(name: "Localization", targets: ["Localization"]),
        .library(name: "PropertyLists", targets: ["PropertyLists"]),
        .library(name: "URLRouter", targets: ["URLRouter"]),
        .library(name: "DI", targets: ["DI"]),

        // MARK: Executables
        .executable(name: "genstrings", targets: ["Genstrings"]),
    ],
    // MARK: - Targets
    targets: [

        // MARK: Configurations
        .target(
            name: "ShowioConfiguration",
            dependencies: [
                "DI",
                "PropertyLists",
                "URLRouter",
                "Styling",
                "API",
                "ShowSearchScreen",
                "ShowDetailsScreen",
                "RootFlow",
            ],
            path: "Configurations/ShowioConfiguration",
            resources: [.process("Resources")]),

        // MARK: Flows
        .target(name: "RootFlow",
                dependencies: [
                    "DI",
                    "ShowDetailsTransition",
                ],
                path: "Flows/RootFlow"),

        // MARK: Screens
        .target(
            name: "ShowSearchScreen",
            dependencies: [
                "DI",
                "Promises",
                "Styling",
                "ShowCollectionScene",
                "ShowService",
                "ShowSearchScene",
            ],
            path: "Screens/ShowSearchScreen"),
        .target(
            name: "ShowDetailsScreen",
            dependencies: [
                "DI",
                "ShowService",
                "ShowDetailsScene",
            ],
            path: "Screens/ShowDetailsScreen"),

        // MARK: Scenes
        .target(
            name: "ShowSearchScene",
            dependencies: [
                "ConstraintLayout",
                "Localization",
                "Styling",
                "ShowCollectionScene",
                "ShowDetailsTransition",
            ],
            path: "Scenes/ShowSearchScene"),
        .target(
            name: "ShowDetailsScene",
            dependencies: [
                "Localization",
                "ConstraintLayout",
                "RemoteImageView",
                "CollapsingTextView",
                "HighlightingButton",
                "Resources",
                "Styling",
                "ShowDetailsTransition",
            ],
            path: "Scenes/ShowDetailsScene"),
        .target(
            name: "ShowCollectionScene",
            dependencies: [
                "Localization",
                "ConstraintLayout",
                "RemoteImageView",
                "Resources",
                "Styling",
                "ProgressBarView",
            ],
            path: "Scenes/ShowCollectionScene"),

        // MARK: Services
        .target(
            name: "ShowService",
            dependencies: [
                "DI",
                "Promises",
                "API",
            ],
            path: "Services/ShowService"),

        // MARK: Shared
        .target(
            name: "API",
            dependencies: ["Promises"],
            path: "Shared/API"),
        .target(
            name: "Resources",
            path: "Shared/Resources",
            resources: [.process("Assets")]),
        .target(
            name: "Styling",
            dependencies: ["Resources"],
            path: "Shared/Styling"),
        .target(
            name: "ProgressBarView",
            dependencies: [
                "ConstraintLayout",
                "GradientView",
                "Resources",
                "Styling",
            ],
            path: "Shared/ProgressBarView"),
        .target(
            name: "ShowDetailsTransition",
            dependencies: [
                "ConstraintLayout",
                "Styling",
            ],
            path: "Shared/ShowDetailsTransition"),

        // MARK: Common
        .target(name: "Promises", path: "Common/Promises"),
        .target(name: "ConstraintLayout", path: "Common/ConstraintLayout"),
        .target(name: "GradientView", path: "Common/GradientView"),
        .target(name: "CollapsingTextView", path: "Common/CollapsingTextView"),
        .target(name: "HighlightingButton", path: "Common/HighlightingButton"),
        .target(name: "RemoteImageView", path: "Common/RemoteImageView"),
        .target(name: "Localization", path: "Common/Localization"),
        .target(name: "PropertyLists", path: "Common/PropertyLists"),
        .target(name: "URLRouter", path: "Common/URLRouter"),
        .target(name: "DI", path: "Common/DI"),

        // MARK: Executables
        .executableTarget(name: "Genstrings", path: "Executables/Genstrings"),
    ]
)
