/*
See the License.txt file for this sample’s licensing information.
*/

import AVFoundation
import SwiftUI
import os.log

final class CameraViewModel: ObservableObject {
    let camera = Camera()
    
    @Published var previewImage: Image?
    @Published var capturedImage: UIImage?
    @Published var isPhotoCaptured = false
    
    init() {
        Task {
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }
    }
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }

        for await image in imageStream {
            Task { @MainActor in
                previewImage = image
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }

        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                capturedImage = photoData.capturedImage
                isPhotoCaptured = true
            }
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        // Get the full-size image data
        guard let imageData = photo.fileDataRepresentation() else { return nil }

        // Create a UIImage from the image data
        guard let uiImage = UIImage(data: imageData) else { return nil }

        // Get the image size
        let imageSize = (width: Int(uiImage.size.width), height: Int(uiImage.size.height))

        // Return the PhotoData with the UIImage
        return PhotoData(capturedImage: uiImage, imageData: imageData, imageSize: imageSize)
    }
}

fileprivate struct PhotoData {
    var capturedImage: UIImage
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {

    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "DataModel")
