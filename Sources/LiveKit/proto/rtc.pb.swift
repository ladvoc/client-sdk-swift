// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: rtc.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

enum Livekit_SignalTarget: SwiftProtobuf.Enum {
  typealias RawValue = Int
  case publisher // = 0
  case subscriber // = 1
  case UNRECOGNIZED(Int)

  init() {
    self = .publisher
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .publisher
    case 1: self = .subscriber
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  var rawValue: Int {
    switch self {
    case .publisher: return 0
    case .subscriber: return 1
    case .UNRECOGNIZED(let i): return i
    }
  }

}

#if swift(>=4.2)

extension Livekit_SignalTarget: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static var allCases: [Livekit_SignalTarget] = [
    .publisher,
    .subscriber,
  ]
}

#endif  // swift(>=4.2)

struct Livekit_SignalRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var message: Livekit_SignalRequest.OneOf_Message? = nil

  /// initial join exchange, for publisher
  var offer: Livekit_SessionDescription {
    get {
      if case .offer(let v)? = message {return v}
      return Livekit_SessionDescription()
    }
    set {message = .offer(newValue)}
  }

  /// participant answering publisher offer
  var answer: Livekit_SessionDescription {
    get {
      if case .answer(let v)? = message {return v}
      return Livekit_SessionDescription()
    }
    set {message = .answer(newValue)}
  }

  var trickle: Livekit_TrickleRequest {
    get {
      if case .trickle(let v)? = message {return v}
      return Livekit_TrickleRequest()
    }
    set {message = .trickle(newValue)}
  }

  var addTrack: Livekit_AddTrackRequest {
    get {
      if case .addTrack(let v)? = message {return v}
      return Livekit_AddTrackRequest()
    }
    set {message = .addTrack(newValue)}
  }

  /// mute the participant's own tracks
  var mute: Livekit_MuteTrackRequest {
    get {
      if case .mute(let v)? = message {return v}
      return Livekit_MuteTrackRequest()
    }
    set {message = .mute(newValue)}
  }

  /// mute a track client is subscribed to
  var muteSubscribed: Livekit_MuteTrackRequest {
    get {
      if case .muteSubscribed(let v)? = message {return v}
      return Livekit_MuteTrackRequest()
    }
    set {message = .muteSubscribed(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_Message: Equatable {
    /// initial join exchange, for publisher
    case offer(Livekit_SessionDescription)
    /// participant answering publisher offer
    case answer(Livekit_SessionDescription)
    case trickle(Livekit_TrickleRequest)
    case addTrack(Livekit_AddTrackRequest)
    /// mute the participant's own tracks
    case mute(Livekit_MuteTrackRequest)
    /// mute a track client is subscribed to
    case muteSubscribed(Livekit_MuteTrackRequest)

  #if !swift(>=4.1)
    static func ==(lhs: Livekit_SignalRequest.OneOf_Message, rhs: Livekit_SignalRequest.OneOf_Message) -> Bool {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch (lhs, rhs) {
      case (.offer, .offer): return {
        guard case .offer(let l) = lhs, case .offer(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.answer, .answer): return {
        guard case .answer(let l) = lhs, case .answer(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.trickle, .trickle): return {
        guard case .trickle(let l) = lhs, case .trickle(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.addTrack, .addTrack): return {
        guard case .addTrack(let l) = lhs, case .addTrack(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.mute, .mute): return {
        guard case .mute(let l) = lhs, case .mute(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.muteSubscribed, .muteSubscribed): return {
        guard case .muteSubscribed(let l) = lhs, case .muteSubscribed(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      default: return false
      }
    }
  #endif
  }

  init() {}
}

struct Livekit_SignalResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var message: Livekit_SignalResponse.OneOf_Message? = nil

  /// sent when join is accepted
  var join: Livekit_JoinResponse {
    get {
      if case .join(let v)? = message {return v}
      return Livekit_JoinResponse()
    }
    set {message = .join(newValue)}
  }

  /// sent when server answers publisher
  var answer: Livekit_SessionDescription {
    get {
      if case .answer(let v)? = message {return v}
      return Livekit_SessionDescription()
    }
    set {message = .answer(newValue)}
  }

  /// sent when server is sending subscriber an offer
  var offer: Livekit_SessionDescription {
    get {
      if case .offer(let v)? = message {return v}
      return Livekit_SessionDescription()
    }
    set {message = .offer(newValue)}
  }

  /// sent when an ICE candidate is available
  var trickle: Livekit_TrickleRequest {
    get {
      if case .trickle(let v)? = message {return v}
      return Livekit_TrickleRequest()
    }
    set {message = .trickle(newValue)}
  }

  /// sent when participants in the room has changed
  var update: Livekit_ParticipantUpdate {
    get {
      if case .update(let v)? = message {return v}
      return Livekit_ParticipantUpdate()
    }
    set {message = .update(newValue)}
  }

  /// sent to the participant when their track has been published
  var trackPublished: Livekit_TrackPublishedResponse {
    get {
      if case .trackPublished(let v)? = message {return v}
      return Livekit_TrackPublishedResponse()
    }
    set {message = .trackPublished(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_Message: Equatable {
    /// sent when join is accepted
    case join(Livekit_JoinResponse)
    /// sent when server answers publisher
    case answer(Livekit_SessionDescription)
    /// sent when server is sending subscriber an offer
    case offer(Livekit_SessionDescription)
    /// sent when an ICE candidate is available
    case trickle(Livekit_TrickleRequest)
    /// sent when participants in the room has changed
    case update(Livekit_ParticipantUpdate)
    /// sent to the participant when their track has been published
    case trackPublished(Livekit_TrackPublishedResponse)

  #if !swift(>=4.1)
    static func ==(lhs: Livekit_SignalResponse.OneOf_Message, rhs: Livekit_SignalResponse.OneOf_Message) -> Bool {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch (lhs, rhs) {
      case (.join, .join): return {
        guard case .join(let l) = lhs, case .join(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.answer, .answer): return {
        guard case .answer(let l) = lhs, case .answer(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.offer, .offer): return {
        guard case .offer(let l) = lhs, case .offer(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.trickle, .trickle): return {
        guard case .trickle(let l) = lhs, case .trickle(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.update, .update): return {
        guard case .update(let l) = lhs, case .update(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.trackPublished, .trackPublished): return {
        guard case .trackPublished(let l) = lhs, case .trackPublished(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      default: return false
      }
    }
  #endif
  }

  init() {}
}

struct Livekit_AddTrackRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// client ID of track, to match it when RTC track is received
  var cid: String = String()

  var name: String = String()

  var type: Livekit_TrackType = .audio

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Livekit_TrickleRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var candidateInit: String = String()

  var target: Livekit_SignalTarget = .publisher

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Livekit_MuteTrackRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var sid: String = String()

  var muted: Bool = false

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// empty
struct Livekit_NegotiationRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Livekit_JoinResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var room: Livekit_Room {
    get {return _room ?? Livekit_Room()}
    set {_room = newValue}
  }
  /// Returns true if `room` has been explicitly set.
  var hasRoom: Bool {return self._room != nil}
  /// Clears the value of `room`. Subsequent reads from it will return its default value.
  mutating func clearRoom() {self._room = nil}

  var participant: Livekit_ParticipantInfo {
    get {return _participant ?? Livekit_ParticipantInfo()}
    set {_participant = newValue}
  }
  /// Returns true if `participant` has been explicitly set.
  var hasParticipant: Bool {return self._participant != nil}
  /// Clears the value of `participant`. Subsequent reads from it will return its default value.
  mutating func clearParticipant() {self._participant = nil}

  var otherParticipants: [Livekit_ParticipantInfo] = []

  var serverVersion: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _room: Livekit_Room? = nil
  fileprivate var _participant: Livekit_ParticipantInfo? = nil
}

struct Livekit_TrackPublishedResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var cid: String = String()

  var track: Livekit_TrackInfo {
    get {return _track ?? Livekit_TrackInfo()}
    set {_track = newValue}
  }
  /// Returns true if `track` has been explicitly set.
  var hasTrack: Bool {return self._track != nil}
  /// Clears the value of `track`. Subsequent reads from it will return its default value.
  mutating func clearTrack() {self._track = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _track: Livekit_TrackInfo? = nil
}

struct Livekit_SessionDescription {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// "answer" | "offer" | "pranswer" | "rollback"
  var type: String = String()

  var sdp: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Livekit_ParticipantUpdate {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var participants: [Livekit_ParticipantInfo] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "livekit"

extension Livekit_SignalTarget: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "PUBLISHER"),
    1: .same(proto: "SUBSCRIBER"),
  ]
}

extension Livekit_SignalRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SignalRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "offer"),
    2: .same(proto: "answer"),
    3: .same(proto: "trickle"),
    4: .standard(proto: "add_track"),
    5: .same(proto: "mute"),
    6: .standard(proto: "mute_subscribed"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try {
        var v: Livekit_SessionDescription?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .offer(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .offer(v)}
      }()
      case 2: try {
        var v: Livekit_SessionDescription?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .answer(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .answer(v)}
      }()
      case 3: try {
        var v: Livekit_TrickleRequest?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .trickle(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .trickle(v)}
      }()
      case 4: try {
        var v: Livekit_AddTrackRequest?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .addTrack(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .addTrack(v)}
      }()
      case 5: try {
        var v: Livekit_MuteTrackRequest?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .mute(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .mute(v)}
      }()
      case 6: try {
        var v: Livekit_MuteTrackRequest?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .muteSubscribed(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .muteSubscribed(v)}
      }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every case branch when no optimizations are
    // enabled. https://github.com/apple/swift-protobuf/issues/1034
    switch self.message {
    case .offer?: try {
      guard case .offer(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }()
    case .answer?: try {
      guard case .answer(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }()
    case .trickle?: try {
      guard case .trickle(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    }()
    case .addTrack?: try {
      guard case .addTrack(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
    }()
    case .mute?: try {
      guard case .mute(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    }()
    case .muteSubscribed?: try {
      guard case .muteSubscribed(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
    }()
    case nil: break
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Livekit_SignalRequest, rhs: Livekit_SignalRequest) -> Bool {
    if lhs.message != rhs.message {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Livekit_SignalResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SignalResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "join"),
    2: .same(proto: "answer"),
    3: .same(proto: "offer"),
    4: .same(proto: "trickle"),
    5: .same(proto: "update"),
    6: .standard(proto: "track_published"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try {
        var v: Livekit_JoinResponse?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .join(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .join(v)}
      }()
      case 2: try {
        var v: Livekit_SessionDescription?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .answer(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .answer(v)}
      }()
      case 3: try {
        var v: Livekit_SessionDescription?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .offer(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .offer(v)}
      }()
      case 4: try {
        var v: Livekit_TrickleRequest?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .trickle(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .trickle(v)}
      }()
      case 5: try {
        var v: Livekit_ParticipantUpdate?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .update(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .update(v)}
      }()
      case 6: try {
        var v: Livekit_TrackPublishedResponse?
        if let current = self.message {
          try decoder.handleConflictingOneOf()
          if case .trackPublished(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.message = .trackPublished(v)}
      }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every case branch when no optimizations are
    // enabled. https://github.com/apple/swift-protobuf/issues/1034
    switch self.message {
    case .join?: try {
      guard case .join(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }()
    case .answer?: try {
      guard case .answer(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }()
    case .offer?: try {
      guard case .offer(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    }()
    case .trickle?: try {
      guard case .trickle(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
    }()
    case .update?: try {
      guard case .update(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    }()
    case .trackPublished?: try {
      guard case .trackPublished(let v)? = self.message else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
    }()
    case nil: break
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Livekit_SignalResponse, rhs: Livekit_SignalResponse) -> Bool {
    if lhs.message != rhs.message {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Livekit_AddTrackRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".AddTrackRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "cid"),
    2: .same(proto: "name"),
    3: .same(proto: "type"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.cid) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 3: try { try decoder.decodeSingularEnumField(value: &self.type) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.cid.isEmpty {
      try visitor.visitSingularStringField(value: self.cid, fieldNumber: 1)
    }
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 2)
    }
    if self.type != .audio {
      try visitor.visitSingularEnumField(value: self.type, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Livekit_AddTrackRequest, rhs: Livekit_AddTrackRequest) -> Bool {
    if lhs.cid != rhs.cid {return false}
    if lhs.name != rhs.name {return false}
    if lhs.type != rhs.type {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Livekit_TrickleRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".TrickleRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "candidateInit"),
    2: .same(proto: "target"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.candidateInit) }()
      case 2: try { try decoder.decodeSingularEnumField(value: &self.target) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.candidateInit.isEmpty {
      try visitor.visitSingularStringField(value: self.candidateInit, fieldNumber: 1)
    }
    if self.target != .publisher {
      try visitor.visitSingularEnumField(value: self.target, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Livekit_TrickleRequest, rhs: Livekit_TrickleRequest) -> Bool {
    if lhs.candidateInit != rhs.candidateInit {return false}
    if lhs.target != rhs.target {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Livekit_MuteTrackRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".MuteTrackRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "sid"),
    2: .same(proto: "muted"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.sid) }()
      case 2: try { try decoder.decodeSingularBoolField(value: &self.muted) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.sid.isEmpty {
      try visitor.visitSingularStringField(value: self.sid, fieldNumber: 1)
    }
    if self.muted != false {
      try visitor.visitSingularBoolField(value: self.muted, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Livekit_MuteTrackRequest, rhs: Livekit_MuteTrackRequest) -> Bool {
    if lhs.sid != rhs.sid {return false}
    if lhs.muted != rhs.muted {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Livekit_NegotiationRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".NegotiationRequest"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Livekit_NegotiationRequest, rhs: Livekit_NegotiationRequest) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Livekit_JoinResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".JoinResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "room"),
    2: .same(proto: "participant"),
    3: .standard(proto: "other_participants"),
    4: .standard(proto: "server_version"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._room) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._participant) }()
      case 3: try { try decoder.decodeRepeatedMessageField(value: &self.otherParticipants) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.serverVersion) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._room {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if let v = self._participant {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    if !self.otherParticipants.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.otherParticipants, fieldNumber: 3)
    }
    if !self.serverVersion.isEmpty {
      try visitor.visitSingularStringField(value: self.serverVersion, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Livekit_JoinResponse, rhs: Livekit_JoinResponse) -> Bool {
    if lhs._room != rhs._room {return false}
    if lhs._participant != rhs._participant {return false}
    if lhs.otherParticipants != rhs.otherParticipants {return false}
    if lhs.serverVersion != rhs.serverVersion {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Livekit_TrackPublishedResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".TrackPublishedResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "cid"),
    2: .same(proto: "track"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.cid) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._track) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.cid.isEmpty {
      try visitor.visitSingularStringField(value: self.cid, fieldNumber: 1)
    }
    if let v = self._track {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Livekit_TrackPublishedResponse, rhs: Livekit_TrackPublishedResponse) -> Bool {
    if lhs.cid != rhs.cid {return false}
    if lhs._track != rhs._track {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Livekit_SessionDescription: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SessionDescription"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "type"),
    2: .same(proto: "sdp"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.type) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.sdp) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.type.isEmpty {
      try visitor.visitSingularStringField(value: self.type, fieldNumber: 1)
    }
    if !self.sdp.isEmpty {
      try visitor.visitSingularStringField(value: self.sdp, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Livekit_SessionDescription, rhs: Livekit_SessionDescription) -> Bool {
    if lhs.type != rhs.type {return false}
    if lhs.sdp != rhs.sdp {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Livekit_ParticipantUpdate: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ParticipantUpdate"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "participants"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.participants) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.participants.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.participants, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Livekit_ParticipantUpdate, rhs: Livekit_ParticipantUpdate) -> Bool {
    if lhs.participants != rhs.participants {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
