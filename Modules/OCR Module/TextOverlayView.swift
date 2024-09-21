//
//  TextOverlayView.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//

import SwiftUI

struct TextOverlayView: View {
    let textItem: RecognizedText
    let imageSize: CGSize
    let viewSize: CGSize

    var body: some View {
        let rect = boundingBoxInViewSpace()

        return Rectangle()
            .stroke(Color.blue, lineWidth: 2)
            .background(Color.blue.opacity(0.2))
            .frame(width: rect.width, height: rect.height)
            .position(x: rect.midX, y: rect.midY)
    }

    func boundingBoxInViewSpace() -> CGRect {
        // Convert the bounding box from image coordinates to view coordinates
        // Vision bounding boxes are normalized with origin at bottom-left
        // SwiftUI coordinates have origin at top-left

        let imageAspectRatio = imageSize.width / imageSize.height
        let viewAspectRatio = viewSize.width / viewSize.height

        let scaleFactor: CGFloat
        let xOffset: CGFloat
        let yOffset: CGFloat

        if imageAspectRatio > viewAspectRatio {
            // Image is wider than the view
            scaleFactor = viewSize.width / imageSize.width
            let scaledImageHeight = imageSize.height * scaleFactor
            xOffset = 0
            yOffset = (viewSize.height - scaledImageHeight) / 2
        } else {
            // Image is taller than the view
            scaleFactor = viewSize.height / imageSize.height
            let scaledImageWidth = imageSize.width * scaleFactor
            xOffset = (viewSize.width - scaledImageWidth) / 2
            yOffset = 0
        }

        let rect = textItem.boundingBox

        let rectX = rect.origin.x * imageSize.width * scaleFactor + xOffset
        let rectY = (1 - rect.origin.y - rect.size.height) * imageSize.height * scaleFactor + yOffset
        let rectWidth = rect.size.width * imageSize.width * scaleFactor
        let rectHeight = rect.size.height * imageSize.height * scaleFactor

        return CGRect(x: rectX, y: rectY, width: rectWidth, height: rectHeight)
    }
}
