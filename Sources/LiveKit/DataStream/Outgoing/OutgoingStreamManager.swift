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

/// Manages state of outgoing data streams.
actor OutgoingStreamManager: Loggable {
    typealias PacketHandler = (Livekit_DataPacket) async throws -> Void
    
    private nonisolated let packetHandler: PacketHandler
    
    init(packetHandler: @escaping PacketHandler) {
        self.packetHandler = packetHandler
    }
    
    // MARK: - Opening streams
    
    func sendText(_ text: String, options: StreamTextOptions) async throws -> TextStreamInfo {
        let info = TextStreamInfo(
            id: options.id ?? Self.uniqueID(),
            mimeType: Self.textMimeType,
            topic: options.topic,
            timestamp: Date(),
            totalLength: text.utf8.count, // Number of bytes in UTF-8 representation
            attributes: options.attributes ?? [:],
            operationType: .create,
            version: options.version ?? 0,
            replyToStreamID: options.replyToStreamID,
            attachedStreamIDs: options.attachedStreamIDs ?? [],
            generated: false
        )
        
        let writer = try await openTextStream(with: info)
        try await writer.write(text)
        try await writer.close()
        
        return writer.info
    }
    
    func sendFile(_ fileURL: URL, options: StreamByteOptions) async throws -> ByteStreamInfo {
        guard let fileInfo = FileInfo(for: fileURL) else {
            throw StreamError.fileInfoUnavailable
        }
        let info = ByteStreamInfo(
            id: options.id ?? Self.uniqueID(),
            mimeType: options.mimeType ?? fileInfo.mimeType ?? Self.byteMimeType,
            topic: options.topic,
            timestamp: Date(),
            totalLength: fileInfo.size, // Not overridable
            attributes: options.attributes ?? [:],
            name: options.name ?? fileInfo.name
        )
        let writer = try await openByteStream(with: info)
        try await writer.write(contentsOf: fileURL)
        try await writer.close()
        
        return writer.info
    }
    
    func streamText(options: StreamTextOptions) async throws -> TextStreamWriter {
        let info = TextStreamInfo(
            id: options.id ?? Self.uniqueID(),
            mimeType: Self.textMimeType,
            topic: options.topic,
            timestamp: Date(),
            totalLength: nil,
            attributes: options.attributes ?? [:],
            operationType: .create,
            version: options.version ?? 0,
            replyToStreamID: options.replyToStreamID,
            attachedStreamIDs: options.attachedStreamIDs ?? [],
            generated: false
        )
        return try await openTextStream(with: info)
    }
    
    func streamBytes(options: StreamByteOptions) async throws -> ByteStreamWriter {
        let info = ByteStreamInfo(
            id: options.id ?? Self.uniqueID(),
            mimeType: options.mimeType ?? Self.byteMimeType,
            topic: options.topic,
            timestamp: Date(),
            totalLength: options.totalSize,
            attributes: options.attributes ?? [:],
            name: options.name
        )
        return try await openByteStream(with: info)
    }
    
    private func openTextStream(with info: TextStreamInfo) async throws -> TextStreamWriter {
        try await openStream(with: info)
        return TextStreamWriter(
            info: info,
            destination: Destination(streamID: info.id, manager: self)
        )
    }
    
    private func openByteStream(with info: ByteStreamInfo) async throws -> ByteStreamWriter {
        try await openStream(with: info)
        return ByteStreamWriter(
            info: info,
            destination: Destination(streamID: info.id, manager: self)
        )
    }
    
    // MARK: - State
    
    /// Information about an open data stream.
    private struct Descriptor {
        let info: StreamInfo
        var writtenLength: Int = 0
        var chunkIndex: UInt64 = 0
    }
    
    /// Mapping between stream ID and descriptor for open streams.
    private var openStreams: [String: Descriptor] = [:]
    
    private func hasOpenStream(for streamID: String) -> Bool {
        openStreams[streamID] != nil
    }
    
    // MARK: - Packet sending
    
    private func openStream(with info: StreamInfo) async throws {
        guard openStreams[info.id] == nil else {
            throw StreamError.alreadyOpened
        }
        
        let header = Livekit_DataStream.Header(info)
        let packet = Livekit_DataPacket.with {
            $0.value = .streamHeader(header)
        }
        
        try await packetHandler(packet)
        
        let descriptor = Descriptor(info: info)
        openStreams[info.id] = descriptor

        log("Opened stream '\(info.id)'", .debug)
    }
    
    private func send(_ data: Data, to id: String) async throws {
        for chunk in data.chunks(of: Self.chunkSize) {
            try await sendChunk(chunk, to: id)
        }
    }
    
    private func sendChunk(_ data: Data, to id: String) async throws {
        guard let descriptor = openStreams[id] else {
            throw StreamError.unknownStream
        }
        let chunk = Livekit_DataStream.Chunk.with {
            $0.streamID = id
            $0.chunkIndex = descriptor.chunkIndex
            $0.content = data
        }
        let packet = Livekit_DataPacket.with {
            $0.value = .streamChunk(chunk)
        }
        try await packetHandler(packet)
        
        openStreams[id]!.writtenLength += data.count
        openStreams[id]!.chunkIndex += 1
    }
    
    private func closeStream(with id: String, reason: String?) async throws {
        guard openStreams[id] != nil else {
            throw StreamError.unknownStream
        }
        
        let trailer = Livekit_DataStream.Trailer.with {
            $0.streamID = id
            $0.reason = reason ?? ""
        }
        let packet = Livekit_DataPacket.with {
            $0.value = .streamTrailer(trailer)
        }
        
        try await packetHandler(packet)
        openStreams[id] = nil
        
        log("Closed stream '\(id)'", .debug)
    }
    
    // MARK: - Destination
    
    fileprivate struct Destination: StreamWriterDestination {
        let streamID: String
        weak var manager: OutgoingStreamManager?
        
        var isOpen: Bool {
            get async {
                guard let manager else { return false }
                return await manager.hasOpenStream(for: streamID)
            }
        }
        
        func write(_ data: Data) async throws {
            guard let manager else { throw StreamError.terminated }
            try await manager.send(data, to: streamID)
        }
        
        func close(reason: String?) async throws {
            guard let manager else { throw StreamError.terminated }
            try? await manager.closeStream(with: streamID, reason: reason)
        }
    }
    
    // MARK: - Constants & helpers
    
    /// Generates a unqiue ID for a new stream.
    private static func uniqueID() -> String {
        UUID().uuidString
    }
    
    /// Maximum number of bytes to send in a single chunk.
    private static let chunkSize = 15_000
    
    /// Default MIME type to use for text streams.
    private static let textMimeType = "text/plain"
    
    /// Default MIME type to use for byte streams.
    private static let byteMimeType = "application/octet-stream"
}
