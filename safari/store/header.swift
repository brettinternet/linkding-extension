// Renders the App Store header and search results image.
// Usage: swift header.swift  (run from safari/store)
//
// One 5244x2950 image serves both placements. The header crops it to 21:9 and
// the search card to 3:2, so everything sits inside the centered 4425x2247
// area both crops keep.
import AppKit
import UniformTypeIdentifiers

let width = 5244, height = 2950

let ctx = CGContext(
    data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
    space: CGColorSpace(name: CGColorSpace.sRGB)!,
    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
ctx.interpolationQuality = .high
NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: false)

func rgb(_ hex: Int) -> CGColor {
    CGColor(srgbRed: CGFloat(hex >> 16 & 255) / 255, green: CGFloat(hex >> 8 & 255) / 255,
            blue: CGFloat(hex & 255) / 255, alpha: 1)
}

// Background: the icon purple with a soft diagonal gradient
let gradient = CGGradient(
    colorsSpace: nil, colors: [rgb(0x6c6af0), rgb(0x5856e0), rgb(0x3f3dc2)] as CFArray,
    locations: [0, 0.5, 1])!
ctx.drawLinearGradient(
    gradient, start: CGPoint(x: 0, y: height), end: CGPoint(x: width, y: 0), options: [])

// Paperclip glyph from icon/ios.svg, without its background
let glyphSVG = """
<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512"><g fill="none" stroke="#fff" stroke-width="31.25"><path d="m1244.39 1293.95v199.64s-.81 67.89 74.9 68.88c75.98.99 74.88-68.88 74.88-68.88v-199.64" transform="matrix(.70710678 .70710678 -.70710678 .70710678 284.139117 -1684.198509)"/><path d="m1244.39 1293.95v199.64s-.81 67.89 74.9 68.88c75.98.99 74.88-68.88 74.88-68.88v-199.64" transform="matrix(-.70957074 -.70463421 .70463421 -.70957074 235.113139 2195.434643)"/></g></svg>
"""
let glyph = NSImage(data: glyphSVG.data(using: .utf8)!)!
let glyphSize: CGFloat = 1900
glyph.draw(in: NSRect(x: 1650 - glyphSize / 2, y: CGFloat(height) / 2 - glyphSize / 2,
                      width: glyphSize, height: glyphSize))

// The bookmark popup, cropped from the iPad screenshot
let shot = NSImage(contentsOfFile: "screenshots/ipad/1-add.png")!
var shotRect = NSRect(x: 0, y: 0, width: 2064, height: 2752)
let shotImage = shot.cgImage(forProposedRect: &shotRect, context: nil, hints: nil)!
// Top-left origin, in screenshot pixels
let popup = shotImage.cropping(to: CGRect(x: 846, y: 222, width: 750, height: 1096))!

let popupHeight: CGFloat = 1740
let popupWidth = popupHeight * CGFloat(popup.width) / CGFloat(popup.height)
let popupRect = CGRect(x: 3500 - popupWidth / 2, y: CGFloat(height) / 2 - popupHeight / 2,
                       width: popupWidth, height: popupHeight)
let card = popupRect.insetBy(dx: -96, dy: -112)
let cardPath = CGPath(roundedRect: card, cornerWidth: 72, cornerHeight: 72, transform: nil)

ctx.saveGState()
ctx.setShadow(offset: CGSize(width: 0, height: -40), blur: 160,
              color: CGColor(gray: 0, alpha: 0.35))
ctx.addPath(cardPath)
ctx.setFillColor(.white)
ctx.fillPath()
ctx.restoreGState()

ctx.saveGState()
ctx.addPath(cardPath)
ctx.clip()
ctx.draw(popup, in: popupRect)
ctx.restoreGState()

let dest = CGImageDestinationCreateWithURL(
    URL(fileURLWithPath: "header.png") as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, ctx.makeImage()!, nil)
CGImageDestinationFinalize(dest)
