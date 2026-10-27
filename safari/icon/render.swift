// Usage: swift render.swift <in.svg> <out.png> <size> <opaque:0|1>
import AppKit
import UniformTypeIdentifiers

let args = CommandLine.arguments
let image = NSImage(contentsOfFile: args[1])!
let size = Int(args[3])!
let alpha: CGImageAlphaInfo = args[4] == "1" ? .noneSkipLast : .premultipliedLast

let ctx = CGContext(
    data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0,
    space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: alpha.rawValue)!
ctx.interpolationQuality = .high
NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: false)
image.draw(in: NSRect(x: 0, y: 0, width: size, height: size))

let dest = CGImageDestinationCreateWithURL(
    URL(fileURLWithPath: args[2]) as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, ctx.makeImage()!, nil)
CGImageDestinationFinalize(dest)
