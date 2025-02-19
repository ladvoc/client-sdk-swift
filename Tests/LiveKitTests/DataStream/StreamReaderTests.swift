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

@testable import LiveKit
import XCTest

class StreamReaderTests: XCTestCase {
    
    func testResolveFileName() {
        // Static function defined on StreamReader protocol, access with concrete type.
        XCTAssertEqual(
            ByteStreamReader.resolveFileName(
                setName: nil,
                fallbackName: "[fallback]",
                mimeType: "text/plain",
                fallbackExtension: "bin"
            ),
            "[fallback].txt",
            "Fallback name should be used when no set name is provided"
        )
        XCTAssertEqual(
            ByteStreamReader.resolveFileName(
                setName: "name",
                fallbackName: "[fallback]",
                mimeType: "text/plain",
                fallbackExtension: "bin"
            ),
            "name.txt",
            "Set name should take precedence over fallback name"
        )
        XCTAssertEqual(
            ByteStreamReader.resolveFileName(
                setName: "name.jpeg",
                fallbackName: "[fallback]",
                mimeType: "text/plain",
                fallbackExtension: "bin"
            ),
            "name.jpeg",
            "File extension in set name should take precedence"
        )
        XCTAssertEqual(
            ByteStreamReader.resolveFileName(
                setName: "name",
                fallbackName: "[fallback]",
                mimeType: "image/jpeg",
                fallbackExtension: "bin"
            ),
            "name.jpeg",
            "File extension should be resolved from MIME type"
        )
        XCTAssertEqual(
            ByteStreamReader.resolveFileName(
                setName: "name",
                fallbackName: "[fallback]",
                mimeType: "text/invalid",
                fallbackExtension: "bin"
            ),
            "name.bin",
            "Fallback extension should be used when MIME type is not recognized"
        )
    }
}
