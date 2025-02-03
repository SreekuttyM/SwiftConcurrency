//
//  AsyncLet.swift
//  SwiftConcurrency
//
//  Created by Sreekutty Maya on 03/02/2025.
//

import SwiftUI


class AsyncLetViewModel : ObservableObject {
    @Published var items : [UIImage?] = []

    
    func fetchImage() async throws -> UIImage? {
        do {
            let (data,_) = try await URLSession.shared.data(from: URL(string: "https://picsum.photos/200")!)
            let image  = UIImage(data: data)
            return image
        } catch {
            throw error
        }
    }
    
    func fetchTitle() async  -> String? {
            return "abcdef"
        
    }
}


struct AsyncLet: View {
    var columns = [GridItem(.flexible()),GridItem(.flexible())]
   @ObservedObject var viewModel : AsyncLetViewModel = AsyncLetViewModel()
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns,spacing: 20) {
                ForEach(viewModel.items, id: \.self) {
                    image in
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
                
            }
        }.onAppear() {
            Task {
                async let fetchImage1 =  try await viewModel.fetchImage()
                async let fetchImage2 =  try await viewModel.fetchImage()
                async let fetchImage3 =  try await viewModel.fetchImage()
                async let fetchImage4 =  try await viewModel.fetchImage()
                async let fetchTitle5 =   await viewModel.fetchTitle()
//  same or diiferent type of functions  can be returned and used here
                let (image1,image2,image3,image4,title5) = await (try fetchImage1,try fetchImage2,try fetchImage3,try fetchImage4, fetchTitle5)
                viewModel.items.append(contentsOf: [image1,image2,image3,image4])
                
            }
            
        }
    }
    
    
}

#Preview {
    AsyncLet()
}
