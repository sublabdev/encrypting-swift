import Foundation

extension UnsafeMutableRawBufferPointer {
    var bufferPointer: UnsafeMutablePointer<UInt8> {
        baseAddress!.assumingMemoryBound(to: UInt8.self)
    }
}
