import SwiftUI

struct CapturedImageView: View {
    var image: UIImage
    @ObservedObject var ocrViewModel: OCRViewModel
    @State private var showDictionaryDrawer = false
    @State private var selectedText: RecognizedText?
    var onDismiss: () -> Void
    
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
                Button(action: {
                    onDismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.black)
                }
                .padding(.top, 40)
                .padding(.leading, 20)
                .shadow(color: .gray, radius: 2, x: 0, y: 1)
            }
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { gesture in
                        if gesture.translation.width > 100 {
                            onDismiss()
                        }
                    }
            )
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
