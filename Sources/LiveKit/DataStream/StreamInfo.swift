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

/// Information about a data stream.
public protocol StreamInfo: Sendable {
    /// Unique identifier of the stream.
    var id: String { get }

    /// Topic name used to route the stream to the appropriate handler.
    var topic: String { get }

    /// When the stream was created.
    var timestamp: Date { get }

    /// Total expected size in bytes (UTF-8 for text), if known.
    var totalLength: Int? { get }

    /// Additional attributes as needed for your application.
    var attributes: [String: String] { get }
}

/// Information about a text data stream.
@objcMembers
public final class TextStreamInfo: NSObject, StreamInfo {
    public let id: String
    public let topic: String
    public let timestamp: Date
    public let totalLength: Int?
    public let attributes: [String: String]

    @objc(TextStreamInfoOperationType)
    public enum OperationType: Int, Sendable {
        case create
        case update
        case delete
        case reaction
    }

    public let operationType: OperationType
    public let version: Int
    public let replyToStreamID: String?
    public let attachedStreamIDs: [String]
    public let generated: Bool

    init(
        id: String,
        topic: String,
        timestamp: Date,
        totalLength: Int?,
        attributes: [String: String],
        operationType: OperationType,
        version: Int,
        replyToStreamID: String?,
        attachedStreamIDs: [String],
        generated: Bool
    ) {
        self.id = id
        self.topic = topic
        self.timestamp = timestamp
        self.totalLength = totalLength
        self.attributes = attributes
        self.operationType = operationType
        self.version = version
        self.replyToStreamID = replyToStreamID
        self.attachedStreamIDs = attachedStreamIDs
        self.generated = generated
    }
}

/// Information about a byte data stream.
@objcMembers
public final class ByteStreamInfo: NSObject, StreamInfo {
    public let id: String
    public let topic: String
    public let timestamp: Date
    public let totalLength: Int?
    public let attributes: [String: String]

    /// The MIME type of the stream data.
    public let mimeType: String

    /// The name of the file being sent.
    public let name: String?

    init(
        id: String,
        topic: String,
        timestamp: Date,
        totalLength: Int?,
        attributes: [String: String],
        mimeType: String,
        name: String?
    ) {
        self.id = id
        self.mimeType = mimeType
        self.topic = topic
        self.timestamp = timestamp
        self.totalLength = totalLength
        self.attributes = attributes
        self.name = name
    }
}

// MARK: - From protocol types

extension ByteStreamInfo {
    convenience init(
        _ header: Livekit_DataStream.Header,
        _ byteHeader: Livekit_DataStream.ByteHeader
    ) {
        self.init(
            id: header.streamID,
            topic: header.topic,
            timestamp: header.timestampDate,
            totalLength: header.hasTotalLength ? Int(header.totalLength) : nil,
            attributes: header.attributes,
            // ---
            mimeType: header.mimeType,
            name: byteHeader.name
        )
    }
}

extension TextStreamInfo {
    convenience init(
        _ header: Livekit_DataStream.Header,
        _ textHeader: Livekit_DataStream.TextHeader
    ) {
        self.init(
            id: header.streamID,
            topic: header.topic,
            timestamp: header.timestampDate,
            totalLength: header.hasTotalLength ? Int(header.totalLength) : nil,
            attributes: header.attributes,
            // ---
            operationType: TextStreamInfo.OperationType(textHeader.operationType),
            version: Int(textHeader.version),
            replyToStreamID: !textHeader.replyToStreamID.isEmpty ? textHeader.replyToStreamID : nil,
            attachedStreamIDs: textHeader.attachedStreamIds,
            generated: textHeader.generated
        )
    }
}

// MARK: - To protocol types

extension Livekit_DataStream.Header {
    init(_ streamInfo: StreamInfo) {
        self = Livekit_DataStream.Header.with {
            $0.streamID = streamInfo.id
            $0.mimeType = "text/plain"
            $0.topic = streamInfo.topic
            $0.timestampDate = streamInfo.timestamp
            if let totalLength = streamInfo.totalLength {
                $0.totalLength = UInt64(totalLength)
            }
            $0.attributes = streamInfo.attributes
            $0.contentHeader = Livekit_DataStream.Header.OneOf_ContentHeader(streamInfo)
        }
    }

    var timestampDate: Date {
        get { Date(timeIntervalSince1970: TimeInterval(timestamp)) }
        set { timestamp = Int64(newValue.timeIntervalSince1970) }
    }
}

extension Livekit_DataStream.Header.OneOf_ContentHeader {
    init?(_ streamInfo: StreamInfo) {
        if let textStreamInfo = streamInfo as? TextStreamInfo {
            self = .textHeader(Livekit_DataStream.TextHeader.with {
                $0.operationType = Livekit_DataStream.OperationType(textStreamInfo.operationType)
                $0.version = Int32(textStreamInfo.version)
                $0.replyToStreamID = textStreamInfo.replyToStreamID ?? ""
                $0.attachedStreamIds = textStreamInfo.attachedStreamIDs
                $0.generated = textStreamInfo.generated
            })
            return
        } else if let byteStreamInfo = streamInfo as? ByteStreamInfo {
            self = .byteHeader(Livekit_DataStream.ByteHeader.with {
                if let name = byteStreamInfo.name { $0.name = name }
            })
            return
        }
        return nil
    }
}

extension TextStreamInfo.OperationType {
    init(_ operationType: Livekit_DataStream.OperationType) {
        self = Self(rawValue: operationType.rawValue) ?? .create
    }
}

extension Livekit_DataStream.OperationType {
    init(_ operationType: TextStreamInfo.OperationType) {
        self = Livekit_DataStream.OperationType(rawValue: operationType.rawValue) ?? .create
    }
}
