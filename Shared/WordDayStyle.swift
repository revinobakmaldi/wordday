import SwiftUI
import UIKit

/// The adaptive After Dark / After Dawn visual system shared by the app and widget.
enum WordDayStyle {
    static let background = adaptive(
        light: UIColor(red: 0.957, green: 0.925, blue: 0.850, alpha: 1),
        dark: UIColor(red: 0.066, green: 0.040, blue: 0.074, alpha: 1)
    )

    static let surface = adaptive(
        light: UIColor(red: 0.900, green: 0.850, blue: 0.740, alpha: 1),
        dark: UIColor(red: 0.112, green: 0.070, blue: 0.124, alpha: 1)
    )

    static let ink = adaptive(
        light: UIColor(red: 0.145, green: 0.067, blue: 0.149, alpha: 1),
        dark: UIColor(red: 0.965, green: 0.925, blue: 0.835, alpha: 1)
    )

    static let mutedInk = adaptive(
        light: UIColor(red: 0.400, green: 0.300, blue: 0.400, alpha: 1),
        dark: UIColor(red: 0.715, green: 0.640, blue: 0.705, alpha: 1)
    )

    /// Readable chartreuse in each appearance, used for text, actions, and orientation.
    static let accent = adaptive(
        light: UIColor(red: 0.300, green: 0.390, blue: 0.020, alpha: 1),
        dark: UIColor(red: 0.760, green: 0.900, blue: 0.200, alpha: 1)
    )

    static let accentInk = adaptive(
        light: UIColor(red: 0.980, green: 0.940, blue: 0.850, alpha: 1),
        dark: UIColor(red: 0.052, green: 0.075, blue: 0.018, alpha: 1)
    )

    static let rule = adaptive(
        light: UIColor(red: 0.500, green: 0.410, blue: 0.500, alpha: 1),
        dark: UIColor(red: 0.450, green: 0.340, blue: 0.470, alpha: 1)
    )

    static let orbit = adaptive(
        light: UIColor(red: 0.660, green: 0.630, blue: 0.310, alpha: 1),
        dark: UIColor(red: 0.300, green: 0.360, blue: 0.105, alpha: 1)
    )

    static let success = adaptive(
        light: UIColor(red: 0.160, green: 0.430, blue: 0.270, alpha: 1),
        dark: UIColor(red: 0.430, green: 0.760, blue: 0.530, alpha: 1)
    )

    static func displayFont(size: CGFloat) -> Font {
        .custom("AvenirNextCondensed-DemiBold", size: size, relativeTo: .largeTitle)
    }

    static func bodyFont(size: CGFloat = 17) -> Font {
        .custom("NewYorkSmall-Regular", size: size, relativeTo: .body)
    }

    static func italicFont(size: CGFloat = 15) -> Font {
        .custom("NewYorkSmall-RegularItalic", size: size, relativeTo: .callout)
    }

    static func labelFont(size: CGFloat = 12) -> Font {
        .custom("AvenirNext-DemiBold", size: size, relativeTo: .caption)
    }

    private static func adaptive(light: UIColor, dark: UIColor) -> Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        })
    }
}

/// A cropped orbit is the signature graphic device in both appearances.
struct WordDayOrbit: View {
    var diameter: CGFloat = 44
    var lineWidth: CGFloat = 5

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.10, to: 0.83)
                .stroke(
                    WordDayStyle.orbit,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt)
                )
                .rotationEffect(.degrees(-24))

            Circle()
                .fill(WordDayStyle.accent)
                .frame(width: max(lineWidth * 0.8, 3), height: max(lineWidth * 0.8, 3))
                .offset(x: diameter * 0.31, y: diameter * 0.21)
        }
        .frame(width: diameter, height: diameter)
        .accessibilityHidden(true)
    }
}
