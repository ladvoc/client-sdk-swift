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

// MARK: - Public RPC methods

public extension LocalParticipant {
    /// Establishes the participant as a receiver for calls of the specified RPC method.
    /// Will overwrite any existing callback for the same method.
    ///
    /// Example:
    /// ```swift
    /// try await room.localParticipant.registerRpcMethod("greet") { data in
    ///     print("Received greeting from \(data.callerIdentity): \(data.payload)")
    ///     return "Hello, \(data.callerIdentity)!"
    /// }
    /// ```
    ///
    /// The handler receives an `RpcInvocationData` containing the following parameters:
    /// - `requestId`: A unique identifier for this RPC request
    /// - `callerIdentity`: The identity of the RemoteParticipant who initiated the RPC call
    /// - `payload`: The data sent by the caller (as a string)
    /// - `responseTimeout`: The maximum time available to return a response
    ///
    /// The handler should return a string.
    /// If unable to respond within responseTimeout, the request will result in an error on the caller's side.
    ///
    /// You may throw errors of type RpcError with a string message in the handler,
    /// and they will be received on the caller's side with the message intact.
    /// Other errors thrown in your handler will not be transmitted as-is, and will instead arrive to the caller as 1500 ("Application Error").
    ///
    /// - Parameters:
    ///   - method: The name of the indicated RPC method
    ///   - handler: Will be invoked when an RPC request for this method is received
    func registerRpcMethod(_ method: String,
                           handler: @escaping RpcHandler) async
    {
        await rpcState.registerHandler(method, handler: handler)
    }

    /// Unregisters a previously registered RPC method.
    ///
    /// - Parameter method: The name of the RPC method to unregister
    func unregisterRpcMethod(_ method: String) async {
        await rpcState.unregisterHandler(method)
    }

    /// Initiate an RPC call to a remote participant
    /// - Parameters:
    ///   - destinationIdentity: The identity of the destination participant
    ///   - method: The method name to call
    ///   - payload: The payload to pass to the method
    ///   - responseTimeout: Timeout for receiving a response after initial connection. (default 10s)
    /// - Returns: The response payload
    /// - Throws: RpcError on failure. Details in RpcError.message
    func performRpc(destinationIdentity: Identity,
                    method: String,
                    payload: String,
                    responseTimeout: TimeInterval = 10) async throws -> String
    {
        guard payload.byteLength <= MAX_RPC_PAYLOAD_BYTES else {
            throw RpcError.builtIn(.requestPayloadTooLarge)
        }

        let requestId = UUID().uuidString
        let maxRoundTripLatency: TimeInterval = 2
        let effectiveTimeout = responseTimeout - maxRoundTripLatency

        try await publishRpcRequest(destinationIdentity: destinationIdentity,
                                    requestId: requestId,
                                    method: method,
                                    payload: payload,
                                    responseTimeout: effectiveTimeout)

        do {
            return try await withThrowingTimeout(timeout: responseTimeout) {
                try await withCheckedThrowingContinuation { continuation in
                    Task {
                        await self.rpcState.addPendingAck(requestId)

                        await self.rpcState.setPendingResponse(requestId, response: PendingRpcResponse(
                            participantIdentity: destinationIdentity,
                            onResolve: { payload, error in
                                Task {
                                    await self.rpcState.removePendingAck(requestId)
                                    await self.rpcState.removePendingResponse(requestId)

                                    if let error {
                                        continuation.resume(throwing: error)
                                    } else {
                                        continuation.resume(returning: payload ?? "")
                                    }
                                }
                            }
                        ))
                    }

                    Task {
                        try await Task.sleep(nanoseconds: UInt64(maxRoundTripLatency * 1_000_000_000))

                        if await self.rpcState.hasPendingAck(requestId) {
                            await self.rpcState.removeAllPending(requestId)
                            continuation.resume(throwing: RpcError.builtIn(.connectionTimeout))
                        }
                    }
                }
            }
        } catch {
            if let error = error as? LiveKitError {
                if error.type == .timedOut {
                    throw RpcError.builtIn(.connectionTimeout)
                }
            }
            throw error
        }
    }
}

// MARK: - RPC Internal

extension LocalParticipant {
    private func publishRpcRequest(destinationIdentity: Identity,
                                   requestId: String,
                                   method: String,
                                   payload: String,
                                   responseTimeout: TimeInterval = 10) async throws
    {
        guard payload.byteLength <= MAX_RPC_PAYLOAD_BYTES else {
            throw LiveKitError(.invalidParameter,
                               message: "cannot publish data larger than \(MAX_RPC_PAYLOAD_BYTES)")
        }

        let room = try requireRoom()

        let dataPacket = Livekit_DataPacket.with {
            $0.destinationIdentities = [destinationIdentity.stringValue]
            $0.kind = .reliable
            $0.rpcRequest = Livekit_RpcRequest.with {
                $0.id = requestId
                $0.method = method
                $0.payload = payload
                $0.responseTimeoutMs = UInt32(responseTimeout * 1000)
                $0.version = 1
            }
        }

        try await room.send(dataPacket: dataPacket)
    }

    private func publishRpcResponse(destinationIdentity: Identity,
                                    requestId: String,
                                    payload: String?,
                                    error: RpcError?) async throws
    {
        let room = try requireRoom()

        let dataPacket = Livekit_DataPacket.with {
            $0.destinationIdentities = [destinationIdentity.stringValue]
            $0.kind = .reliable
            $0.rpcResponse = Livekit_RpcResponse.with {
                $0.requestID = requestId
                if let error {
                    $0.error = error.toProto()
                } else {
                    $0.payload = payload ?? ""
                }
            }
        }

        try await room.send(dataPacket: dataPacket)
    }

    private func publishRpcAck(destinationIdentity: Identity,
                               requestId: String) async throws
    {
        let room = try requireRoom()

        let dataPacket = Livekit_DataPacket.with {
            $0.destinationIdentities = [destinationIdentity.stringValue]
            $0.kind = .reliable
            $0.rpcAck = Livekit_RpcAck.with {
                $0.requestID = requestId
            }
        }

        try await room.send(dataPacket: dataPacket)
    }

    func handleIncomingRpcRequest(callerIdentity: Identity,
                                  requestId: String,
                                  method: String,
                                  payload: String,
                                  responseTimeout: TimeInterval,
                                  version: Int) async
    {
        do {
            try await publishRpcAck(destinationIdentity: callerIdentity,
                                    requestId: requestId)
        } catch {
            log("[Rpc] Failed to publish RPC ack for \(requestId)", .error)
        }

        guard version == 1 else {
            do {
                try await publishRpcResponse(destinationIdentity: callerIdentity,
                                             requestId: requestId,
                                             payload: nil,
                                             error: RpcError.builtIn(.unsupportedVersion))
            } catch {
                log("[Rpc] Failed to publish RPC error response for \(requestId)", .error)
            }
            return
        }

        guard let handler = await rpcState.getHandler(for: method) else {
            do {
                try await publishRpcResponse(destinationIdentity: callerIdentity,
                                             requestId: requestId,
                                             payload: nil,
                                             error: RpcError.builtIn(.unsupportedMethod))
            } catch {
                log("[Rpc] Failed to publish RPC error response for \(requestId)", .error)
            }
            return
        }

        var responseError: RpcError?
        var responsePayload: String?

        do {
            let response = try await handler(RpcInvocationData(requestId: requestId,
                                                               callerIdentity: callerIdentity,
                                                               payload: payload,
                                                               responseTimeout: responseTimeout))

            if response.byteLength > MAX_RPC_PAYLOAD_BYTES {
                responseError = RpcError.builtIn(.responsePayloadTooLarge)
                log("[Rpc] Response payload too large for \(method)", .warning)
            } else {
                responsePayload = response
            }
        } catch let error as RpcError {
            responseError = error
        } catch {
            log("[Rpc] Uncaught error returned by RPC handler for \(method). Returning APPLICATION_ERROR instead.", .warning)
            responseError = RpcError.builtIn(.applicationError)
        }

        do {
            try await publishRpcResponse(destinationIdentity: callerIdentity,
                                         requestId: requestId,
                                         payload: responsePayload,
                                         error: responseError)
        } catch {
            log("[Rpc] Failed to publish RPC response for \(requestId)", .error)
        }
    }

    func handleIncomingRpcAck(requestId: String) {
        Task {
            await rpcState.removePendingAck(requestId)
        }
    }

    func handleIncomingRpcResponse(requestId: String,
                                   payload: String?,
                                   error: RpcError?)
    {
        Task {
            guard let handler = await rpcState.removePendingResponse(requestId) else {
                log("[Rpc] Response received for unexpected RPC request, id = \(requestId)", .error)
                return
            }

            handler.onResolve(payload, error)
        }
    }
}