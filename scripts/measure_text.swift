// Measures how text wraps in the fonts the widgets use, so check_phrases.py can
// tell whether a phrase list fits without running the widget.
//
// Input on stdin, one job per line: <font>\t<size>\t<width>\t<text>
// Output, one line per job: <lineCount>\t<height>
// <font> is "newyork", "newyork-italic", "system", or a PostScript name.
import CoreText
import Foundation

let opticalSize = 1869640570 as NSNumber  // 'opsz'

func newYork(_ file: String, _ size: CGFloat) -> CTFont {
    let url = URL(fileURLWithPath: "/System/Library/Fonts/\(file)") as CFURL
    guard let base = (CTFontManagerCreateFontDescriptorsFromURL(url) as? [CTFontDescriptor])?.first else {
        fatalError("missing font file \(file)")
    }
    return CTFontCreateWithFontDescriptor(CTFontDescriptorCreateCopyWithVariation(base, opticalSize, size), size, nil)
}

func font(_ name: String, _ size: CGFloat) -> CTFont {
    switch name {
    case "newyork": return newYork("NewYork.ttf", size)
    case "newyork-italic": return newYork("NewYorkItalic.ttf", size)
    case "system": return CTFontCreateUIFontForLanguage(.system, size, nil)!
    default:
        let f = CTFontCreateWithName(name as CFString, size, nil)
        guard CTFontCopyPostScriptName(f) as String == name else { fatalError("font not installed: \(name)") }
        return f
    }
}

while let line = readLine() {
    let parts = line.split(separator: "\t", maxSplits: 3).map(String.init)
    let f = font(parts[0], CGFloat(Double(parts[1])!))
    let attr = NSAttributedString(string: parts[3], attributes: [NSAttributedString.Key(kCTFontAttributeName as String): f])
    let setter = CTFramesetterCreateWithAttributedString(attr)
    let width = CGFloat(Double(parts[2])!)
    let size = CTFramesetterSuggestFrameSizeWithConstraints(setter, CFRange(), nil, CGSize(width: width, height: .greatestFiniteMagnitude), nil)
    let frame = CTFramesetterCreateFrame(setter, CFRange(), CGPath(rect: CGRect(x: 0, y: 0, width: width, height: 100_000), transform: nil), nil)
    print("\((CTFrameGetLines(frame) as NSArray).count)\t\(Int(size.height.rounded(.up)))")
}
