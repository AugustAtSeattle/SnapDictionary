/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

//struct CapturedImageView: View {
//    var image: Image?
//    
//    var body: some View {
//        ZStack {
//            Color.white
//            if let image = image {
//                image
//                    .resizable()
//                    .scaledToFill()
//            }
//        }
//        .frame(width: 41, height: 41)
//        .cornerRadius(11)
//    }
//}

struct CapturedImageView: View {
    var image: Image?

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2) // Background color
            if let image = image {
                image
                    .resizable()
                    .scaledToFit() // Scale the image to fit the view
                    .cornerRadius(15) // Rounded corners for the image
            } else {
                Image(systemName: "camera") // Placeholder icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static let previewImage = Image(systemName: "photo.fill")
    static var previews: some View {
        CapturedImageView(image: previewImage)
    }
}
