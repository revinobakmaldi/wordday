import SwiftUI

/// The approved After Dark visual system shared by the app and widget.
enum WordDayStyle {
    static let background = Color(red: 0.066, green: 0.040, blue: 0.074)
    static let surface = Color(red: 0.112, green: 0.070, blue: 0.124)
    static let ink = Color(red: 0.965, green: 0.925, blue: 0.835)
    static let mutedInk = Color(red: 0.715, green: 0.640, blue: 0.705)
    static let accent = Color(red: 0.760, green: 0.900, blue: 0.200)
    static let accentInk = Color(red: 0.052, green: 0.075, blue: 0.018)
    static let rule = Color(red: 0.450, green: 0.340, blue: 0.470)
    static let orbit = Color(red: 0.300, green: 0.360, blue: 0.105)
    static let success = Color(red: 0.430, green: 0.760, blue: 0.530)

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
}

/// A cropped orbit is the signature After Dark graphic device.
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
