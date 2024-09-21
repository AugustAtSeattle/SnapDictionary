//
//  RecognizedTextModel.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//

import SwiftUI

struct RecognizedText: Identifiable {
    let id = UUID()
    let string: String
    let boundingBox: CGRect
}
