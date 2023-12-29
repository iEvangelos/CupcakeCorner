//
//  AsyncImageView.swift
//  CupcakeCorner
//
//  Created by Evangelos Pipis on 29/12/2023.
//

import SwiftUI

struct AsyncImageView: View {
    var body: some View {
        VStack {
            // To load a remote image from the internet you need to use AsyncImage instead of Image.
            // The image will not be scaleable. To fix this, we can tell SwiftUI ahead of time that we’re trying to load a 1x, 2x or 3x scale image, like this:
            AsyncImage(url: URL(string: "https://git-scm.com/images/logo@2x.png"), scale: 2)
            
            Spacer()
            
            // To adjust our image, you need to use a more advanced form of AsyncImage that passes us the final image view once it’s ready, which we can then customize as needed. 
            // As a bonus, this also gives us a second closure to customize the placeholder as needed.
            AsyncImage(url: URL(string: "https://www.hackingwithswift.com/img/book-understanding-swift.png")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.red
            }
            .frame(width: 200, height: 200)
            
            Spacer()
            
            // If you want complete control over your remote image, there’s a third way of creating AsyncImage that tells us whether the image was loaded, hit an error, or hasn’t finished yet.
            // This is particularly useful for times when you want to show a dedicated view when the download fails – if the URL doesn’t exist, or the user was offline, etc.
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Text("Could not load image.")
                } else {
                    ProgressView()
                }
            }
            .frame(width: 200, height: 200)
        }
    }
}

#Preview {
    AsyncImageView()
}
