import SwiftUI

struct CapturedImageView: View {
    var image: UIImage
    @ObservedObject var ocrViewModel: OCRViewModel
    var onDismiss: () -> Void

    @State private var showDictionaryDrawer = false
    @State private var selectedText: RecognizedText?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(
                        ZStack {
                            ForEach(ocrViewModel.recognizedText) { textItem in
                                TextOverlayView(
                                    textItem: textItem,
                                    imageSize: image.size,
                                    viewSize: geometry.size
                                )
                                .onTapGesture {
                                    selectedText = textItem
                                    showDictionaryDrawer = true
                                }
                            }
                        }
                    )

                // Exit button
                Button(action: {
                    onDismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(12)
                }
                .padding(.top, 40)
                .padding(.leading, 20)
            }
            .sheet(isPresented: $showDictionaryDrawer) {
                if let selectedText = selectedText {
                    DictionaryDrawerView(
                        selectedText: selectedText.string,
                        dictionaryViewModel: DictionaryViewModel()
                    )
                }
            }
        }
        .onAppear {
            ocrViewModel.performOCR(on: image)
        }
    }
}

// Add this preview struct at the end of the file
#Preview {
    let testImage = UIImage(named: "OCRSampleImage")!
    let ocrViewModel = OCRViewModel()
    
    return CapturedImageView(
        image: testImage,
        ocrViewModel: ocrViewModel,
        onDismiss: {}
    )
    .onAppear {
        ocrViewModel.performOCR(on: testImage)
    }
}
