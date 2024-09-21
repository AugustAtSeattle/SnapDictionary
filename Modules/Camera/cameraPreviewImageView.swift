/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct cameraPreviewImageView: View {
    @Binding var image: Image?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct ViewfinderView_Previews: PreviewProvider {
    static var previews: some View {
        cameraPreviewImageView(image: .constant(Image(systemName: "pencil")))
    }
}
