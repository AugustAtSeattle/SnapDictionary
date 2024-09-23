import SwiftUI

struct CapturedImageView: View {
    var image: UIImage
    @ObservedObject var ocrViewModel: OCRViewModel
    @State private var showDictionaryDrawer = false
    var onDismiss: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                GeometryReader { imageGeometry in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageGeometry.size.width, height: imageGeometry.size.height)
                        .overlay(
                            ZStack {
                                ForEach(ocrViewModel.recognizedText) { textItem in
                                    TextOverlayView(
                                        textItem: textItem,
                                        imageSize: image.size,
                                        viewSize: imageGeometry.size
                                    )
                                    .onTapGesture {
                                        ocrViewModel.selectedText = textItem
                                        self.showDictionaryDrawer = true
                                    }
                                }
                            }
                        )
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            onDismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        .padding(.top, geometry.safeAreaInsets.top + 10)
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    Spacer()
                }
            }
            .sheet(isPresented: $showDictionaryDrawer, content: {
                if let selectedText = ocrViewModel.selectedText {
                    DictionaryDrawerView(
                        selectedText: selectedText.string,
                        viewModel: DictionaryViewModel(dictionaryService: DictionaryService())
                    )
                } else {
                    Text("No text selected")
                }
            })
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
