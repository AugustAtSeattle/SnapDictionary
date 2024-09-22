/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct CameraPreviewImageView: View {
    @Binding var image: Image?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct ViewfinderView_Previews: PreviewProvider {
    static var previews: some View {
        CameraPreviewImageView(image: .constant(Image(systemName: "pencil")))
    }
}
