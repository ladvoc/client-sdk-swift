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

#if os(iOS)

import AVFoundation
import CoreImage

struct BroadcastImageCodec {
    // Initializing a CIContext object is costly, so we use a singleton instead
    private static let imageContext = CIContext(options: nil)
    private static let colorSpace = CGColorSpaceCreateDeviceRGB()

    /// Encode the given image buffer to JPEG data.
    ///
    /// - Warning: The given image buffer must already have its base address locked.
    ///
    static func jpegData(from imageBuffer: CVImageBuffer, quality: CGFloat) -> Data? {
        let image = CIImage(cvPixelBuffer: imageBuffer)
        guard #available(iOS 17.0, *) else {
            // Workaround for "unsupported file format 'public.heic'"
            guard let cgImage = Self.imageContext.createCGImage(image, from: image.extent) else {
                return nil
            }

            let data = NSMutableData()
            guard let imageDestination = CGImageDestinationCreateWithData(data, AVFileType.jpg as CFString, 1, nil) else {
                return nil
            }

            let options: [CFString: Any] = [kCGImageDestinationLossyCompressionQuality: quality]
            CGImageDestinationAddImage(imageDestination, cgImage, options as CFDictionary)

            guard CGImageDestinationFinalize(imageDestination) else {
                return nil
            }
            return data as Data
        }
        return Self.imageContext.jpegRepresentation(
            of: image,
            colorSpace: Self.colorSpace,
            options: [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: quality]
        )
    }
}
#endif
