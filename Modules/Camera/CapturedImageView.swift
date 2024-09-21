/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct CapturedImageView: View {
    var image: Image?
    var onDismiss: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea(.all)
                    .background(Color.black)
            } else {
                Color.gray.opacity(0.2)
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            .padding(.top, 40)
            .padding(.leading, 20)
        }
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static let previewImage = Image(systemName: "photo.fill")
    static var previews: some View {
        CapturedImageView(image: previewImage, onDismiss: {})
    }
}
