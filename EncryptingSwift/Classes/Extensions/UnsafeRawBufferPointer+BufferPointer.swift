import Foundation

extension UnsafeRawBufferPointer {
    var bufferPointer: UnsafePointer<UInt8> {
        baseAddress!.assumingMemoryBound(to: UInt8.self)
    }
}
