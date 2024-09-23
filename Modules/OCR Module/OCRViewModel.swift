//
//  OCRViewModel.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//
import Vision
import UIKit

class OCRViewModel: ObservableObject {
    @Published var recognizedText: [RecognizedText] = []
    @Published var isProcessing = false
    @Published var errorMessage: String?
    @Published var selectedText: RecognizedText?
    func performOCR(on image: UIImage) {
        isProcessing = true
        recognizedText = []
        errorMessage = nil

        guard let cgImage = image.cgImage else {
            errorMessage = "Invalid image."
            isProcessing = false
            return
        }

        // Convert UIImage orientation to CGImagePropertyOrientation
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)

        let request = VNRecognizeTextRequest { [weak self] (request, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "OCR Error: \(error.localizedDescription)"
                    self?.isProcessing = false
                }
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No text found."
                    self?.isProcessing = false
                }
                return
            }

            let recognizedTexts = observations.compactMap { observation -> RecognizedText? in
                guard let topCandidate = observation.topCandidates(1).first else { return nil }
                guard !topCandidate.string.isEmpty else {return nil}
                return RecognizedText(string: topCandidate.string, boundingBox: observation.boundingBox)
            }

            DispatchQueue.main.async {
                self?.recognizedText = recognizedTexts
                self?.isProcessing = false
            }
        }

        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en"] // Adjust as needed
        request.usesLanguageCorrection = true

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: cgOrientation, options: [:])

        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try requestHandler.perform([request])
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.errorMessage = "Failed to perform OCR: \(error.localizedDescription)"
                    self?.isProcessing = false
                }
            }
        }
    }
}

// Helper function to convert UIImageOrientation to CGImagePropertyOrientation
extension CGImagePropertyOrientation {
    init(_ uiImageOrientation: UIImage.Orientation) {
        switch uiImageOrientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
