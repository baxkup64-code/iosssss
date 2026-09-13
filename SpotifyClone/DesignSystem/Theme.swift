import SwiftUI

enum AppTheme {
static let background = Color.black
static let secondaryBackground = Color(.systemGray6)
static let cardBackground = Color(.secondarySystemBackground)

```
static let accent = Color.green
static let textPrimary = Color.primary
static let textSecondary = Color.secondary

static let cornerRadius: CGFloat = 16
static let smallCornerRadius: CGFloat = 10

static let horizontalPadding: CGFloat = 16
static let verticalPadding: CGFloat = 12
```

}

extension Font {
static func title() -> SwiftUI.Font {
.system(size: 22, weight: .bold, design: .rounded)
}

```
static func subtitle() -> SwiftUI.Font {
    .system(size: 16, weight: .semibold, design: .rounded)
}

static func bodyRounded() -> SwiftUI.Font {
    .system(size: 15, weight: .regular, design: .rounded)
}

static func captionRounded() -> SwiftUI.Font {
    .system(size: 13, weight: .regular, design: .rounded)
}
```

}
