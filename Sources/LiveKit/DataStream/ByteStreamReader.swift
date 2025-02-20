/*
 * Copyright 2025 LiveKit
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

@objc
public final class ByteStreamReader: NSObject, StreamReader, Sendable {
    
    public struct AsyncChunks {
        fileprivate var upstream: Source.Iterator
    }
    
    private let source: Source
    
    @objc
    public let info: ByteStreamInfo
    
    init(info: ByteStreamInfo, source: Source) {
        self.source = source
        self.info = info
    }
}

extension ByteStreamReader {
    
    @objc
    public func readToFile(
        in directory: URL = FileManager.default.temporaryDirectory,
        name nameOverride: String? = nil
    ) async throws -> URL {
        
        guard directory.hasDirectoryPath else {
            throw StreamError.notDirectory
        }
        let fileName = resolveFileName(override: nameOverride)
        let fileURL = directory.appendingPathComponent(fileName)
        
        FileManager.default.createFile(atPath: fileURL.path, contents: nil)
        let handle = try FileHandle(forWritingTo: fileURL)
        
        try await Task {
            for try await chunk in self {
                guard #available(macOS 10.15.4, iOS 13.4, *) else {
                    handle.write(chunk)
                    return
                }
                try handle.write(contentsOf: chunk)
            }
        }.value
        
        try handle.close()
        return fileURL
    }
    
    func resolveFileName(override: String?) -> String {
        Self.resolveFileName(
            setName: override ?? info.fileName,
            fallbackName: info.id,
            mimeType: info.mimeType,
            fallbackExtension: "bin"
        )
    }
}

extension ByteStreamReader: AsyncSequence {
    public func makeAsyncIterator() -> AsyncChunks {
        AsyncChunks(upstream: source.makeAsyncIterator())
    }
}

extension ByteStreamReader.AsyncChunks: AsyncIteratorProtocol {
    mutating public func next() async throws -> Data? {
        try await upstream.next()
    }
}
