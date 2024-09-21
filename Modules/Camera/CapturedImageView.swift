import SwiftUI

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
                    .edgesIgnoringSafeArea(.all)
                    .background(Color.black)
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
